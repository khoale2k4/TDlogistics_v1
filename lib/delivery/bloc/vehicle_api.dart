import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/current.dart';

class CheckingExistVehicleCondition {
  final String vehicleId;

  CheckingExistVehicleCondition({required this.vehicleId});

  Map<String, dynamic> toJson() => {'vehicle_id': vehicleId};
}

class CreatingVehicleByAdminInfo {
  final String agencyId;
  final String transportPartnerId;
  final String staffId;
  final String type;
  final String licensePlate;
  final int maxLoad;

  CreatingVehicleByAdminInfo({
    required this.agencyId,
    required this.transportPartnerId,
    required this.staffId,
    required this.type,
    required this.licensePlate,
    required this.maxLoad,
  });

  Map<String, dynamic> toJson() => {
        'agency_id': agencyId,
        'transport_partner_id': transportPartnerId,
        'staff_id': staffId,
        'type': type,
        'license_plate': licensePlate,
        'max_load': maxLoad,
      };
}

class CreatingVehicleByAgencyInfo {
  final String transportPartnerId;
  final String staffId;
  final String type;
  final String licensePlate;
  final int maxLoad;

  CreatingVehicleByAgencyInfo({
    required this.transportPartnerId,
    required this.staffId,
    required this.type,
    required this.licensePlate,
    required this.maxLoad,
  });

  Map<String, dynamic> toJson() => {
        'transport_partner_id': transportPartnerId,
        'staff_id': staffId,
        'type': type,
        'license_plate': licensePlate,
        'max_load': maxLoad,
      };
}

class FindingVehicleByStaffCondition {
  final String staffId;

  FindingVehicleByStaffCondition({required this.staffId});

  Map<String, dynamic> toJson() => {'staff_id': staffId};
}

class FindingVehicleByAdminConditions {
  final String vehicleId;
  final String transportPartnerId;
  final String staffId;
  final String type;
  final String licensePlate;
  final double mass;

  FindingVehicleByAdminConditions({
    required this.vehicleId,
    required this.transportPartnerId,
    required this.staffId,
    required this.type,
    required this.licensePlate,
    required this.mass,
  });

  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicleId,
        'transport_partner_id': transportPartnerId,
        'staff_id': staffId,
        'type': type,
        'license_plate': licensePlate,
        'mass': mass,
      };
}

class GettingShipmentsContainedByVehicleCondition {
  final String vehicleId;

  GettingShipmentsContainedByVehicleCondition({required this.vehicleId});

  Map<String, dynamic> toJson() => {'vehicle_id': vehicleId};
}

class UpdatingVehicleInfo {
  final String? transportPartnerId;
  final String? staffId;
  final String? type;
  final int? maxLoad;

  UpdatingVehicleInfo({
    this.transportPartnerId,
    this.staffId,
    this.type,
    this.maxLoad,
  });

  Map<String, dynamic> toJson() => {
        'transport_partner_id': transportPartnerId,
        'staff_id': staffId,
        'type': type,
        'max_load': maxLoad,
      };
}

class UpdatingVehicleCondition {
  final String vehicleId;

  UpdatingVehicleCondition({required this.vehicleId});

  Map<String, dynamic> toJson() => {'vehicle_id': vehicleId};
}

class AddingShipmentsToVehicleInfo {
  final Map<String, dynamic> shipmentIds;

  AddingShipmentsToVehicleInfo({required this.shipmentIds});

  Map<String, dynamic> toJson() => {'shipment_ids': shipmentIds};
}

class AddingShipmentsToVehicleCondition {
  final String vehicleId;

  AddingShipmentsToVehicleCondition({required this.vehicleId});

  Map<String, dynamic> toJson() => {'vehicle_id': vehicleId};
}

class DeletingShipmentsFromVehicleInfo {
  final Map<String, dynamic> shipmentIds;

  DeletingShipmentsFromVehicleInfo({required this.shipmentIds});

  Map<String, dynamic> toJson() => {'shipment_ids': shipmentIds};
}

class DeletingShipmentsFromVehicleCondition {
  final String vehicleId;

