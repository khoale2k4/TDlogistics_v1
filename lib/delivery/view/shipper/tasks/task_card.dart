import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/bloc/load.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/models/order.dart';
import 'package:logistics_app/delivery/models/request.dart';

class TaskCard extends StatefulWidget {
  final Request request;
  final Function(Order ord) func;
  final Function(Request req) onAccept;
  const TaskCard(
      {super.key,
      required this.request,
      required this.func,
      required this.onAccept});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool accepting = false;

  Future<bool?> acceptOrder() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Nhận đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Hủy bỏ"),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: TextButton(
                          style: ButtonStyle(),
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            "Xác nhận",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showNotice(String msg) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(msg),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("Xem bản đồ"),
                onPressed: () {
                  widget.func(widget.request.content!.order!);
                },
              ),
            ],
          ),
          Text(widget.request.content!.order!.orderId!,
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Người gửi: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Flexible(
                child: Text(
                  widget.request.content!.order!.nameSender ??
                      "Chưa có thông tin",
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SĐT: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Flexible(
                child: Text(
                  "${widget.request.content!.order!.phoneNumberSender ?? "Chưa có thông tin"}",
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Địa chỉ: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Flexible(
                child: Text(
                  "${widget.request.content!.order!.detailSource ?? " "}, ${widget.request.content!.order!.wardSource ?? " "}, ${widget.request.content!.order!.districtSource ?? " "}, ${widget.request.content!.order!.provinceSource ?? " "}",
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey),
          accepting
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    CircularProgressIndicator(),
                    const SizedBox(height: 10),
                  ],
                )
              : TextButton(
                  child:
                      Text("Tiếp nhận", style: TextStyle(color: Colors.green)),
                  onPressed: () async {
                    var accept = await acceptOrder();
                    if (accept == null || !accept) return;
                    setState(() {
                      accepting = true;
                    });
                    var rs = await ordersOperation.acceptOrder(
                        widget.request.content!.order!.orderId!,
                        widget.request.content!.requestId!);
                    print(rs);
                    showNotice(rs["message"] ?? "Lỗi không xác định");
                    if (rs["error"] == "Service Unavailable"
                        ? false
                        : !rs["error"]) {
                      // await reload();
                      setState(() {
                        widget.onAccept(widget.request);
                      });
                    }
                    if (mounted)
                      setState(() {
                        accepting = false;
                      });
                  },
                ),
        ],
      ),
    );
  }
}
