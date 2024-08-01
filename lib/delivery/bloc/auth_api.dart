import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/current.dart';

class AuthOperation {
  String baseUrl = "https://api2.tdlogistics.net.vn/v2/auth";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/basic/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

    final decodedResponse = utf8.decode(response.bodyBytes);
    final data = json.decode(decodedResponse);

      if (response.headers['set-cookie'] != null) {
        cookie = response.headers['set-cookie'];
      }
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error login: $error");
      return {'error': error.toString(), 'status': null};
    }
  }
}
