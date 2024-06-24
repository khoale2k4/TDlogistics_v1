import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/current.dart';

class StaffsAuthenticate {
  String baseUrl = "https://api.tdlogistics.net.vn/api/v1/staffs";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.headers['set-cookie'] != null) {
        cookie = response.headers['set-cookie'];
      }

      return {
        'error': data['error'],
        'valid': data['valid'],
        'message': "Xác thực thành công."
      };
    } catch (error) {
      print('Error logging in: $error');
      return {
        'error': error.toString(),
        'status': error is http.Response ? error.statusCode : null,
      };
    }
  }

  Future<Map<String, dynamic>> sendOTP(String phoneNumber, String email) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/send_otp'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
          'email': email,
        }),
      );

      var data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print('Error sending OTP: $error');
      return {
        'error': error.toString(),
        'status': error is http.Response ? error.statusCode : null,
      };
    }
  }

  Future<Map<String, dynamic>> verifyOTP(
      String phoneNumber, String email, String otp) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/verify_otp'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
          'email': email,
          'otp': otp,
        }),
      );

      var data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print('Error verifying OTP: $error');
      return {
        'error': error.toString(),
        'status': error is http.Response ? error.statusCode : null,
      };
    }
  }
}

class CreatingStaffByAgencyInfo {
  String fullname;
  String username;
  String password;
  String dateOfBirth;
  String cccd;
  String email;
  String phoneNumber;
  String role;
  String position;
  double salary;
  double paidSalary;
  String province;
  String district;
  String town;
  String detailAddress;
  List<String>? managedWards;

  CreatingStaffByAgencyInfo({
    required this.fullname,
    required this.username,
    required this.password,
    required this.dateOfBirth,
    required this.cccd,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.position,
    required this.salary,
    required this.paidSalary,
    required this.province,
    required this.district,
    required this.town,
    required this.detailAddress,
    this.managedWards,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'username': username,
      'password': password,
      'date_of_birth': dateOfBirth,
      'cccd': cccd,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'position': position,
      'salary': salary,
      'paid_salary': paidSalary,
      'province': province,
      'district': district,
      'town': town,
      'detail_address': detailAddress,
      'managed_wards': managedWards,
    };
  }
}

class CreatingStaffByAdminInfo {
  String agencyId;
  String fullname;
  String username;
  String password;
  String dateOfBirth;
  String cccd;
  String email;
  String phoneNumber;
  String role;
  String position;
  double salary;
  double paidSalary;
  String province;
  String district;
  String town;
  String detailAddress;
  List<String>? managedWards;

  CreatingStaffByAdminInfo({
    required this.agencyId,
    required this.fullname,
    required this.username,
    required this.password,
    required this.dateOfBirth,
    required this.cccd,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.position,
    required this.salary,
    required this.paidSalary,
    required this.province,
    required this.district,
    required this.town,
    required this.detailAddress,
    this.managedWards,
  });

  Map<String, dynamic> toJson() {
    return {
      'agency_id': agencyId,
      'fullname': fullname,
      'username': username,
      'password': password,
      'date_of_birth': dateOfBirth,
      'cccd': cccd,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'position': position,
      'salary': salary,
      'paid_salary': paidSalary,
      'province': province,
      'district': district,
      'town': town,
      'detail_address': detailAddress,
      'managed_wards': managedWards,
    };
  }
}

class FindingStaffByStaffCondition {
  String staffId;

  FindingStaffByStaffCondition({required this.staffId});

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId};
  }
}

class FindingStaffByAdminConditions {
  String staffId;
  String fullname;
  String username;
  String dateOfBirth;
  String cccd;
  String email;
  String phoneNumber;
  String role;
  String province;
  String district;
  String town;

  FindingStaffByAdminConditions({
    required this.staffId,
    required this.fullname,
    required this.username,
    required this.dateOfBirth,
    required this.cccd,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.province,
    required this.district,
    required this.town,
  });

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'fullname': fullname,
      'username': username,
      'date_of_birth': dateOfBirth,
      'cccd': cccd,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'province': province,
      'district': district,
      'town': town,
    };
  }
}

class UpdatingStaffInfo {
  String? fullname;
  String? username;
  String? dateOfBirth;
  String? email;
  String? phoneNumber;
  String? role;
  double? salary;
  double? paidSalary;
  String? province;
  String? district;
  String? town;
  String? detailAddress;
  List<String>? managedWards;

  UpdatingStaffInfo({
    this.fullname,
    this.username,
    this.dateOfBirth,
    this.email,
    this.phoneNumber,
    this.role,
    this.salary,
    this.paidSalary,
    this.province,
    this.district,
    this.town,
    this.detailAddress,
    this.managedWards,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'username': username,
      'date_of_birth': dateOfBirth,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'salary': salary,
      'paid_salary': paidSalary,
      'province': province,
      'district': district,
      'town': town,
      'detail_address': detailAddress,
      'managed_wards': managedWards,
    };
  }
}

class UpdatingStaffCondition {
  String staffId;

  UpdatingStaffCondition({required this.staffId});

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId};
  }
}

class DeletingStaffCondition {
  String staffId;

  DeletingStaffCondition({required this.staffId});

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId};
  }
}

class UpdatingAvatarStaffInfo {
  Uint8List avatarFile;
  String filename;
  String mimeType;

  UpdatingAvatarStaffInfo({
    required this.avatarFile,
    required this.filename,
    required this.mimeType,
  });
}

class UpdatingPasswordsInfo {
  String newPassword;
  String confirmPassword;

