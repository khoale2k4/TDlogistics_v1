// ignore_for_file: avoid_print

import 'package:logistics_app/client/bloc/api_authenticate.dart';
import 'package:logistics_app/client/bloc/api_customer.dart';
import 'package:logistics_app/client/bloc/ggmap.dart';
import 'package:logistics_app/client/bloc/api_orders.dart';
import 'dart:typed_data';

import 'user.dart';
import 'order.dart';

OrdersOperation ordersOperation = OrdersOperation();
MapOperation mapOperation = MapOperation();

User user = User("1", "Khoa", "", "", "", "", "", "123@gmail.com", "0123345567", "USER");

Order order = Order(orderId: "1111");
List<Order> orders = [];

String? cookie;
Uint8List? imageBytes;

AuthOperation authOperation = AuthOperation();
CustomerOperation customerOperation = CustomerOperation();
