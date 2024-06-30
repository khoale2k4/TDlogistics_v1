import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:logistics_app/client/models/current.dart';
import 'package:http_parser/http_parser.dart';

class UpdatingCustomerParams {
  String customerId;

  UpdatingCustomerParams({required this.customerId});
}

class UpdatingCustomerPayload {
  String? fullname;
  String? province;
  String? district;
  String? ward;
  String? detailAddress;

  UpdatingCustomerPayload({this.fullname, this.province, this.district, this.ward, this.detailAddress});

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'province': province,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
    };
  }
}

class SearchingCustomerPayload {
  String? fullname;
  String? province;
  String? district;
  String? ward;
  String? detailAddress;

  SearchingCustomerPayload({this.fullname, this.province, this.district, this.ward, this.detailAddress});

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'province': province,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
    };
  }
}

class UpdatingAvatarPayload {
  File avatar;  // In Dart, typically the file would be handled differently, but for simplicity, we use String.

  UpdatingAvatarPayload({required this.avatar});
}

class GettingAvatarParams {
  String customerId;

  GettingAvatarParams({required this.customerId});
}

class CustomerOperation {
  final String baseUrl = "https://api2.tdlogistics.net.vn/v2/customers";

  Future<Map<String, dynamic>> getAuthenticatedCustomerInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'), 
        headers: { "Cookie" : cookie!},
    );
    final decodedResponse = utf8.decode(response.bodyBytes);
    final data = json.decode(decodedResponse);
      return {'error': data['error'], 'message': data['message'], 'data': data['data']};
    } catch (error) {
      print("Error getting authenticated customer info: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateInfo(UpdatingCustomerParams params, UpdatingCustomerPayload payload) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update?customerId=${params.customerId}'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie' : cookie!
        },
        body: json.encode(payload.toJson()),
      );
      print("Payload: ");
      print(payload.toJson());
    final decodedResponse = utf8.decode(response.bodyBytes);
    final data = json.decode(decodedResponse);
      return {'error': "No error", 'message': data['message'], 'data': data['data']};
    } catch (error) {
      print("Error updating customer information: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> search(SearchingCustomerPayload payload) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload.toJson()),
      );
      final data = json.decode(response.body);
      return {'error': data['error'], 'message': data['message'], 'data': data['data']};
    } catch (error) {
      print("Error searching customer information: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateAvatar(UpdatingAvatarPayload info) async {
    var uri = Uri.parse('$baseUrl/avatar/update');
    var mimeTypeData =
        lookupMimeType(info.avatar.path, headerBytes: [0xFF, 0xD8])!.split('/');
    var request = http.MultipartRequest("PUT", uri);
    var file = await http.MultipartFile.fromPath('avatar', info.avatar.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    request.files.add(file);

    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Cookie'] = cookie!;
    
    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);
      return {'error': 'false', 'message': response.body};
    } catch (error) {
      print("Error updating avatar: $error");
      return {'error': error};
    }
  }

  Future<Map<String, dynamic>> getAvatar(GettingAvatarParams params) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/avatar/get?customerId=${params.customerId}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie' : cookie!,
        },
      );
      print(response.body);
      return {
        "error" : "No error",
        "data" : response.bodyBytes
      };
    } catch (error) {
      print("Error getting avatar: $error");
      return {'error': error.toString()};
    }
  }
}
