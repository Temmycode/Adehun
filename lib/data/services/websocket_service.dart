import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WalletWebsocketService {
  late final WebSocketChannel _channel;
  final _walletDataController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get walletDataStream =>
      _walletDataController.stream;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (rawData) {
        final Map<String, dynamic> parsedData = jsonDecode(rawData);
        _walletDataController.sink.add(parsedData);
      },
      onError: (error) {
        _walletDataController.sink.addError(error);
      },
      onDone: () {
        close();
      },
    );
  }

  void close() {
    _channel.sink.close();
    _walletDataController.close();
  }
}
