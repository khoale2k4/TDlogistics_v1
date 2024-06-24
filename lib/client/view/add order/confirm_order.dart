import 'package:flutter/material.dart';
import 'sender_receiver.dart';

class ConfirmOrder extends StatefulWidget {
  final Function() func;
  const ConfirmOrder({super.key, required this.func});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.func,
                child: const Text("Quay lại"),
              ),
            ],
          ),
          Center(
            child: const Text(
              "Xác nhận thông tin",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: const Text(
              "Thông tin người gửi",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Text(
                "Họ tên: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sender.name!, style: TextStyle(fontSize: 17))
            ],
          ),
          Row(
            children: [
              const Text(
                "Số điện thoại: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sender.phoneNum!, style: TextStyle(fontSize: 17))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Địa chỉ: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text(
                  addressConvert(sender),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: const Text(
              "Thông tin người nhận",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Text(
                "Họ tên: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(receiver.name!, style: TextStyle(fontSize: 17))
            ],
          ),
          Row(
            children: [
              const Text(
                "Số điện thoại: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(receiver.phoneNum!, style: TextStyle(fontSize: 17))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Địa chỉ: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Text(
                  addressConvert(receiver),
                  style: TextStyle(fontSize: 17),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: const Text(
              "Thông tin đơn hàng",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Text(
                "Khối lượng: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(wei.toString() + " g", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              const Text(
                "Chiều dài: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(len.toString() + " cm", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              const Text(
                "Chiều rộng: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(wid.toString() + " cm", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              const Text(
                "Chiều cao: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(hei.toString() + " cm", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              const Text(
                "Chi phí vận chuyển: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(fee.toString() + " VNĐ", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              const Text(
                "COD: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(mon.toString() + " VNĐ", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              const Text(
                "Phương thức vận chuyển: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                sendingMethod!.split(": ")[0],
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