  DeletingShipmentsFromVehicleCondition({required this.vehicleId});

  Map<String, dynamic> toJson() => {'vehicle_id': vehicleId};
}

class UndertakingVehicleShipmentInfo {
  final String shipmentId;

  UndertakingVehicleShipmentInfo({required this.shipmentId});

  Map<String, dynamic> toJson() => {'shipment_id': shipmentId};
}

class DeletingVehicleCondition {
  final String vehicleId;

  DeletingVehicleCondition({required this.vehicleId});

  Map<String, dynamic> toJson() => {'vehicle_id': vehicleId};
}

class VehicleOperation {
  final String baseUrl;

  VehicleOperation()
      : baseUrl = "https://api.tdlogistics.net.vn/api/v1/vehicles";

  Future<Map<String, dynamic>> checkExist(
      CheckingExistVehicleCondition condition) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check?vehicle_id=${condition.vehicleId}'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return {
      'error': data['error'],
      'existed': data['existed'],
      'message': data['message']
    };
  }

  Future<Map<String, dynamic>> createByAgency(
      CreatingVehicleByAgencyInfo info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(info.toJson()),
    );
    final data = jsonDecode(response.body);
    return {'error': data['error'], 'message': data['message']};
  }

  Future<Map<String, dynamic>> createByAdmin(
      CreatingVehicleByAdminInfo info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(info.toJson()),
    );
    final data = jsonDecode(response.body);
    return {'error': data['error'], 'message': data['message']};
  }

  Future<Map<String, dynamic>> findByStaff(
      FindingVehicleByStaffCondition condition) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search?staff_id=${condition.staffId}'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return {
      'error': data['error'],
      'data': data['data'],
      'message': data['message']
    };
  }

  Future<Map<String, dynamic>> findByAdmin(
      FindingVehicleByAdminConditions conditions) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(conditions.toJson()),
    );
    final data = jsonDecode(response.body);
    return {
      'error': data['error'],
      'data': data['data'],
      'message': data['message']
    };
  }

  Future<Map<String, dynamic>> getShipment(
      GettingShipmentsContainedByVehicleCondition condition) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_shipments?vehicle_id=${condition.vehicleId}'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return {
      'error': data['error'],
      'data': data['data'],
      'message': data['message']
    };
  }

  Future<Map<String, dynamic>> update(
      UpdatingVehicleInfo info, UpdatingVehicleCondition condition) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update?vehicle_id=${condition.vehicleId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(info.toJson()),
    );
    final data = jsonDecode(response.body);
    return {'error': data['error'], 'message': data['message']};
  }

  Future<Map<String, dynamic>> addShipments(AddingShipmentsToVehicleInfo info,
      AddingShipmentsToVehicleCondition condition) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/add_shipments?vehicle_id=${condition.vehicleId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(info.toJson()),
    );
    final data = jsonDecode(response.body);
    return {
      'error': data['error'],
      'info': data['info'],
      'message': data['message']
    };
  }

  Future<Map<String, dynamic>> deleteShipments(
      DeletingShipmentsFromVehicleInfo info,
      DeletingShipmentsFromVehicleCondition condition) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/delete_shipments?vehicle_id=${condition.vehicleId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(info.toJson()),
    );
    final data = jsonDecode(response.body);
    return {
      'error': data['error'],
      'info': data['info'],
      'message': data['message']
    };
  }

  Future<Map<String, dynamic>> undertakeShipment(
      UndertakingVehicleShipmentInfo info) async {
    final response = await http.get(
      Uri.parse('$baseUrl/undertake?shipment_id=${info.shipmentId}'),
      headers: {'Content-Type': 'application/json', 'Cookie': cookie!},
    );
    final data = jsonDecode(response.body);
    return {'error': data['error'], 'message': data['message']};
  }

  Future<Map<String, dynamic>> deleteVehicle(
      DeletingVehicleCondition condition) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete?vehicle_id=${condition.vehicleId}'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return {'error': data['error'], 'message': data['message']};
  }
}