  UpdatingPasswordsInfo({
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }
}

class FindingAvatarCondition {
  String staffId;

  FindingAvatarCondition({required this.staffId});

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId};
  }
}

class RemovingManagedWardsCondition {
  String staffId;

  RemovingManagedWardsCondition({required this.staffId});

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId};
  }
}

class RemovingManagedWardsInfo {
  List<String> removedWards;

  RemovingManagedWardsInfo({required this.removedWards});

  Map<String, dynamic> toJson() {
    return {'removed_wards': removedWards};
  }
}

class StaffsOperation {
  final String baseUrl = "https://api.tdlogistics.net.vn/api/v1/staffs";

  Future<Map<String, dynamic>> getAuthenticatedStaffInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_info'),
        headers: {'Cookie': cookie!},
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['info'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting authenticated staff information: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> findByStaff(
      FindingStaffByStaffCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search?staff_id=${condition.staffId}'),
        headers: {'Cookie': 'withCredentials=true'},
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting one staff: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> findByAdmin(
      FindingStaffByAdminConditions conditions) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(conditions.toJson()),
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting one staff: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> createByAdmin(
      CreatingStaffByAdminInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error creating new staff: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> createByAgency(
      CreatingStaffByAgencyInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error creating new staff: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> update(
      UpdatingStaffInfo info, UpdatingStaffCondition condition) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update?staff_id=${condition.staffId}'),
        headers: {'Content-Type': 'application/json', 'Cookie': cookie!},
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error updating staff: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteStaff(
      DeletingStaffCondition condition) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete?staff_id=${condition.staffId}'),
        headers: {'Cookie': 'withCredentials=true'},
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error deleting staff: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateAvatar(
      UpdatingAvatarStaffInfo info, UpdatingStaffCondition condition) async {
    try {
      final uri =
          Uri.parse('$baseUrl/update_avatar?staff_id=${condition.staffId}');
      final request = http.MultipartRequest('PATCH', uri)
        ..headers['Cookie'] = 'withCredentials=true'
        ..files.add(http.MultipartFile.fromBytes(
          'avatar',
          info.avatarFile,
          filename: info.filename,
          //contentType: MediaType.parse(info.mimeType),
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error uploading image: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/logout'),
        headers: {'Cookie': 'withCredentials=true'},
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error logging out: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      UpdatingPasswordsInfo info, UpdatingStaffCondition condition) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update_password?staff_id=${condition.staffId}'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error updating password: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAvatar(
      FindingAvatarCondition condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_avatar?staff_id=${condition.staffId}'),
        headers: {'Cookie': cookie!},
      );

      final data = response.bodyBytes;

      return {
        'error': 'No error',
        'data': data,
        'message': 'Avatar retrieved successfully'
      };
    } catch (error) {
      print('Error getting avatar: $error');
      return {
        'error': error.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> removeManagedWards(
      RemovingManagedWardsCondition condition,
      RemovingManagedWardsInfo info) async {
    try {
      final response = await http.patch(
        Uri.parse(
            '$baseUrl/remove_managed_wards?staff_id=${condition.staffId}'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error removing managed wards: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getShipperManagedWard(
      FindingStaffByStaffCondition condition) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/get_shipper_managed_wards?staff_id=${condition.staffId}'),
        headers: {'Cookie': 'withCredentials=true'},
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting shipper's managed wards: $error");
      return {'error': error.toString()};
    }
  }
}

class CreatingNewShipperTasksInfo {
  String shipmentId;
  String vehicleId;

  CreatingNewShipperTasksInfo({
    required this.shipmentId,
    required this.vehicleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'shipment_id': shipmentId,
      'vehicle_id': vehicleId,
    };
  }
}

class GettingTasksCondition {
  String? staffId;
  int? option;

  GettingTasksCondition({
    this.staffId,
    this.option,
  });

  Map<String, dynamic> toJson() {
    return {
      'staff_id': staffId,
      'option': option,
    };
  }
}

class ConfirmingCompletedTaskInfo {
  int id;

  ConfirmingCompletedTaskInfo({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class GettingShipperHistoryInfo {
  int? option;

  GettingShipperHistoryInfo({
    this.option,
  });

  Map<String, dynamic> toJson() {
    return {
      'option': option,
    };
  }
}

class DeletingShipperTasksCondition {
  int id;

  DeletingShipperTasksCondition({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class ShippersOperation {
  final String baseUrl = "https://api.tdlogistics.net.vn/api/v1/shippers";

  Future<Map<String, dynamic>> getObjectsCanHandleTask() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_objects'),
        headers: {'Cookie': 'withCredentials=true'},
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting object can handle task: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> createNewTasks(
      CreatingNewShipperTasksInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_tasks'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error creating new tasks: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getTask(GettingTasksCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_tasks'),
        headers: {'Content-Type': 'application/json', 'Cookie': cookie!},
        body: jsonEncode(condition.toJson()),
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting tasks: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> confirmCompletedTask(
      ConfirmingCompletedTaskInfo condition) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/confirm_completed?id=${condition.id}'),
        headers: {'Cookie': 'withCredentials=true'},
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error confirming completed task: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getHistory(
      GettingShipperHistoryInfo condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_history'),
        headers: {'Content-Type': 'application/json', 'Cookie': cookie!},
        body: jsonEncode(condition.toJson()),
      );

      final data = jsonDecode(response.body);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting history: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteTask(
      DeletingShipperTasksCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'withCredentials=true'
        },
        body: jsonEncode(condition.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error deleting task: $error");
      return {'error': error.toString()};
    }
  }
}
