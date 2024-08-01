import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logistics_app/delivery/bloc/noticefication.dart';
import 'package:logistics_app/delivery/models/request.dart';
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
        0, 'Bạn có đơn hàng có thể nhận!', message, platformChannelSpecifics,
        payload: 'new item');
  }
  String hostLocal = "192.168.1.10";
  String host = "https://api2.tdlogistics.net.vn/?agencyId=${shipper.agencyId}&userId=${shipper.staffId}&role=SHIPPER";
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
    socket = IO.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    try {
      socket!.on('connect', (_) {
        print('Kết nối thành công');
        //  _showNotification("Kết nối thành công");
      });

      socket!.on('notifyNewOrderToShipper', (data) {
        print(data);
        _showNotification(data["content"]["order"]["detailSource"] + ", " + data["content"]["order"]["wardSource"] + ", " + data["content"]["order"]["districtSource"] + ", " + data["content"]["order"]["provinceSource"]);
        avaiTasks.add(Request.fromJson(data));
      });

      socket!.on('error', (error) {
        print('Lỗi: $error');
      });

      socket!.on('disconnect', (_) {
        print('Ngắt kết nối');
      });

      socket!.connect();
    } catch (e) {
      print('Unable to connect: $e');
    }
  }

  connectSocket2();
  // connectLocal();
}
