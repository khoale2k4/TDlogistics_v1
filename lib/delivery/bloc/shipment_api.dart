import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/current.dart';

class CreatingShipmentInfo {
  String? agencyIdDest;

  CreatingShipmentInfo({this.agencyIdDest});
}

class FindingShipmentConditions {
  String? shipmentId;
  String? tranportPartnerId;
  String? staffId;

  FindingShipmentConditions({this.shipmentId, this.tranportPartnerId, this.staffId});
}

class DecomposingShipmentInfo {
  Map<String, dynamic> orderIds;

  DecomposingShipmentInfo({required this.orderIds});
}

class OperatingWithOrderInfo {
  Map<String, dynamic> orderIds;

  OperatingWithOrderInfo({required this.orderIds});
}

class ShipmentID {
  String shipmentId;

  ShipmentID({required this.shipmentId});
}

class UndertakingShipmentInfo {
  String shipmentId;

  UndertakingShipmentInfo({required this.shipmentId});
}


class ShipmentsOperation {
  final String baseUrl;

  ShipmentsOperation() : baseUrl = "https://api2.tdlogistics.net.vn/v2/shipments";

  Future<Map<String, dynamic>> check(ShipmentID condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/check?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'existed': data['existed'], 'message': data['message']};
    } catch (error) {
      print("Error checking exist shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllAgencies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_agencies'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error getting all agencies: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> create(CreatingShipmentInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error creating shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getOrdersFromShipment(ShipmentID condition) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_orders?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error getting orders from shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> addOrdersToShipment(ShipmentID condition, OperatingWithOrderInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_orders?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error adding orders to shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteOrderFromShipment(ShipmentID condition, OperatingWithOrderInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/remove_orders?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error deleting order from shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> confirmCreate(ShipmentID condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/confirm_create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(condition),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error confirming create shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> get(FindingShipmentConditions condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(condition),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'data': data['data'], 'message': data['message']};
    } catch (error) {
      print("Error getting shipments: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(ShipmentID condition) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error deleting shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> decompose(ShipmentID condition, DecomposingShipmentInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/decompose?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error decomposing shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> receive(ShipmentID condition) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/receive'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(condition),
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error receiving shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> undertake(UndertakingShipmentInfo info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/undertake'),
      headers: {'Content-Type': 'application/json', 'Cookie': cookie!},
        body: jsonEncode(info),
      );
      final data = jsonDecode(response.body);
      print(data);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error undertaking shipment: $error");
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> approve(ShipmentID condition) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/accept?shipment_id=${condition.shipmentId}'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      return {'error': data['error'], 'message': data['message']};
    } catch (error) {
      print("Error approving shipment: $error");
      return {'error': error.toString()};
    }
  }
}
