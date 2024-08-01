import 'package:logistics_app/client/bloc/api_authenticate.dart';
import 'package:logistics_app/client/bloc/api_customer.dart';
import 'package:logistics_app/client/bloc/ggmap.dart';
import 'package:logistics_app/client/bloc/api_orders.dart';
import 'package:logistics_app/client/bloc/staff_shipper_api.dart';
import 'dart:typed_data';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'user.dart';
import 'order.dart';

OrdersOperation ordersOperation = OrdersOperation();
MapOperation mapOperation = MapOperation();
StaffsOperation staffsOperation = StaffsOperation();

User user = User("1", "Khoa", "", "", "", "", "", "123@gmail.com", "0123345567", "USER");

Order order = Order(orderId: "1111");
List<Order> orders = [];

String? cookie;
Uint8List? imageBytes;
IO.Socket? socket;

AuthOperation authOperation = AuthOperation();
CustomerOperation customerOperation = CustomerOperation();

bool en = false;


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