import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class BaseWebsocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  StreamSubscription? _channelSubscription;

  // Return a stream immediately. The controller is created lazily so
  // consumers can subscribe before a socket connection is established.
  Stream<Map<String, dynamic>> get messages {
    _messageController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _messageController!.stream;
  }

  void connect(String url) {
    // Close any existing channel but keep the message controller so
    // subscribers remain connected and don't receive a StateError.
    _channelSubscription?.cancel();
    _channel?.sink.close();
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channelSubscription = _channel!.stream.listen(
      (rawData) {
        try {
          final parsed = jsonDecode(rawData);
          if (parsed is Map<String, dynamic>) {
            _messageController?.sink.add(parsed);
          }
        } catch (_) {
          // Ignore invalid socket payloads.
        }
      },
      onError: (error) {
        _messageController?.sink.addError(error);
      },
      onDone: () {
        _channel = null;
        _channelSubscription = null;
      },
      cancelOnError: true,
    );
  }

  void send(Map<String, dynamic> payload) {
    if (_channel == null) {
      throw StateError('Websocket is not connected');
    }
    _channel!.sink.add(jsonEncode(payload));
  }

  void close() {
    _channelSubscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _channelSubscription = null;
    _messageController?.close();
    _messageController = null;
  }
}

class WalletWebsocketService extends BaseWebsocketService {
  Stream<Map<String, dynamic>> get walletDataStream => messages;
}

class AgreementWebsocketService extends BaseWebsocketService {
  Stream<Map<String, dynamic>> get agreementStream => messages;
}
