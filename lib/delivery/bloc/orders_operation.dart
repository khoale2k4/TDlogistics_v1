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

  CalculatingFeeInfo(
      {required this.provinceSource,
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
      : baseUrl = 'https://api.tdlogistics.net.vn/api/v1/orders',
        dio = Dio();

  Future<Map<String, dynamic>> get() async {
    var uri = Uri.parse('$baseUrl/search');
    var headers = {'Content-Type': 'application/json', "Cookie": cookie!};

    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode({}));

      var respon = json.decode(response.body);
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
      final uri = Uri.parse('$baseUrl/calculatefee');
      final headers = {'Content-Type': 'application/json', 'Cookie': cookie!};
      final response =
          await http.post(uri, headers: headers, body: info.toJson());
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

  Future<Map<String, dynamic>> checkFileFormat(
      // Get cookie
      UploadingOrderFileCondition info) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(info.file, filename: info.fileName)
      });

      final response = await dio.post('$baseUrl/check_file_format',
          data: formData,
          options: Options(
            headers: {'Content-Type': 'multipart/form-data'},
          ));

      return {
        'error': response.data['error'],
        'valid': response.data['valid'],
        'message': response.data['message']
      };
    } catch (e) {
      print('Error checking file format: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createByUser(
      CreatingOrderByUserInformation info) async {
    var uri = Uri.parse('$baseUrl/create');
    var headers = {'Content-Type': 'application/json', "Cookie": cookie!};

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(info),
      );

      if (response.statusCode == 400) {
        return {"error": true, "message": response.body};
      }

      return {
        "error": false,
        "message": response.body,
      };
    } catch (error) {
      return {"error": true, "message": error.toString()};
    }
  }

  void createByAdminAndAgency(
      dynamic socket, CreatingOrderByAdminAndAgencyInformation info) {
    try {
      socket.emit('notifyNewOrder', info.toJson());
    } catch (e) {
      print('Error creating new order: $e');
    }
  }

  Future<Map<String, dynamic>> createByFile(
      // Get cookie
      UploadingOrderFileCondition info) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(info.file, filename: info.fileName)
      });

      final response = await dio.post('$baseUrl/create_by_file',
          data: formData,
          options: Options(
            headers: {'Content-Type': 'multipart/form-data'},
          ));

      return {
        'error': response.data['error'],
        'message': response.data['message']
      };
    } catch (e) {
      print('Error creating orders by file: $e');
      return {'error': e.toString()};
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
            "order_id": condition.orderId,
            "height": info.height,
            "width": info.width,
            "length": info.length,
            "mass": info.mass,
            "cod": info.cod,
            // "status_code": info.statusCode
          },
        ),
      );
      var data = jsonDecode(response.body);
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

  Future<Map<String, dynamic>> cancel(
      // Get cookie
      CancelingOrderCondition condition) async {
    try {
      final response = await dio.delete(
        '$baseUrl/cancel',
        queryParameters: {'order_id': condition.orderId},
      );
      return {
        'error': response.data['error'],
        'message': response.data['message']
      };
    } catch (e) {
      print('Error canceling order: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateImage(
      // Get cookie
      UpdatingOrderImageInfo info,
      UpdatingOrderImageCondition condition) async {
    try {
      final formData = FormData();
      for (int i = 0; i < info.files.length; i++) {
        formData.files.add(MapEntry(
            'files',
            MultipartFile.fromBytes(info.files[i],
                filename: info.fileNames[i])));
      }

      final response = await dio.post(
        '$baseUrl/update_images',
        queryParameters: {
          'order_id': condition.orderId,
          'type': condition.type
        },
        data: formData,
      );

      print('Image uploaded successfully: ${response.data}');
      return response.data;
    } catch (e) {
      print('Error uploading image: $e');
      return {'error': e.toString()};
    }
  }

//   Future<List<String>> getImage(UpdatingOrderImageCondition condition) async {// Get cookie
//     try {
//       final response = await dio.get('$baseUrl/get_images',
//           queryParameters: {'order_id': condition.orderId, 'type': condition.type},
//           options: Options(responseType: ResponseType.bytes,));

//       final zipFile = ZipDecoder().decodeBytes(response.data);
//       final imageUrls = <String>[];

//       for (final file in zipFile.files) {
//         final bytes = file.content as List<int>;
//         final blob = Blob([Uint8List.fromList(bytes)]);
//         final url = Url.createObjectUrlFromBlob(blob);
//         imageUrls.add(url);
//       }

//       return imageUrls;
//     } catch (e) {
//       print('Error getting image: $e');
//       return [];
//     }
//   }

//   Future<Map<String, dynamic>> updateSignature(// Get cookie
//       UpdatingOrderSignatureInfo info, UpdatingOrderImageCondition condition) async {
//     try {
//       final formData = FormData.fromMap({
//         'signature': MultipartFile.fromBytes(info.signature, filename: info.fileName)
//       });

//       final response = await dio.post(
//           '$baseUrl/signature',
//           queryParameters: {'order_id': condition.orderId, 'type': condition.type},
//           data: formData,);

//       return {
//         'error': response.data['error'],
//         'message': response.data['message']
//       };
//     } catch (e) {
//       print('Error uploading image: $e');
//       return {'error': e.toString()};
//     }
//   }

//   Future<String> getSignature(UpdatingOrderImageCondition condition) async {// Get cookie
//     try {
//       final response = await dio.get('$baseUrl/signature',
//           queryParameters: {'order_id': condition.orderId, 'type': condition.type},
//           options: Options(responseType: ResponseType.bytes, ));

//       final blob = Blob([Uint8List.fromList(response.data)]);
//       final imgUrl = Url.createObjectUrlFromBlob(blob);

//       return imgUrl;
//     } catch (e) {
//       print('Error getting signature: $e');
//       return e.toString();
//     }
//   }
// }

// extension on GettingOrdersConditions {
//   Map<String, dynamic> toJson() {
//     return {
//       'order_id': orderId,
//       'name_receiver': nameReceiver,
//       'phone_receiver': phoneReceiver,
//       'province_source': provinceSource,
//       'district_source': districtSource,
//       'ward_source': wardSource,
//       'province_dest': provinceDest,
//       'district_dest': districtDest,
//       'ward_dest': wardDest,
//       'service_type': serviceType
//     };
//   }
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

extension on CreatingOrderByAdminAndAgencyInformation {
  Map<String, dynamic> toJson() {
    return {
      'name_sender': nameSender,
      'phone_number_sender': phoneNumberSender,
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
      'status_code': statusCode
    };
  }
}

extension on CalculatingFeeInfo {
  Map<String, dynamic> toJson() {
    return {
      'province_source': provinceSource,
      'district_source': districtSource,
      'ward_source': wardSource,
      'detail_source': detailSource,
      'province_dest': provinceDest,
      'district_dest': districtDest,
      'ward_dest': wardDest,
      'detail_dest': detailDest,
      'service_type': serviceType,
      'length': length,
      'width': width,
      'height': height,
      'mass': mass
    };
  }
}
