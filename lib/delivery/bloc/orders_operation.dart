// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:logistics_app/delivery/models/current.dart';

class CheckingExistOrderCondition {
  String orderId;

  CheckingExistOrderCondition({required this.orderId});
}

class GettingOrdersConditions {
  String? orderId;
  String? nameReceiver;
  String? phoneReceiver;
  String? provinceSource;
  String? districtSource;
  String? wardSource;
  String? provinceDest;
  String? districtDest;
  String? wardDest;
  int? serviceType;

  GettingOrdersConditions(
      {this.orderId,
      this.nameReceiver,
      this.phoneReceiver,
      this.provinceSource,
      this.districtSource,
      this.wardSource,
      this.provinceDest,
      this.districtDest,
      this.wardDest,
      this.serviceType});
}

class CreatingOrderByUserInformation {
  String nameSender;
  String nameReceiver;
  String phoneNumberReceiver;
  num mass;
  num height;
  num width;
  num length;
  String provinceSource;
  String districtSource;
  String wardSource;
  String detailSource;
  String provinceDest;
  String districtDest;
  String wardDest;
  String detailDest;
  num longSource;
  num latSource;
  num longDestination;
  num latDestination;
  num cod;
  String serviceType;

  Map<String, dynamic> toJson() {
    var rs = {
      'name_sender': nameSender,
      'name_receiver': nameReceiver,
      'phone_number_receiver': phoneNumberReceiver,
      'mass': mass,
      'height': height,
      'width': width,
      'length': length,
      'province_source': provinceSource,
      'district_source': districtSource,
      'ward_source': wardSource,
      'detail_source': detailSource,
      'province_dest': provinceDest,
      'district_dest': districtDest,
      'ward_dest': wardDest,
      'detail_dest': detailDest,
      'long_source': longSource,
      'lat_source': latSource,
      'long_destination': longDestination,
      'lat_destination': latDestination,
      'service_type': serviceType.split(":")[0],
    };
    return rs;
  }

  CreatingOrderByUserInformation(
      {required this.nameSender,
      required this.nameReceiver,
      required this.phoneNumberReceiver,
      required this.mass,
      required this.height,
      required this.width,
      required this.length,
      required this.provinceSource,
      required this.districtSource,
      required this.wardSource,
      required this.detailSource,
      required this.provinceDest,
      required this.districtDest,
      required this.wardDest,
      required this.detailDest,
      required this.longSource,
      required this.latSource,
      required this.longDestination,
      required this.latDestination,
      required this.cod,
      required this.serviceType});
}

class UpdatingOrderCondition {
  String orderId;

  UpdatingOrderCondition({required this.orderId});
}

class UpdatingOrderInfo {
  double? mass;
  double? height;
  double? width;
  double? length;
  double? cod;
  int? statusCode;

  UpdatingOrderInfo(
      {this.mass,
      this.height,
      this.width,
      this.length,
      this.cod,
      this.statusCode});
}

class CancelingOrderCondition {
  String orderId;

  CancelingOrderCondition({required this.orderId});
}

class UploadingOrderFileCondition {
  Uint8List file;
  String fileName;

  UploadingOrderFileCondition({required this.file, required this.fileName});
}

class CalculatingFeeInfo {
  String provinceSource;
  String districtSource;
  String wardSource;
  String detailSource;
  String provinceDest;
  String districtDest;
  String wardDest;
  String detailDest;
  String serviceType;
  double length;
  double width;
  double height;
  double mass;

  CalculatingFeeInfo({
    required this.provinceSource,
    required this.districtSource,
    required this.wardSource,
    required this.detailSource,
    required this.provinceDest,
    required this.districtDest,
    required this.wardDest,
    required this.detailDest,
    required this.serviceType,
    required this.length,
    required this.width,
    required this.height,
    required this.mass,
  });

  Map<String, dynamic> toJson() {
    return {
      'provinceSource': provinceSource,
      'districtSource': districtSource,
      'wardSource': wardSource,
      'detailSource': detailSource,
      'provinceDest': provinceDest,
      'districtDest': districtDest,
      'wardDest': wardDest,
      'detailDest': detailDest,
      'serviceType': serviceType,
      'length': length,
      'width': width,
      'height': height,
      'mass': mass,
    };
  }
}

class UploadImages {
  List<File> files;

  UploadImages({required this.files});
}

class UploadSignature {
  File file;

  UploadSignature({required this.file});
}

class UpdatingOrderImageInfo {
  List<Uint8List> files;
  List<String> fileNames;

  UpdatingOrderImageInfo({required this.files, required this.fileNames});
}

class UpdatingOrderImageCondition {
  String orderId;
  String type;

  UpdatingOrderImageCondition({required this.orderId, required this.type});
}

class UpdatingOrderSignatureInfo {
  Uint8List signature;
  String fileName;

  UpdatingOrderSignatureInfo({required this.signature, required this.fileName});
}

class OrdersOperation {
  final String baseUrl;
  final Dio dio;

  OrdersOperation()
      : baseUrl = 'https://api2.tdlogistics.net.vn/v2/orders',
        dio = Dio();

