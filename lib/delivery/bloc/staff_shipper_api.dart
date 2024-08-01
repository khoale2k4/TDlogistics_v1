import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/current.dart';

class FindingAvatarCondition {
  String staffId;

  FindingAvatarCondition({required this.staffId});

  Map<String, dynamic> toJson() {
    return {'staff_id': staffId};
  }
}

class StaffsOperation {
  final String baseUrl = "https://api2.tdlogistics.net.vn/v2/staffs";

  Future<Map<String, dynamic>> getAuthenticatedStaffInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {'Cookie': cookie!},
      );

    final decodedResponse = utf8.decode(response.bodyBytes);
    final data = json.decode(decodedResponse);
      return {
        'error': data['error'],
        'data': data['data'],
        'message': data['message']
      };
    } catch (error) {
      print("Error getting authenticated staff information: $error");
      return {'error': error.toString()};
    }
  }
  Future<Map<String, dynamic>> getAvatar(
      FindingAvatarCondition condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/avatar/get?staffId=${condition.staffId}'),
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

class ShippersOperation {
  final String baseUrl = "https://api2.tdlogistics.net.vn/v2/tasks/shippers";
  Future<Map<String, dynamic>> getTask(GettingTasksCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get'),
        headers: 
        {
          'Content-Type': 'application/json', 
          'Cookie': cookie!,
        },
        body: jsonEncode({}),
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
        Uri.parse('$baseUrl/complete?id=${condition.id}'),
        headers: { 'Content-Type': 'application/json', 'Cookie': cookie!},
      );

    final decodedResponse = utf8.decode(response.bodyBytes);
    final data = json.decode(decodedResponse);
      print(data);
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
        Uri.parse('$baseUrl/history/get'),
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
}
