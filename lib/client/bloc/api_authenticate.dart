import 'package:http/http.dart' as http;
import 'package:logistics_app/client/models/current.dart';
import 'dart:convert';

class AuthOperation {
  final String baseUrl = "https://api2.tdlogistics.net.vn/v2/auth/otp";

  Future<Map<String, dynamic>> sendOTP(String phoneNumber, String email) async {
    try {
      final uri = Uri.parse('$baseUrl/send');
      final headers = {'Content-Type': 'application/json'};

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'phoneNumber': phoneNumber,
          'email': email,
        }),
      );

      if (response.headers['Set-Cookie'] != null) {
        cookie = response.headers['Set-Cookie'];
      }

      if (response.statusCode == 200) {
        return {
          'error': 'No error',
          'message': response.body,
        };
      } else {
        return {
          'error': response.body,
          'request': response.request?.toString(),
          'status': response.statusCode,
        };
      }
    } catch (error) {
      print("Error sending OTP: $error");
      return {
        'error': error.toString(),
        'request': null,
        'status': null,
      };
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String phoneNumber, String otp, String email) async {
    try {
      final uri = Uri.parse('$baseUrl/verify');
      final headers = {'Content-Type': 'application/json'};

      if (cookie != null) {
        headers['Cookie'] = cookie!;
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          'phoneNumber': phoneNumber,
          'otp': otp,
          'email' : email
        }),
      );

      if (response.headers['set-cookie'] != null) {
        cookie = response.headers['set-cookie'];
      }

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        return {
          'error': "No error",
          'valid': data["valid"],
          'message': data['message'],
        };
      } else {
        return {
          'error': response.body,
          'request': response.request?.toString(),
          'status': response.statusCode,
        };
      }
    } catch (error) {
      print("Error verifying OTP: $error");
      return {
        'error': error.toString(),
        'request': null,
        'status': null,
      };
    }
  }
}