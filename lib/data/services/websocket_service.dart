import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A reconnecting websocket that hands JSON frames to subscribers.
///
/// The server's sockets deliver nothing while disconnected and drop on
/// backgrounding, network changes and deploys. This client therefore
/// reconnects with exponential backoff and jitter until [close] is called, and
/// reports connection state so consumers can refetch over HTTP on reconnect.
class BaseWebsocketService {
  BaseWebsocketService({
    this.initialBackoff = const Duration(seconds: 1),
    this.maxBackoff = const Duration(seconds: 30),
    WebSocketChannel Function(Uri uri)? connector,
  }) : _connector = connector ?? WebSocketChannel.connect;

  final Duration initialBackoff;
  final Duration maxBackoff;
  final WebSocketChannel Function(Uri uri) _connector;
  final Random _random = Random();

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  StreamController<bool>? _stateController;
  StreamSubscription? _channelSubscription;
  Timer? _reconnectTimer;
  Uri? _uri;
  int _attempt = 0;
  bool _closed = false;
  bool _connected = false;

  bool get isConnected => _connected;

  /// Frames from the server. Created lazily so consumers can subscribe before
  /// [connect] is called and survive reconnects.
  Stream<Map<String, dynamic>> get messages {
    _messageController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _messageController!.stream;
  }

  /// `true` on every (re)connect, `false` on every drop.
  Stream<bool> get connectionState {
    _stateController ??= StreamController<bool>.broadcast();
    return _stateController!.stream;
  }

  void connect(String url) {
    _closed = false;
    _uri = Uri.parse(url);
    _attempt = 0;
    _open();
  }

  /// Re-run the connection with a fresh URL (e.g. after a token refresh).
  void reconnect(String url) {
    _tearDownChannel();
    connect(url);
  }

  void _open() {
    if (_closed || _uri == null) return;
    _reconnectTimer?.cancel();
    _tearDownChannel();

    try {
      _channel = _connector(_uri!);
    } catch (err) {
      _scheduleReconnect();
      return;
    }

    _channelSubscription = _channel!.stream.listen(
      (rawData) {
        if (!_connected) {
          _connected = true;
          _attempt = 0;
          _stateController?.add(true);
        }
        try {
          final parsed = jsonDecode(rawData as String);
          if (parsed is Map<String, dynamic>) {
            _messageController?.add(parsed);
          }
        } catch (_) {
          // Ignore invalid socket payloads.
        }
      },
      onError: (Object error) {
        if (kDebugMode) debugPrint('websocket error: $error');
        _onDropped();
      },
      onDone: _onDropped,
      cancelOnError: true,
    );
  }

  void _onDropped() {
    final wasConnected = _connected;
    _connected = false;
    _channel = null;
    _channelSubscription = null;
    if (wasConnected) _stateController?.add(false);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_closed) return;
    _reconnectTimer?.cancel();
    final base = initialBackoff.inMilliseconds * (1 << min(_attempt, 5));
    final capped = min(base, maxBackoff.inMilliseconds);
    final jitter = _random.nextInt(max(1, capped ~/ 4));
    _attempt++;
    _reconnectTimer = Timer(Duration(milliseconds: capped + jitter), _open);
  }

  void send(Map<String, dynamic> payload) {
    final channel = _channel;
    if (channel == null || !_connected) {
      throw StateError('Websocket is not connected');
    }
    channel.sink.add(jsonEncode(payload));
  }

  void _tearDownChannel() {
    _channelSubscription?.cancel();
    _channelSubscription = null;
    _channel?.sink.close();
    _channel = null;
    _connected = false;
  }

  void close() {
    _closed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _tearDownChannel();
    _messageController?.close();
    _messageController = null;
    _stateController?.close();
    _stateController = null;
  }
}

class WalletWebsocketService extends BaseWebsocketService {
  WalletWebsocketService({super.connector});
  Stream<Map<String, dynamic>> get walletDataStream => messages;
}

class AgreementWebsocketService extends BaseWebsocketService {
  AgreementWebsocketService({super.connector});
  Stream<Map<String, dynamic>> get agreementStream => messages;
}
