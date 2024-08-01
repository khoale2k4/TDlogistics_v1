import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logistics_app/client/bloc/load_orders.dart';
import 'package:logistics_app/client/bloc/noticefication.dart';
import 'package:logistics_app/client/models/order.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/current.dart';

void connectSocket() {
  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Bạn có đơn hàng được chấp nhận!', message, platformChannelSpecifics,
        payload: 'new item');
  }
  String hostLocal = "192.168.1.10";
  String host = "https://api2.tdlogistics.net.vn/?agencyId=TD_00000_000000000000&userId=${user.id}&role=CUSTOMER";
  int port = 8080;
  Socket? socketTest;

  void connectLocal() async {
    socketTest = await Socket.connect(hostLocal, port);
    print('Connected to: ${socketTest!.remoteAddress.address}:${socketTest!.remotePort}');

    socketTest!.listen((List<int> data) {
      _showNotification((jsonDecode(String.fromCharCodes(data)))["content"]["order"]["detailSource"]);
    },);
  }
  void connectSocket2() async {
    print(host);
    socket = IO.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    try {
      socket!.on('connect', (_) {
        print('Kết nối thành công');
         _showNotification("Kết nối thành công");
      });

      socket!.on('notifyAcceptedRequestToCustomer', (data) async {
        print(data);
        String msg = "Được nhận bởi: ";
        await loadOrders();
        String staffId = (orders.firstWhere((order) => order.orderId == data["content"]["order"]["orderId"])).shipper??"Null";
        if(staffId == "Null") {
          _showNotification("Biển số xe shipper: " + data["content"]["licensePlate"]);
        } else {
          var shipper = await staffsOperation.getStaffInfo(staffId);
          if(shipper["data"] == null) _showNotification("Biển số xe shipper: " + data["content"]["licensePlate"]);
          else _showNotification(msg + shipper["data"][0]["fullname"] + "\n" + "SĐT: " + shipper["data"][0]["account"]["phoneNumber"] + ", "  + "BX: " + data["content"]["licensePlate"]);
        }
      });

      socket!.on('error', (error) {
        print('Lỗi: $error');
      });

      socket!.on('disconnect', (_) {
        print('Ngắt kết nối');
      });

      socket!.connect();
    print("Socket2");
    } catch (e) {
      print('Unable to connect: $e');
    }
  }

  connectSocket2();
  // connectLocal();
}
