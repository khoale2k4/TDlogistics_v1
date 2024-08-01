// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:logistics_app/client/models/current.dart';

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
  String phoneNumberSender;
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
      'nameSender': nameSender,
      'nameReceiver': nameReceiver,
      'phoneNumberReceiver': phoneNumberReceiver,
      'phoneNumberSender': phoneNumberSender,
      'mass': mass,
      'height': height,
      'width': width,
      'length': length,
      'provinceSource': provinceSource,
      'districtSource': districtSource,
      'wardSource': wardSource,
      'detailSource': detailSource,
      'provinceDest': provinceDest,
      'districtDest': districtDest,
      'cod': cod,
      'wardDest': wardDest,
      'detailDest': detailDest,
      'longSource': longSource,
      'latSource': latSource,
      'longDestination': longDestination,
      'latDestination': latDestination,
      'serviceType': serviceType.split(":")[0],
    };
    return rs;
  }

  CreatingOrderByUserInformation(
      {required this.nameSender,
      required this.nameReceiver,
      required this.phoneNumberReceiver,
      required this.phoneNumberSender,
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

class CreatingOrderByAdminAndAgencyInformation {
  String nameSender;
  String phoneNumberSender;
  String nameReceiver;
  String phoneNumberReceiver;
  double mass;
  double height;
  double width;
  double length;
  String provinceSource;
  String districtSource;
  String wardSource;
  String detailSource;
  String provinceDest;
  String districtDest;
  String wardDest;
  String detailDest;
  double longSource;
  double latSource;
  double longDestination;
  double latDestination;
  double cod;
  String serviceType;

  CreatingOrderByAdminAndAgencyInformation(
      {required this.nameSender,
      required this.phoneNumberSender,
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
  int? taskId;

  UpdatingOrderInfo(
      {this.mass,
      this.height,
      this.width,
      this.length,
      this.cod,
      this.statusCode,
      this.taskId});
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
  String provinceDest;
  String serviceType;
  double mass;

  CalculatingFeeInfo(
      {required this.provinceSource,
      required this.provinceDest,
      required this.serviceType,
      required this.mass});
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

  Future<Map<String, dynamic>> get() async {
    var uri = Uri.parse('$baseUrl/search');
    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
      "Cookie": cookie ?? ""
    };
    var body = {};
    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

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
      print(info.toJson());
      final uri = Uri.parse('$baseUrl/calculate_fee');
      final headers = {'Content-Type': 'application/json', 'Cookie': cookie!};
      final response = await http.post(uri,
          headers: headers, body: json.encode(info.toJson()));
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

  Future<Map<String, dynamic>> checkExist(
      CheckingExistOrderCondition condition) async {
    try {
      final response = await dio.get(
        '$baseUrl/check',
        queryParameters: {'order_id': condition.orderId},
      );
      return {
        'error': response.data['error'],
        'exist': response.data['existed'],
        'message': response.data['message']
      };
    } catch (e) {
      print('Error checking exist order: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createByUser(
      CreatingOrderByUserInformation info) async {
    var uri = Uri.parse('$baseUrl/create');
    var headers = {'Content-Type': 'application/json', "Cookie": cookie!};

    try {
      print(uri);
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(info),
      );

      print(json.encode(info));
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      print(data);

      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message'],
      };
    } catch (error) {
      return {"error": true, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> update(
      UpdatingOrderInfo info, UpdatingOrderCondition condition) async {
    try {
      var uri = Uri.parse('$baseUrl/update');
      var headers = {'Content-Type': 'application/json', "Cookie": cookie!};
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(
          {
            "taskId": info.taskId,
            "orderId": condition.orderId,
            "height": info.height,
            "width": info.width,
            "length": info.length,
            "mass": info.mass,
            "cod": info.cod,
            // "status_code": info.statusCode
          },
        ),
      );
      print(jsonEncode(
          {
            "taskId": info.taskId,
            "orderId": condition.orderId,
            "height": info.height,
            "width": info.width,
            "length": info.length,
            "mass": info.mass,
            "cod": info.cod,
            // "status_code": info.statusCode
          },
        ),);
      var data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (e) {
      print('Error updating order: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> cancel(CancelingOrderCondition condition) async {
    try {
      final response = await http.delete(
          Uri.parse('$baseUrl/cancel?orderId=${condition.orderId}'),
          headers: {"Cookie": cookie!});

      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      print(data);
      return {'error': data['error'], 'message': data['message']};
    } catch (e) {
      print('Error canceling order: $e');
      return {'error': e.toString()};
    }
  }
}

extension on CalculatingFeeInfo {
  Map<String, dynamic> toJson() {
    return {
      'provinceSource': provinceSource,
      'provinceDest': provinceDest,
      'serviceType': serviceType,
      'mass': mass
    };
  }
}
