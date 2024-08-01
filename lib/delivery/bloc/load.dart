import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/bloc/socket.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/models/order.dart';
import 'package:logistics_app/delivery/models/request.dart';
import 'package:logistics_app/delivery/view/login.dart';

import '../models/shipper.dart';
import '../widgets/drawer.dart';

void cantLogin(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
  );
}

void showExpired(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại!"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Đóng"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> loadTasksHistory() async {
  orders.clear();
  history.clear();
  var tasks = await shippersOperation
      .getTask(GettingTasksCondition(staffId: shipper.staffId!, option: 0));
  var historys =
      await shippersOperation.getHistory(GettingShipperHistoryInfo(option: 0));
  Map<String, int> tasksId = {};
  Map<String, bool> historyId = {};
  for (int i = 0; i < tasks["data"].length; i++) {
    tasksId[tasks["data"][i]["orderId"]] = tasks["data"][i]["id"];
  }
  for (int i = 0; i < historys["data"].length; i++) {
    historyId[historys["data"][i]["orderId"]] = true;
  }

  var allOrder = (await ordersOperation.get());

  if (allOrder.isNotEmpty && allOrder["data"] != null) {
    for (int i = 0; i < allOrder["data"].length; i++) {
      if (historyId[allOrder["data"][i]["orderId"]] != true) continue;
      Order ord = Order.fromJson(allOrder["data"][i]);
      ord.id = tasksId[allOrder["data"][i]["orderId"]];
      history.add(ord);
      if (tasksId[allOrder["data"][i]["orderId"]] == 0) continue;
      orders.add(ord);
    }
  }

  await (orders.map((order) => loadImages(order)));
  await (history.map((order) => loadImages(order)));
}

Future<void> loadAvatar() async {
  var staffAvatar = await staffsOperation
      .getAvatar(FindingAvatarCondition(staffId: shipper.staffId!));
  imageBytes = Uint8List.fromList(List<int>.from(staffAvatar["data"]));
}

Future<void> loadImages(Order order) async {
  if (order.sendImages != null)
    order.sendImgs =
        (await ordersOperation.getImage(order.orderId!, "send"))["data"];

  if (order.receiveImages != null)
    order.receiveImgs =
        (await ordersOperation.getImage(order.orderId!, "receive"))["data"];

  if (order.sendSignature != null)
    order.sendSig =
        (await ordersOperation.getSig(order.orderId!, "send"))["data"];

  if (order.receiveSignature != null)
    order.receiveSig =
        (await ordersOperation.getSig(order.orderId!, "receive"))["data"];
}

Future<bool> loadShipperInfo() async {
  try {
    var info = await staffsOperation.getAuthenticatedStaffInfo();
    if (info["message"] == "Token không hợp lệ") return false;

    shipper = Shipper.fromJson(info["data"]);
    await loadAvatar();
    return true;
  } catch (error) {
    print(error);
    return false;
  }
}

Future<void> loadRequest() async {
  avaiTasks.clear();
  var rs = await ordersOperation.getRequest();

  for (int i = 0; i < rs["data"].length; i++) {
    Order ord = Order.fromJson(rs["data"][i]["order"]);

    Request req = Request();
    req.content = Content();
    req.content!.requestId = rs["data"][i]["requestId"];
    req.content!.order = ord;

    avaiTasks.add(req);
  }
}

Future<void> reload() async {
  await loadTasksHistory();
  await loadRequest();
  print("done loading");
}

Future<bool> loadAll(BuildContext context) async {
  bool isNotExpired = await loadShipperInfo();
  if (!isNotExpired) {
    logoutCleanEmail();
    cantLogin(context);
    showExpired(context);
    return false;
  }
  connectSocket();
  return true;
}
