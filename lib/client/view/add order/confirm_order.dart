import 'package:flutter/material.dart';
import 'package:logistics_app/client/bloc/convertCurrency.dart';
import '../../models/language.dart';
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
                child: Text(hintBack),
              ),
            ],
          ),
          Center(
            child: Text(
              hintConfirmInfo,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              hintSenderInfo,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text(
                hintFullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sender.name!, style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintPhoneNumber,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sender.phoneNum!, style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hintAddress,
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
            child: Text(
              hintReceiverInfo,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text(
                hintFullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(receiver.name!, style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintPhoneNumber,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(receiver.phoneNum!, style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hintAddress,
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
            child: Text(
              hintOrderInfo,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text(
                hintWeight2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(wei.toString() + " g", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintLength,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(len.toString() + " cm", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintWidth,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(wid.toString() + " cm", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintHeight,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(hei.toString() + " cm", style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintShippingCost,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(formatCurrency(fee.toDouble()), style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintCOD,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(formatCurrency(mon.toDouble() + fee.toDouble()), style: TextStyle(fontSize: 17)),
            ],
          ),
          Row(
            children: [
              Text(
                hintShippingMethod2,
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