  Future<Map<String, dynamic>> get(String orderId) async {
    var uri = Uri.parse('$baseUrl/search');

    try {
      print(cookie);
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json', "Cookie": cookie!},
          body: jsonEncode({"orderId": orderId}));

      final decodedResponse = utf8.decode(response.bodyBytes);
      final respon = json.decode(decodedResponse);
      if (response.statusCode == 400) {
        return {"error": true, "message": response.body};
      }
      return {
        "error": false,
        "data": respon["data"],
        "message": respon["message"],
      };
    } catch (error) {
      return {"error": true, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> calculateFee(CalculatingFeeInfo info) async {
    try {
      final uri = Uri.parse('$baseUrl/calculate_fee');
      final headers = {'Content-Type': 'application/json', 'Cookie': cookie!};
      final response = await http.post(uri,
          headers: headers, body: jsonEncode(info.toJson()));
      print(jsonEncode(info));
      final data = json.decode(response.body);
      return {
        'error': "No error",
        'data': data['data'],
        'message': data['message']
      };
    } catch (e) {
      print('Error calculating fee: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> update(
      UpdatingOrderInfo info, UpdatingOrderCondition condition) async {
    try {
      var uri = Uri.parse('$baseUrl/update?orderId=${condition.orderId}');
      var headers = {'Content-Type': 'application/json', "Cookie": cookie!};
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(
          {
            "height": info.height,
            "width": info.width,
            "length": info.length,
            "mass": info.mass,
            "cod": info.cod,
          },
        ),
      );
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      print(data);
      return {
        'error': response.statusCode == 200 ? "No error" : data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (e) {
      print('Error updating order: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getImage(String orderId, String type) async {
    try {
      final uri =
          Uri.parse('$baseUrl/image/get?orderId=${orderId}&type=${type}');
      final headers = {'Content-Type': 'application/json', 'Cookie': cookie!};
      final response = await http.get(uri, headers: headers);
      final bytes = response.bodyBytes;
      final archive = ZipDecoder().decodeBytes(bytes);
      List<Uint8List> extractedFiles = [];

      for (final file in archive) {
        if (file.isFile) {
          final data = file.content as List<int>;
          extractedFiles.add(Uint8List.fromList(data));
        }
      }
      return {
        'error': "No error",
        'data': extractedFiles,
        'message': 'messageee'
      };
    } catch (e) {
      print('Error getting image: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getSig(String orderId, String type) async {
    try {
      final uri =
          Uri.parse('$baseUrl/signature/get?orderId=${orderId}&type=${type}');
      final headers = {'Content-Type': 'application/json', 'Cookie': cookie!};
      final response = await http.get(uri, headers: headers);
      final bytes = response.bodyBytes;
      return {'error': "No error", 'data': bytes, 'message': 'messageee'};
    } catch (e) {
      print('Error getting image: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateImages(
      String orderId, String taskId, UploadImages info) async {
    var uri = Uri.parse(
        '$baseUrl/image/update?orderId=${orderId}&taskId=${taskId}&type=receive');
    var request = http.MultipartRequest("PUT", uri);

    for (var i = 0; i < info.files.length; i++) {
      var mimeTypeData =
          lookupMimeType(info.files[i].path, headerBytes: [0xFF, 0xD8])!
              .split('/');
      var file = await http.MultipartFile.fromPath('image', info.files[i].path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      request.files.add(file);
    }

    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Cookie'] = cookie!;

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);
      if(response.statusCode == 413) {
        return {
          'error' : true,
          'message' : "Reached max size"
        };
      }
      
      final decodedResponse = utf8.decode(response.bodyBytes);
      var data = json.decode(decodedResponse);
      return {'error': data["error"], 'message': data["message"]};
    } catch (error) {
      print("Error updating images: $error");
      return {'error': error};
    }
  }

  Future<Map<String, dynamic>> updateSignature(
      String orderId, String taskId, UploadSignature info) async {
    var uri = Uri.parse(
        '$baseUrl/signature/update?orderId=$orderId&taskId=$taskId&type=receive');
    var mimeTypeData =
        lookupMimeType(info.file.path, headerBytes: [0xFF, 0xD8])?.split('/');
    if (mimeTypeData == null || mimeTypeData.length != 2) {
      return {'error': 'Invalid file type'};
    }

    var request = http.MultipartRequest("PUT", uri);
    var file = await http.MultipartFile.fromPath(
      'image',
      info.file.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    request.files.add(file);
    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Cookie'] = cookie!;
    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);
      if(response.statusCode == 413) {
        return {
          'error' : true,
          'message' : "Reached max size"
        };
      }
    
      final decodedResponse = utf8.decode(response.bodyBytes);
      var data = json.decode(decodedResponse);

      return {'error': data["error"], 'message': data["message"]};
    } catch (error) {
      print("Error updating signature: $error");
      return {'error': error.toString()};
    }
  }
}

extension on CreatingOrderByUserInformation {
  Map<String, dynamic> toJson() {
    return {
      'name_sender': nameSender,
      'name_receiver': nameReceiver,
      'phone_number_receiver': phoneNumberReceiver,
      'mass': mass,
      'height': height,
      'width': width,
      'length': length,
      'province_source': provinceSource,
      'district_source': districtSource,
      'ward_source': wardSource,
      'detail_source': detailSource,
      'province_dest': provinceDest,
      'district_dest': districtDest,
      'ward_dest': wardDest,
      'detail_dest': detailDest,
      'long_source': longSource,
      'lat_source': latSource,
      'long_destination': longDestination,
      'lat_destination': latDestination,
      'COD': cod,
      'service_type': serviceType
    };
  }
}

extension on UpdatingOrderInfo {
  Map<String, dynamic> toJson() {
    return {
      'mass': mass,
      'height': height,
      'width': width,
      'length': length,
      'COD': cod,
      'statusCode': statusCode
    };
  }
}

extension on CalculatingFeeInfo {
  Map<String, dynamic> toJson() {
    return {
      'provinceSource': provinceSource,
      'districtSource': districtSource,
      'wardSource': wardSource,
      'detailSource': detailSource,
      'provinceDest': provinceDest,
      'districtDest': districtDest,
      'wardDest': wardDest,
      'detailDest': detailDest,
      'serviceType': serviceType,
      'length': length,
      'width': width,
      'height': height,
      'mass': mass
    };
  }
}
