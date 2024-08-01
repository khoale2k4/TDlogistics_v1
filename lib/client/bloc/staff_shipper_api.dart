import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logistics_app/client/models/current.dart';

class StaffsOperation {
  final String baseUrl = "https://api2.tdlogistics.net.vn/v2/staffs";

  Future<Map<String, dynamic>> getStaffInfo(String staffId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {
          'Content-Type':'application/json',
          'Cookie': cookie!,
        },
        body: jsonEncode({"staffId": staffId}),
      );

      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting staff information: $error");
      return {'error': error.toString()};
    }
  }
}
