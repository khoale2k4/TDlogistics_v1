import 'dart:typed_data';
import 'package:logistics_app/client/models/current.dart';
import 'api_customer.dart';

Future<bool> loadUserInfor() async {
  try {
    var userInfor = await customerOperation.getAuthenticatedCustomerInfo();
    if (userInfor["message"] == "Token không hợp lệ") return false;

    GettingAvatarParams params =
        GettingAvatarParams(customerId: userInfor['data']['id']);
    var userAvatar = await customerOperation.getAvatar(params);
    imageBytes = Uint8List.fromList(List<int>.from(userAvatar["data"]));

    user.id = userInfor['data']['id'];
    user.name = userInfor['data']["fullname"];
    user.city = userInfor['data']['province'];
    user.district = userInfor['data']['district'];
    user.ward = userInfor['data']['ward'];
    user.email = userInfor['data']["account"]['email'];
    user.address = userInfor['data']['detailAddress'];
    user.phoneNum = userInfor['data']["account"]['phoneNumber'];
    user.role = userInfor['data']["account"]['role'];
    user.detail = null;
    return true;
  } catch (error) {
    return false;
  }
}
