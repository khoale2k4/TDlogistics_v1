
class Shipper {
    Account? account;
    String? agencyId;
    String? staffId;
    String? fullname;
    String? cccd;
    String? province;
    String? district;
    String? town;
    String? detailAddress;
    String? position;
    int? salary;
    List<int>? dateCreated;
    List<int>? dateModified;

    Shipper({this.account, this.agencyId, this.staffId, this.fullname, this.cccd, this.province, this.district, this.town, this.detailAddress, this.position, this.salary, this.dateCreated, this.dateModified});

    Shipper.fromJson(Map<String, dynamic> json) {
        account = json["account"] == null ? null : Account.fromJson(json["account"]);
        agencyId = json["agencyId"];
        staffId = json["staffId"];
        fullname = json["fullname"];
        cccd = json["cccd"];
        province = json["province"];
        district = json["district"];
        town = json["town"];
        detailAddress = json["detailAddress"];
        position = json["position"];
        salary = json["salary"];
        dateCreated = json["dateCreated"] == null ? null : List<int>.from(json["dateCreated"]);
        dateModified = json["dateModified"] == null ? null : List<int>.from(json["dateModified"]);
    }
}

class Account {
    String? id;
    String? username;
    String? password;
    String? phoneNumber;
    String? email;
    String? role;
    bool? active;
    List<int>? createdAt;
    List<int>? lastUpdate;
    bool? enabled;
    List<Authorities>? authorities;
    bool? accountNonExpired;
    bool? accountNonLocked;
    bool? credentialsNonExpired;

    Account({this.id, this.username, this.password, this.phoneNumber, this.email, this.role, this.active, this.createdAt, this.lastUpdate, this.enabled, this.authorities, this.accountNonExpired, this.accountNonLocked, this.credentialsNonExpired});

    Account.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        username = json["username"];
        password = json["password"];
        phoneNumber = json["phoneNumber"];
        email = json["email"];
        role = json["role"];
        active = json["active"];
        createdAt = json["createdAt"] == null ? null : List<int>.from(json["createdAt"]);
        lastUpdate = json["lastUpdate"] == null ? null : List<int>.from(json["lastUpdate"]);
        enabled = json["enabled"];
        authorities = json["authorities"] == null ? null : (json["authorities"] as List).map((e) => Authorities.fromJson(e)).toList();
        accountNonExpired = json["accountNonExpired"];
        accountNonLocked = json["accountNonLocked"];
        credentialsNonExpired = json["credentialsNonExpired"];
    }
}

class Authorities {
    String? authority;

    Authorities({this.authority});

    Authorities.fromJson(Map<String, dynamic> json) {
        authority = json["authority"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["authority"] = authority;
        return _data;
    }
}