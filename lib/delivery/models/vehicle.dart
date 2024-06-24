import 'shipment.dart';

class Vehicle {
    int? id;
    String? shipmentId;
    String? staffId;
    String? vehicleId;
    String? createdAt;
    Shipment? shipment;

    Vehicle({this.id, this.shipmentId, this.staffId, this.vehicleId, this.createdAt, this.shipment});

    void fromJson(Map<String, dynamic> json) {
        id = json["id"];
        shipmentId = json["shipment_id"];
        staffId = json["staff_id"];
        vehicleId = json["vehicle_id"];
        createdAt = json["created_at"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["shipment_id"] = shipmentId;
        _data["staff_id"] = staffId;
        _data["vehicle_id"] = vehicleId;
        _data["created_at"] = createdAt;
        return _data;
    }
}