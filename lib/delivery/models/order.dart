class Order {
  int? id;
  String? orderId;
  String? userId;
  String? agencyId;
  String? serviceType;
  String? nameSender;
  String? phoneNumberSender;
  String? nameReceiver;
  String? phoneNumberReceiver;
  int? mass;
  int? height;
  int? width;
  int? length;
  String? provinceSource;
  String? districtSource;
  String? wardSource;
  String? detailSource;
  double? longSource;
  double? latSource;
  String? provinceDest;
  String? districtDest;
  String? wardDest;
  String? detailDest;
  double? longDestination;
  double? latDestination;
  int? fee;
  String? parent;
  int? cod;
  dynamic shipper;
  int? statusCode;
  int? miss;
  dynamic sendImages;
  dynamic receiveImages;
  String? sendSignature;
  dynamic receiveSignature;
  String? qrcode;
  dynamic signature;
  int? paid;
  String? createdAt;
  String? lastUpdate;
  int? orderCode;
  String? completeDate;

  Order(
      {
        this.id,
        this.orderId,
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
      this.longSource,
      this.latSource,
      this.provinceDest,
      this.districtDest,
      this.wardDest,
      this.detailDest,
      this.longDestination,
      this.latDestination,
      this.fee,
      this.parent,
      this.cod,
      this.shipper,
      this.statusCode,
      this.miss,
      this.sendImages,
      this.receiveImages,
      this.sendSignature,
      this.receiveSignature,
      this.qrcode,
      this.signature,
      this.paid,
      this.createdAt,
      this.lastUpdate,
      this.orderCode});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json["order_id"];
    userId = json["user_id"];
    agencyId = json["agency_id"];
    serviceType = json["service_type"];
    nameSender = json["name_sender"];
    phoneNumberSender = json["phone_number_sender"];
    nameReceiver = json["name_receiver"];
    phoneNumberReceiver = json["phone_number_receiver"];
    mass = json["mass"];
    height = json["height"];
    width = json["width"];
    length = json["length"];
    provinceSource = json["province_source"];
    districtSource = json["district_source"];
    wardSource = json["ward_source"];
    detailSource = json["detail_source"];
    longSource = json["long_source"];
    latSource = json["lat_source"];
    provinceDest = json["province_dest"];
    districtDest = json["district_dest"];
    wardDest = json["ward_dest"];
    detailDest = json["detail_dest"];
    longDestination = json["long_destination"];
    latDestination = json["lat_destination"];
    fee = json["fee"];
    parent = json["parent"];
    cod = json["COD"];
    shipper = json["shipper"];
    statusCode = json["status_code"];
    miss = json["miss"];
    sendImages = json["send_images"];
    receiveImages = json["receive_images"];
    sendSignature = json["send_signature"];
    receiveSignature = json["receive_signature"];
    qrcode = json["qrcode"];
    signature = json["signature"];
    paid = json["paid"];
    createdAt = json["created_at"];
    lastUpdate = json["last_update"];
    orderCode = json["order_code"];
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
    _data["long_source"] = longSource;
    _data["lat_source"] = latSource;
    _data["province_dest"] = provinceDest;
    _data["district_dest"] = districtDest;
    _data["ward_dest"] = wardDest;
    _data["detail_dest"] = detailDest;
    _data["long_destination"] = longDestination;
    _data["lat_destination"] = latDestination;
    _data["fee"] = fee;
    _data["parent"] = parent;
    _data["COD"] = cod;
    _data["shipper"] = shipper;
    _data["status_code"] = statusCode;
    _data["miss"] = miss;
    _data["send_images"] = sendImages;
    _data["receive_images"] = receiveImages;
    _data["send_signature"] = sendSignature;
    _data["receive_signature"] = receiveSignature;
    _data["qrcode"] = qrcode;
    _data["signature"] = signature;
    _data["paid"] = paid;
    _data["created_at"] = createdAt;
    _data["last_update"] = lastUpdate;
    _data["order_code"] = orderCode;
    return _data;
  }
}
