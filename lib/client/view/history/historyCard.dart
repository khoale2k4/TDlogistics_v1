import 'package:flutter/material.dart';
import 'package:logistics_app/client/bloc/api_orders.dart';
import 'package:logistics_app/client/bloc/convertCurrency.dart';
import 'package:logistics_app/client/models/current.dart';
import 'package:logistics_app/client/models/language.dart';
import 'package:logistics_app/client/models/order.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardHistory extends StatefulWidget {
  final Order order;
  final bool isDeleting;
  final Function(Order) cancel;
  const CardHistory({super.key, required this.order, required this.isDeleting, required this.cancel});

  @override
  State<CardHistory> createState() => _CardHistoryState();
}

class _CardHistoryState extends State<CardHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(widget.order.shipper != null) print(await staffsOperation.getStaffInfo(widget.order.shipper!));
  }
  void showQr(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                qrCode,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width - 100,
                color: Colors.black,
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [QrImageView(data: order.qrcode ?? "", size: 300)],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showSenderReceiver(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                infor,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width - 100,
                color: Colors.black,
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    inforUser1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                buildInfoRow(name + ": ", order.nameSender ?? noInfor),
                buildInfoRow(
                    phoneNumField + ": ", order.phoneNumberSender ?? noInfor),
                buildInfoRow(detail + ": ", order.detailSource ?? noInfor),
                buildInfoRow(city + ": ", order.provinceSource ?? noInfor),
                buildInfoRow(ward + ": ", order.wardSource ?? noInfor),
                buildInfoRow(district + ": ", order.districtSource ?? noInfor),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    inforUser2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                buildInfoRow(name + ": ", order.nameReceiver ?? noInfor),
                buildInfoRow(
                    phoneNumField + ": ", order.phoneNumberReceiver ?? noInfor),
                buildInfoRow(detail + ": ", order.detailDest ?? noInfor),
                buildInfoRow(city + ": ", order.provinceDest ?? noInfor),
                buildInfoRow(ward + ": ", order.wardDest ?? noInfor),
                buildInfoRow(district + ": ", order.districtDest ?? noInfor),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  void showDetail(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                orderInfor,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 100,
                  color: Colors.black),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("ID: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.orderId ?? noInfor)
                  ],
                ),
                // Row(
                //   children: [
                //     const Text("COD: ",
                //         style: TextStyle(fontWeight: FontWeight.bold)),
                //     Text(formatCurrency(order.cod))
                //   ],
                // ),
                // Row(
                //   children: [
                //     Text(feeOrder,
                //         style: TextStyle(fontWeight: FontWeight.bold)),
                //     Text(formatCurrency(order.fee!))
                //   ],
                // ),
                Row(
                  children: [
                    Text(dHei, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.height!.toInt().toString() + " cm")
                  ],
                ),
                Row(
                  children: [
                    Text(dWid, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.width!.toInt().toString() + " cm")
                  ],
                ),
                Row(
                  children: [
                    Text(dLen, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.length!.toInt().toString() + " cm")
                  ],
                ),
                Row(
                  children: [
                    Text(dWei, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.mass!.toInt().toString() + " g")
                  ],
                ),
                Text(createDate, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text((order.createdAt ?? noInfor).replaceFirst(".000", ""))
                  ],
                ),

                Text(lastUpdate, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text((order.lastUpdate ?? noInfor).replaceFirst(".000", ""))
                  ],
                ),
                Row(
                  children: [
                    Text(status, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(statusCode[order.statusCode]!)
                  ],
                ),
                Row(
                  children: [
                    Text(missTimes,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.miss.toString())
                  ],
                ),
                Row(
                  children: [
                    Text(paid, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text((order.paid ?? noInfor) ? didPaid : didnPaid)
                  ],
                ),
                Text(jouneys, style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  alignment: Alignment.centerLeft,
                  height:
                      order.journey!.isEmpty ? 0 : order.journey!.length * 70,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: order.journey?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                          subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.done),
                              Flexible(
                                child: Text(
                                  (order.journey![index]),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteOrder(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            confirmDelete,
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
                            Navigator.pop(context);
                          },
                          child: Text(cancel),
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
                            CancelingOrderCondition condition =
                                CancelingOrderCondition(orderId: id);
                            var deleteResult =
                                await ordersOperation.cancel(condition);

                            if(deleteResult["error"] == false) {
                              widget.cancel(widget.order);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: deleteResult["error"] != false ?Colors.yellow:Colors.green,
                              content: Text(
                                  deleteResult.isNotEmpty
                                      ? deleteResult["message"]
                                      : "Null",
                                  style: TextStyle(color: Colors.black)),
                            ));
                            Navigator.pop(context);
                          },
                          child: Text(
                            agree,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Text(orderId, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.order.orderId ?? noInfor)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("COD: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(formatCurrency(widget.order.cod))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(feeOrder, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(formatCurrency(widget.order.fee!))
            ],
          ),
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     Text(senderPhone, style: TextStyle(fontWeight: FontWeight.bold)),
          //     Text(widget.order.phoneNumberSender ?? noInfor)
          //   ],
          // ),
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     Text(senderName, style: TextStyle(fontWeight: FontWeight.bold)),
          //     Text(widget.order.nameSender ?? noInfor)
          //   ],
          // ),
          const SizedBox(height: 10),
          widget.order.shipper != null
              ? Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID Shipper: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.order.shipper ?? "Chưa có thông tin",
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text("Chưa có Shipper đảm nhận!"),
          const SizedBox(height: 10),
          widget.isDeleting
              ? TextButton(
                  onPressed: () {
                    deleteOrder(widget.order.orderId!);
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                  child: Text(
                    deleteThisOrder,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showQr(widget.order);
                      },
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      child: Text(
                        qrCode,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showSenderReceiver(widget.order);
                      },
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      child: Text(
                        senderReceiver,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDetail(widget.order);
                      },
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      child: Text(
                        orderInfor,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
