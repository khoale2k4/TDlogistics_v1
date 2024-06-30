import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/current.dart';

class CreatingNewDriverTasksInfo {
  List<String> shipmentIds;
  String vehicleId;

  CreatingNewDriverTasksInfo({
    required this.shipmentIds,
    required this.vehicleId,
  });

  Map<String, dynamic> toJson() => {
        'shipment_ids': shipmentIds,
        'vehicle_id': vehicleId,
      };
}

class GettingDriverTasksCondition {
  String? staffId;
  int? option;

  GettingDriverTasksCondition({
    this.staffId,
    this.option,
  });

  Map<String, dynamic> toJson() => {
        'staff_id': staffId,
        'option': option,
      };
}

class ConfirmingCompletedTaskCondition {
  int id;

  ConfirmingCompletedTaskCondition({required this.id});
}

class DeletingDriverTaskCondition {
  int id;

  DeletingDriverTaskCondition({required this.id});
}

class GettingHistoryInfo {
  int? option;

  GettingHistoryInfo({this.option});
}

class DriversOperation {
  final String baseUrl;

  DriversOperation() : baseUrl = 'https://api2.tdlogistics.net.vn/v2/drivers';

  // ROLE: ADMIN, MANAGER, HUMAN_RESOURCE_MANAGER, AGENCY_MANAGER, AGENCY_HUMAN_RESOURCE_MANAGER
  Future<Map<String, dynamic>> getObjectsCanHandleTask() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_objects'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print('Error getting object can handle task: $error');
      return {'error': error.toString(), 'status': null};
    }
  }

  // ROLE: ADMIN, MANAGER, HUMAN_RESOURCE_MANAGER, AGENCY_MANAGER, AGENCY_HUMAN_RESOURCE_MANAGER
  Future<Map<String, dynamic>> createNewTasks(CreatingNewDriverTasksInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_tasks'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(info.toJson()),
      );

      final data = json.decode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print('Error creating new tasks: $error');
      return {'error': error.toString(), 'status': null};
    }
  }

  // ROLE: ADMIN, MANAGER, HUMAN_RESOURCE_MANAGER, AGENCY_MANAGER, AGENCY_HUMAN_RESOURCE_MANAGER, PARTNER_DRIVER
  Future<Map<String, dynamic>> getTask(GettingDriverTasksCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_tasks'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie' : cookie!
        },
        body: json.encode(condition.toJson()),
      );

      final data = json.decode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print('Error getting tasks: $error');
      return {'error': error.toString(), 'status': null};
    }
  }

  // ROLE: PARTNER_DRIVER
  Future<Map<String, dynamic>> confirmCompletedTask(ConfirmingCompletedTaskCondition condition) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/confirm_completed?id=${condition.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print('Error confirming completed task: $error');
      return {'error': error.toString(), 'status': null};
    }
  }

  // ROLE: ADMIN, MANAGER, HUMAN_RESOURCE_MANAGER, AGENCY_MANAGER, AGENCY_HUMAN_RESOURCE_MANAGER
  Future<Map<String, dynamic>> deleteTask(DeletingDriverTaskCondition condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': condition.id}),
      );

      final data = json.decode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print('Error deleting task: $error');
      return {'error': error.toString(), 'status': null};
    }
  }
}
