class Order {
  String? orderId;
  String? userId;
  String? agencyId;
  String? serviceType;
  String? nameSender;
  String? phoneNumberSender;
  String? nameReceiver;
  String? phoneNumberReceiver;
  double? mass;
  double? height;
  double? width;
  double? length;
  String? provinceSource;
  String? districtSource;
  String? wardSource;
  String? detailSource;
  String? provinceDest;
  String? districtDest;
  String? wardDest;
  String? detailDest;
  double? longSource;
  double? latSource;
  double? longDestination;
  double? latDestination;
  double? fee;
  dynamic parent;
  List<String>? journey;
  dynamic cod;
  String? shipper;
  dynamic statusCode;
  int? miss;
  dynamic sendImages;
  dynamic receiveImages;
  dynamic sendSignature;
  dynamic receiveSignature;
  dynamic qrcode;
  dynamic signature;
  dynamic paid;
  dynamic createdAt;
  dynamic lastUpdate;
  dynamic orderCode;

  Order(
      {this.orderId,
      this.userId,
      this.agencyId,
      this.serviceType,
      this.nameSender,
      this.phoneNumberSender,
      this.nameReceiver,
      this.phoneNumberReceiver,
      this.mass,
      this.height,
      this.width,
      this.length,
      this.provinceSource,
      this.districtSource,
      this.wardSource,
      this.detailSource,
      this.provinceDest,
      this.districtDest,
      this.wardDest,
      this.detailDest,
      this.longSource,
      this.latSource,
      this.longDestination,
      this.latDestination,
      this.fee,
      this.journey,
      this.cod,
      this.shipper,
      this.statusCode,
      this.miss,
      this.qrcode,
      this.paid,
      this.createdAt,
      this.lastUpdate});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json["orderId"];
    userId = json["userId"];
    agencyId = json["agencyId"];
    serviceType = json["serviceType"];
    nameSender = json["nameSender"];
    phoneNumberSender = json["phoneNumberSender"];
    nameReceiver = json["nameReceiver"];
    phoneNumberReceiver = json["phoneNumberReceiver"];
    height = json["height"];
    width = json["width"];
    length = json["length"];
    mass = json["mass"];
    provinceSource = json["provinceSource"];
    districtSource = json["districtSource"];
    wardSource = json["wardSource"];
    detailSource = json["detailSource"];
    longSource = json["longSource"];
    latSource = json["latSource"];
    provinceDest = json["provinceDest"];
    districtDest = json["districtDest"];
    wardDest = json["wardDest"];
    detailDest = json["detailDest"];
    longDestination = json["longDestination"];
    latDestination = json["latDestination"];
    fee = json["fee"];
    parent = json["parent"];
    journey = json["journey"] == null ? [] : List<String>.from(json["journey"]);
    cod = json["cod"];
    shipper = json["shipper"];
    statusCode = json["statusCode"];
    miss = json["miss"];
    sendImages = json["sendImages"];
    receiveImages = json["receiveImages"];
    sendSignature = json["sendSignature"];
    receiveSignature = json["receiveSignature"];
    qrcode = json["qrcode"];
    signature = json["signature"];
    paid = json["paid"];
    createdAt = json["createdAt"] != null
        ? DateTime.fromMillisecondsSinceEpoch(json["createdAt"]).toString()
        : null;
    lastUpdate = json["lastUpdate"] != null
        ? DateTime.fromMillisecondsSinceEpoch(json["lastUpdate"]).toString()
        : null;
    orderCode = json["orderCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["order_id"] = orderId;
    _data["user_id"] = userId;
    _data["agency_id"] = agencyId;
    _data["service_type"] = serviceType;
    _data["name_sender"] = nameSender;
    _data["phone_number_sender"] = phoneNumberSender;
    _data["name_receiver"] = nameReceiver;
    _data["phone_number_receiver"] = phoneNumberReceiver;
    _data["mass"] = mass;
    _data["height"] = height;
    _data["width"] = width;
    _data["length"] = length;
    _data["province_source"] = provinceSource;
    _data["district_source"] = districtSource;
    _data["ward_source"] = wardSource;
    _data["detail_source"] = detailSource;
    _data["province_dest"] = provinceDest;
    _data["district_dest"] = districtDest;
    _data["ward_dest"] = wardDest;
    _data["detail_dest"] = detailDest;
    _data["long_source"] = longSource;
    _data["lat_source"] = latSource;
    _data["long_destination"] = longDestination;
    _data["lat_destination"] = latDestination;
    _data["fee"] = fee;
    if (journey != null) {
      _data["journey"] = journey;
    }
    _data["COD"] = cod;
    _data["shipper"] = shipper;
    _data["status_code"] = statusCode;
    _data["miss"] = miss;
    _data["qrcode"] = qrcode;
    _data["paid"] = paid;
    _data["created_at"] = createdAt;
    _data["last_update"] = lastUpdate;
    return _data;
  }
}
