import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:logistics_app/delivery/models/current.dart';

class PartnerStaffAuthenticate {
  final String baseUrl = "https://api.tdlogistics.net.vn/api/v1/partner_staffs";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (response.headers["set-cookie"] != null) {
        cookie = response.headers["set-cookie"];
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'error': data['error'],
          'valid': data['valid'],
          'message': data['message']
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'error': data['error'],
          'valid': data['valid'],
          'message': data['message']
        };
      }
    } catch (error) {
      print("Error logging in: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }
}

class CreatingPartnerStaffInfo {
  String partnerId;
  String username;
  String password;
  String fullname;
  String email;
  String phoneNumber;
  String dateOfBirth;
  String cccd;
  String province;
  String district;
  String town;
  String detailAddress;
  String role;
  String position;
  String bin;
  String bank;

  CreatingPartnerStaffInfo({
    required this.partnerId,
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.cccd,
    required this.province,
    required this.district,
    required this.town,
    required this.detailAddress,
    required this.role,
    required this.position,
    required this.bin,
    required this.bank,
  });

  Map<String, dynamic> toJson() => {
        'partner_id': partnerId,
        'username': username,
        'password': password,
        'fullname': fullname,
        'email': email,
        'phone_number': phoneNumber,
        'date_of_birth': dateOfBirth,
        'cccd': cccd,
        'province': province,
        'district': district,
        'town': town,
        'detail_address': detailAddress,
        'role': role,
        'position': position,
        'bin': bin,
        'bank': bank,
      };
}

class FindingPartnerStaffByPartnerStaffCondition {
  String staffId;

  FindingPartnerStaffByPartnerStaffCondition({
    required this.staffId,
  });

  Map<String, dynamic> toJson() => {
        'staff_id': staffId,
      };
}

class FindingPartnerStaffsByPartnerConditions {
  String partnerId;
  String agencyId;
  String staffId;
  String username;
  String fullname;
  String dateOfBirth;
  String cccd;
  String email;
  String phoneNumber;
  String province;
  String district;
  String town;
  String position;
  String bin;
  String bank;

  FindingPartnerStaffsByPartnerConditions({
    required this.partnerId,
    required this.agencyId,
    required this.staffId,
    required this.username,
    required this.fullname,
    required this.dateOfBirth,
    required this.cccd,
    required this.email,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.town,
    required this.position,
    required this.bin,
    required this.bank,
  });

  Map<String, dynamic> toJson() => {
        'partner_id': partnerId,
        'agency_id': agencyId,
        'staff_id': staffId,
        'username': username,
        'fullname': fullname,
        'date_of_birth': dateOfBirth,
        'cccd': cccd,
        'email': email,
        'phone_number': phoneNumber,
        'province': province,
        'district': district,
        'town': town,
        'position': position,
        'bin': bin,
        'bank': bank,
      };
}

class FindingPartnerStaffsByAdminConditions {
  String partnerId;
  String agencyId;
  String staffId;
  String username;
  String fullname;
  String dateOfBirth;
  String email;
  String phoneNumber;
  String province;
  String district;
  String town;
  String position;
  String bin;
  String bank;

  FindingPartnerStaffsByAdminConditions({
    required this.partnerId,
    required this.agencyId,
    required this.staffId,
    required this.username,
    required this.fullname,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.town,
    required this.position,
    required this.bin,
    required this.bank,
  });

  Map<String, dynamic> toJson() => {
        'partner_id': partnerId,
        'agency_id': agencyId,
        'staff_id': staffId,
        'username': username,
        'fullname': fullname,
        'date_of_birth': dateOfBirth,
        'email': email,
        'phone_number': phoneNumber,
        'province': province,
        'district': district,
        'town': town,
        'position': position,
        'bin': bin,
        'bank': bank,
      };
}

class UpdatingPartnerStaffCondition {
  String staffId;

  UpdatingPartnerStaffCondition({
    required this.staffId,
  });

  Map<String, dynamic> toJson() => {
        'staff_id': staffId,
      };
}

class UpdatingPartnerStaffInfo {
  String? fullname;
  String? username;
  String? dateOfBirth;
  String? email;
  String? phoneNumber;
  String? province;
  String? district;
  String? town;
  String? detailAddress;
  String? position;
  String? bin;
  String? bank;

  UpdatingPartnerStaffInfo({
    this.fullname,
    this.username,
    this.dateOfBirth,
    this.email,
    this.phoneNumber,
    this.province,
    this.district,
    this.town,
    this.detailAddress,
    this.position,
    this.bin,
    this.bank,
  });

  Map<String, dynamic> toJson() => {
        if (fullname != null) 'fullname': fullname,
        if (username != null) 'username': username,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        if (email != null) 'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (province != null) 'province': province,
        if (district != null) 'district': district,
        if (town != null) 'town': town,
        if (detailAddress != null) 'detail_address': detailAddress,
        if (position != null) 'position': position,
        if (bin != null) 'bin': bin,
        if (bank != null) 'bank': bank,
      };
}

class DeletingPartnerStaffCondition {
  String staffId;

  DeletingPartnerStaffCondition({
    required this.staffId,
  });

  Map<String, dynamic> toJson() => {
        'staff_id': staffId,
      };
}

class CheckingExistPartnerStaffCondition {
  String username;
  String email;
  String phoneNumber;
  String bin;
  String cccd;

  CheckingExistPartnerStaffCondition({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.bin,
    required this.cccd,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'bin': bin,
        'cccd': cccd,
      };
}

class UpdatingPartnerLicenseImg {
  Uint8List licenseBefore;
  Uint8List licenseAfter;

  UpdatingPartnerLicenseImg({
    required this.licenseBefore,
    required this.licenseAfter,
  });
}

class UpdatingPartnerStaffAvatarInfo {
  Uint8List avatarFile;

  UpdatingPartnerStaffAvatarInfo({
    required this.avatarFile,
  });
}

class FindingPartnerAvatarAndLicenseCondition {
  String staffId;

  FindingPartnerAvatarAndLicenseCondition({
    required this.staffId,
  });

  Map<String, dynamic> toJson() => {
        'staff_id': staffId,
      };
}

class PartnerStaffOperation {
  final String baseUrl = "https://api.tdlogistics.net.vn/api/v1/partner_staffs";

  Future<Map<String, dynamic>> getAuthenticatedPartnerStaffInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_info'),
        headers: {'Content-Type': 'application/json', 'Cookie' : cookie!},
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error getting authenticated partner staff information: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> create(CreatingPartnerStaffInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error creating partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> findByPartnerStaff(FindingPartnerStaffByPartnerStaffCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(condition.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error finding partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> findByPartner(FindingPartnerStaffsByPartnerConditions conditions) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(conditions.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error finding partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> findByAdmin(FindingPartnerStaffsByAdminConditions conditions) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(conditions.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error finding partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> updatePartnerStaff(UpdatingPartnerStaffInfo info, UpdatingPartnerStaffCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update?staff_id=${condition.staffId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info.toJson()),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error updating partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> checkExist(CheckingExistPartnerStaffCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check?cccd=${condition.cccd}'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'existed': data['existed'], 'message': data['message']};
    } catch (error) {
      print("Error checking exist partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> deletePartnerStaff(DeletingPartnerStaffCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete?staff_id=${condition.staffId}'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error deleting partner staff: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> info) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info),
      );

      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error updating password: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> updatePartnerStaffAvatar(UpdatingPartnerStaffAvatarInfo info, UpdatingPartnerStaffCondition condition) async {
    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/update_avatar?staff_id=${condition.staffId}'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        info.avatarFile,
        filename: 'avatar.png',
      ));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final data = jsonDecode(responseData.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error updating avatar: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<Map<String, dynamic>> updatePartnerStaffLicense(UpdatingPartnerLicenseImg info, UpdatingPartnerStaffCondition condition) async {
    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/update_licenses?staff_id=${condition.staffId}'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'license_before',
        info.licenseBefore,
        filename: 'license_before.png',
      ));
      request.files.add(http.MultipartFile.fromBytes(
        'license_after',
        info.licenseAfter,
        filename: 'license_after.png',
      ));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final data = jsonDecode(responseData.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error updating licenses: $error");
      return {'error': error.toString(), 'request': error, 'status': null};
    }
  }

  Future<String> findPartnerStaffAvatar(FindingPartnerAvatarAndLicenseCondition condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_avatar?staff_id=${condition.staffId}'),
        headers: {'Content-Type': 'application/json',
        'Cookie' : cookie!},
      );

      final blob = response.bodyBytes;
      final fileUrl = Uri.dataFromBytes(blob, mimeType: response.headers['content-type']!).toString();

      return fileUrl;
    } catch (error) {
      print("Error getting avatar: $error");
      return error.toString();
    }
  }

  Future<String> findPartnerStaffLicenseBefore(FindingPartnerAvatarAndLicenseCondition condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_license_before?staff_id=${condition.staffId}'),
        headers: {'Content-Type': 'application/json'},
      );

      final blob = response.bodyBytes;
      final fileUrl = Uri.dataFromBytes(blob, mimeType: response.headers['content-type']!).toString();

      return fileUrl;
    } catch (error) {
      print("Error getting license before: $error");
      return error.toString();
    }
  }

  Future<String> findPartnerStaffLicenseAfter(FindingPartnerAvatarAndLicenseCondition condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_license_after?staff_id=${condition.staffId}'),
        headers: {'Content-Type': 'application/json'},
      );

      final blob = response.bodyBytes;
      final fileUrl = Uri.dataFromBytes(blob, mimeType: response.headers['content-type']!).toString();

      return fileUrl;
    } catch (error) {
      print("Error getting license after: $error");
      return error.toString();
    }
  }
}
