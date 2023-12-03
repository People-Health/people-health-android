import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class APIClient {
  static const String serverUrl = 'wss://10.0.2.2:8080/flutter-app';
  final channel = IOWebSocketChannel.connect(serverUrl);

  Future<Map<String, dynamic>?> authenticateUser(
      String username, String password) async {
    channel.sink.add(json.encode({
      'usuario': username,
      'senha': password,
    }));

    return _parseResponse();
  }

  Future<Map<String, dynamic>?> fetchAcidentadoByRG(String rg) async {
    channel.sink.add(json.encode({
      'rg': rg,
    }));

    return _parseResponse();
  }

  Future<Map<String, dynamic>?> _parseResponse() async {
    final response = await channel.stream.first;
    return json.decode(response);
  }
}