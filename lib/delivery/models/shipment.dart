
class Shipment {
    String? shipmentId;
    String? agencyId;
    String? agencyIdDest;
    double? longSource;
    double? latSource;
    String? currentAgencyId;
    double? currentLat;
    double? currentLong;
    double? longDestination;
    double? latDestination;
    String? transportPartnerId;
    dynamic staffId;
    dynamic vehicleId;
    double? mass;
    String? orderIds;
    dynamic parent;
    int? status;
    String? createdAt;
    String? lastUpdate;

    Shipment({this.shipmentId, this.agencyId, this.agencyIdDest, this.longSource, this.latSource, this.currentAgencyId, this.currentLat, this.currentLong, this.longDestination, this.latDestination, this.transportPartnerId, this.staffId, this.vehicleId, this.mass, this.orderIds, this.parent, this.status, this.createdAt, this.lastUpdate});

    void fromJson(Map<String, dynamic> json) {
        shipmentId = json["shipment_id"];
        agencyId = json["agency_id"];
        agencyIdDest = json["agency_id_dest"];
        longSource = json["long_source"];
        latSource = json["lat_source"];
        currentAgencyId = json["current_agency_id"];
        currentLat = double.parse(json["current_lat"].toString());
        currentLong = double.parse(json["current_long"].toString());
        longDestination = double.parse(json["long_destination"].toString());
        latDestination = double.parse(json["lat_destination"].toString());
        transportPartnerId = json["transport_partner_id"];
        staffId = json["staff_id"];
        vehicleId = json["vehicle_id"];
        mass = double.parse(json["mass"].toString());
        orderIds = json["order_ids"];
        parent = json["parent"];
        status = json["status"];
        createdAt = json["created_at"];
        lastUpdate = json["last_update"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["shipment_id"] = shipmentId;
        _data["agency_id"] = agencyId;
        _data["agency_id_dest"] = agencyIdDest;
        _data["long_source"] = longSource;
        _data["lat_source"] = latSource;
        _data["current_agency_id"] = currentAgencyId;
        _data["current_lat"] = currentLat;
        _data["current_long"] = currentLong;
        _data["long_destination"] = longDestination;
        _data["lat_destination"] = latDestination;
        _data["transport_partner_id"] = transportPartnerId;
        _data["staff_id"] = staffId;
        _data["vehicle_id"] = vehicleId;
        _data["mass"] = mass;
        _data["order_ids"] = orderIds;
        _data["parent"] = parent;
        _data["status"] = status;
        _data["created_at"] = createdAt;
        _data["last_update"] = lastUpdate;
        return _data;
    }
}