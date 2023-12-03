import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class APIClient {
  static const String httpServerUrl = 'http://10.0.2.2:8080/flutter-app';
  static const String wsServerUrl = 'ws://10.0.2.2:8080/flutter-app';
  final channel = IOWebSocketChannel.connect(wsServerUrl);

  Future<Map<String, dynamic>?> authenticateUser(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$httpServerUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'usuario': username,
        'senha': password,
      }),
    );

    return _parseResponse(response);
  }

  Future<Map<String, dynamic>?> fetchAcidentadoByRG(String rg) async {
    final response = await http.get(
      Uri.parse('$httpServerUrl/fetchAcidentado/$rg'),
      headers: {'Content-Type': 'application/json'},
    );

    return _parseResponse(response);
  }

  void sendLocation(double latitude, double longitude) {
    String locationString = 'latitude: $latitude, longitude: $longitude';
    channel.sink.add(locationString);
  }

  Map<String, dynamic>? _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}