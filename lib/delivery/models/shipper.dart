class Shipper {
  int? id;
  String? partnerId;
  String? agencyId;
  String? staffId;
  String? fullname;
  String? username;
  String? password;
  String? dateOfBirth;
  String? cccd;
  String? email;
  String? phoneNumber;
  String? province;
  String? district;
  String? town;
  String? role;
  String? detailAddress;
  String? position;
  String? bin;
  String? bank;
  dynamic avatar;
  String? imageLicense;
  int? active;
  String? createdAt;
  String? lastUpdate;

  Shipper(
      {this.id,
      this.partnerId,
      this.agencyId,
      this.staffId,
      this.fullname,
      this.username,
      this.password,
      this.dateOfBirth,
      this.cccd,
      this.email,
      this.phoneNumber,
      this.province,
      this.district,
      this.town,
      this.role,
      this.detailAddress,
      this.position,
      this.bin,
      this.bank,
      this.avatar,
      this.imageLicense,
      this.active,
      this.createdAt,
      this.lastUpdate});
  void fromJson(Map<String, dynamic> json) {
    id = json["id"];
    partnerId = json["partner_id"];
    agencyId = json["agency_id"];
    staffId = json["staff_id"];
    fullname = json["fullname"];
    username = json["username"];
    password = json["password"];
    dateOfBirth = json["date_of_birth"];
    cccd = json["cccd"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    province = json["province"];
    district = json["district"];
    town = json["town"];
    role = json["role"];
    detailAddress = json["detail_address"];
    position = json["position"];
    bin = json["bin"];
    bank = json["bank"];
    avatar = json["avatar"];
    imageLicense = json["image_license"];
    active = json["active"];
    createdAt = json["created_at"];
    lastUpdate = json["last_update"];
  }
}
