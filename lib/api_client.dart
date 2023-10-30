import 'package:http/http.dart' as http;
import 'dart:convert';

class APIClient {
  static Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://seu-servidor-java.com/authenticate'), // Substitua pela URL e endpoint corretos
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'usuario': username,
        'senha': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
