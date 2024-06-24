import 'dart:typed_data';

import 'package:logistics_app/delivery/bloc/partner_staff_api.dart';
import 'package:logistics_app/delivery/bloc/driver_api.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/bloc/vehicle_api.dart';
import 'package:logistics_app/delivery/bloc/shipment_api.dart';
import 'package:logistics_app/delivery/bloc/orders_operation.dart';
import 'package:logistics_app/delivery/models/driver.dart';
import 'package:logistics_app/delivery/models/order.dart';
import 'package:logistics_app/delivery/models/shipper.dart';
import 'package:logistics_app/delivery/models/vehicle.dart';

PartnerStaffAuthenticate partnerStaffAuthenticate = PartnerStaffAuthenticate();
StaffsAuthenticate staffsAuthenticate = StaffsAuthenticate();

Order order = Order(
  id: 1,
  orderId: "123456",
  nameSender: "L K",
  phoneNumberSender: "0321546658",
  nameReceiver: "K L",
  phoneNumberReceiver: "0123346567",
  latSource: 21.0277644,
  longSource: 105.8341598,
  latDestination: 15.8800584,
  longDestination: 108.3380469,
  provinceSource: "Thành phố Hà Nội",
  districtSource: "",
  wardSource: "",
  detailSource: "",
  provinceDest: "Thành phố HCM",
  districtDest: "",
  wardDest: "",
  detailDest: "",
  mass: 0,
  height: 0,
  width: 0,
  length: 0,
  cod: 10000,
  statusCode: 5,
  fee: 10000
);
List<Order> history = [order];
List<Order> orders = [order];
List<Vehicle> vehicles = [];

String? cookie;
Uint8List? imageBytes;

Shipper shipper = Shipper();
Driver driver = Driver();

ShippersOperation shippersOperation = ShippersOperation();
DriversOperation driversOperation = DriversOperation();
StaffsOperation staffsOperation = StaffsOperation();
PartnerStaffOperation partnerStaffOperation = PartnerStaffOperation();
VehicleOperation vehicleOperation = VehicleOperation();
ShipmentsOperation shipmentsOperation = ShipmentsOperation();
OrdersOperation ordersOperation = OrdersOperation();

const statusCode = {
  1: "Giao hàng thành công.",
  2: "Đang được xử lí.",
  3: "Chờ lấy hàng.",
  4: "Lấy hàng thành công.",
  5: "Lấy hàng thất bại.",
  6: "Đang giao tới người nhận.",
  7: "Đã hủy yêu cầu giao hàng.",
  8: "Giao hàng thất bại.",
  9: "Đang hoàn hàng.",
  10: "Hoàn hàng thành công.",
  11: "Hoàn hàng thất bại.",
  12: "Đã tới bưu cục.",
  13: "Đã rời bưu cục.",
  14: "Kiện hàng được chuyển cho đối tác thứ ba giao.",
  15: "Đã được tiếp nhận."
};