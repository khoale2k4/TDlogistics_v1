import 'dart:typed_data';

import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/models/order.dart';

Future<void> loadHistory() async {
  history.clear();
  var orderHistory = (await shippersOperation
      .getHistory(GettingShipperHistoryInfo(option: 0)));
  var hisData = orderHistory["data"];
  if (hisData != null) {
    List<Order> newHis = [];

    for (int i = 0; i < hisData.length; i++) {
      var orderData = await ordersOperation.get(hisData[i]["orderId"]);
      Order order = Order.fromJson(orderData["data"][0]);
      order.id = hisData[i]["id"];
      newHis.add(order);
    }
    history = newHis;
  }
}

Future<void> loadTasks() async {
  orders.clear();
  var result = await shippersOperation
      .getTask(GettingTasksCondition(staffId: shipper.staffId!, option: 0));

  var tasks = result["data"];

  List<Order> newOrders = [];
  if (tasks != null)
    for (int i = 0; i < tasks.length; i++) {
      var orderData = await ordersOperation.get(tasks[i]["orderId"]);
      Order order = Order.fromJson(orderData["data"][0]);
      order.id = tasks[i]["id"];
      newOrders.add(order);
    }

  orders = newOrders;
}

Future<void> loadAvatar() async {
  var staffAvatar = await staffsOperation
      .getAvatar(FindingAvatarCondition(staffId: shipper.staffId!));
  imageBytes = Uint8List.fromList(List<int>.from(staffAvatar["data"]));
}

Future<void> loadImages(Order order) async {
  if(order.sendImages != null)
  order.sendImgs = (await ordersOperation.getImage(order.orderId!, "send"))["data"];

  if(order.receiveImages != null)
  order.receiveImgs = (await ordersOperation.getImage(order.orderId!, "receive"))["data"];

  if(order.sendSignature != null)
  order.sendSig = (await ordersOperation.getSig(order.orderId!, "send"))["data"];

  if(order.receiveSignature != null)
  order.receiveSig = (await ordersOperation.getSig(order.orderId!, "receive"))["data"];
}