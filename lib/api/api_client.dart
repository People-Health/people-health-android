import 'package:http/http.dart' as http;
import 'dart:convert';

class APIClient {
  static const String serverUrl = 'http://seu-servidor-java.com';

  static Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$serverUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'usuario': username,
        'senha': password,
      }),
    );

    return _parseResponse(response);
  }

  static Future<Map<String, dynamic>?> fetchAcidentadoByRG(String rg) async {
    final response = await http.get(
      Uri.parse('$serverUrl/fetchAcidentado/$rg'),
      headers: {'Content-Type': 'application/json'},
    );

    return _parseResponse(response);
  }

  static Map<String, dynamic>? _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
