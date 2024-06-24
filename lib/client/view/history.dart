import 'package:flutter/material.dart';
import '../bloc/api_orders.dart';
import '../widgets/drawer.dart';
import '../models/current.dart';
import '../models/order.dart';
import 'package:qr_flutter/qr_flutter.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Order> filteredOrders = [];
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    filteredOrders.addAll(orders);
    print(filteredOrders.length);
  }

  void filterSearchResults(String query) {
    List<Order> searchResults = [];
    searchResults.addAll(orders);
    if (query.isNotEmpty) {
      searchResults.retainWhere((item) => item.orderId!.contains(query));
    }
    setState(() {
      filteredOrders.clear();
      filteredOrders.addAll(searchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 223, 223),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Lịch sử đơn hàng",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: BorderSide.strokeAlignCenter,
                          color: Colors.black,
                          indent: 10,
                          endIndent: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          width: MediaQuery.of(context).size.width - 68,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Tìm kiếm theo mã đơn hàng",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 68,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height - 290,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: filteredOrders.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("No results"),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: filteredOrders.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          CardHistory(
                                              isDeleting: isDeleting,
                                              order: filteredOrders[index]),
                                          index != filteredOrders.length - 1
                                              ? const Divider(
                                                  height: 1,
                                                )
                                              : Container(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.only(left: 14, right: 14),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Container(
                        //         height: 50,
                        //         width: 70,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(
                        //             width: 1,
                        //           ),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         alignment: Alignment.center,
                        //         child: const Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Center(
                        //               child: Text("Delete"),
                        //             ),
                        //             Center(
                        //               child: Text("0/0"),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         height: 30,
                        //         width: 50,
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(
                        //             width: 1,
                        //           ),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         child: IconButton(
                        //           padding: EdgeInsets.zero,
                        //           onPressed: () {
                        //             setState(() {
                        //               page--;
                        //               if (page <= 0) page = 1;
                        //               if (filteredOrders.isEmpty) page = 0;
                        //             });
                        //           },
                        //           icon: const Icon(Icons.keyboard_arrow_left),
                        //         ),
                        //       ),
                        //       Column(
                        //         children: [
                        //           Text(
                        //               "Page $page of ${(filteredOrders.length / 8).ceil()}"),
                        //           Row(
                        //             children: [
                        //               const Text("Go to page "),
                        //               Container(
                        //                 height: 20,
                        //                 width: 30,
                        //                 decoration: BoxDecoration(
                        //                   border: Border.all(
                        //                     width: 1,
                        //                   ),
                        //                   borderRadius:
                        //                       BorderRadius.circular(5),
                        //                 ),
                        //                 child: TextField(
                        //                   keyboardType: TextInputType.number,
                        //                   onChanged: (value) {
                        //                     if (value == "") return;
                        //                     try {
                        //                       setState(() {
                        //                         page = int.parse(value);
                        //                         if (page >
                        //                             (filteredOrders.length / 8)
                        //                                 .ceil()) {
                        //                           page =
                        //                               (filteredOrders.length /
                        //                                       8)
                        //                                   .ceil();
                        //                         } else if (page < 1) {
                        //                           page = 1;
                        //                         }
                        //                       });
                        //                     } catch (error) {}
                        //                   },
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       Container(
                        //         height: 30,
                        //         width: 50,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(
                        //             width: 1,
                        //           ),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         child: IconButton(
                        //           padding: EdgeInsets.zero,
                        //           onPressed: () {
                        //             setState(() {
                        //               page++;
                        //               if (page >
                        //                   (filteredOrders.length / 8).ceil()) {
                        //                 page =
                        //                     (filteredOrders.length / 8).ceil();
                        //               }
                        //             });
                        //           },
                        //           icon: const Icon(Icons.keyboard_arrow_right),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: TextButton(
                            child: Text(
                                isDeleting ? "Hoàn thành" : "Xoá đơn hàng"),
                            onPressed: () {
                              setState(() {
                                isDeleting = !isDeleting;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 55,
            right: 20,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.red),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardHistory extends StatefulWidget {
  final Order order;
  final bool isDeleting;
  const CardHistory({super.key, required this.order, required this.isDeleting});

  @override
  State<CardHistory> createState() => _CardHistoryState();
}

class _CardHistoryState extends State<CardHistory> {
  void showQr(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text(
                'Mã QR',
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
              const Text(
                'Thông tin',
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
                const Center(
                  child: Text(
                    "Thông tin người gửi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                buildInfoRow(
                    "Họ tên: ", order.nameSender ?? "Chưa có thông tin"),
                buildInfoRow("Số điện thoại: ",
                    order.phoneNumberSender ?? "Chưa có thông tin"),
                buildInfoRow("Số nhà/đường: ",
                    order.detailSource ?? "Chưa có thông tin"),
                buildInfoRow("Tỉnh/Thành phố: ",
                    order.provinceSource ?? "Chưa có thông tin"),
                buildInfoRow(
                    "Phường/Xã: ", order.wardSource ?? "Chưa có thông tin"),
                buildInfoRow("Quận/Huyện: ",
                    order.districtSource ?? "Chưa có thông tin"),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Thông tin người nhận",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                buildInfoRow(
                    "Họ tên: ", order.nameReceiver ?? "Chưa có thông tin"),
                buildInfoRow("Số điện thoại: ",
                    order.phoneNumberReceiver ?? "Chưa có thông tin"),
                buildInfoRow(
                    "Số nhà/đường: ", order.detailDest ?? "Chưa có thông tin"),
                buildInfoRow("Tỉnh/Thành phố: ",
                    order.provinceDest ?? "Chưa có thông tin"),
                buildInfoRow(
                    "Phường/Xã: ", order.wardDest ?? "Chưa có thông tin"),
                buildInfoRow(
                    "Quận/Huyện: ", order.districtDest ?? "Chưa có thông tin"),
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
              const Text(
                'Thông tin đơn hàng',
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
                const Text("ID: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(order.orderId ?? "Chưa có thông tin")],
                ),
                Row(
                  children: [
                    const Text("COD: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.cod.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text("Phí vận chuyển: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.fee.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text("Chiều cao: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.height.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text("Chiều rộng: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.width.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text("Chiều dài: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.length.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text("Khối lượng: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.mass.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text("Thời gian tạo: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.createdAt ??
                        "No Infor"
                            .replaceFirst("T", " ")
                            .replaceFirst(".000Z", ""))
                  ],
                ),
                Row(
                  children: [
                    const Text("Cập nhật lần cuối: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.lastUpdate ??
                        "No Infor"
                            .replaceFirst("T", " ")
                            .replaceFirst(".000Z", ""))
                  ],
                ),
                Row(
                  children: [
                    const Text("Số lần lỡ đơn: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.miss.toString())
                  ],
                ),
                const Text("Hành trình di chuyển: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  alignment: Alignment.centerLeft,
                  height:
                      order.journey!.isEmpty ? 0 : order.journey!.length * 55,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: order.journey?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                          subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.done),
                              Text(
                                (order.journey![index].split(": ")[0]),
                              ),
                            ],
                          ),
                          Text(
                            (order.journey![index].split(": ")[1]),
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
          title: const Text(
            'Xác nhận xoá',
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
                            CancelingOrderCondition condition =
                                CancelingOrderCondition(orderId: id);
                            var deleteResult =
                                await ordersOperation.cancel(condition);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.yellow,
                              content: Text(
                                  deleteResult.isNotEmpty
                                      ? deleteResult["message"]
                                      : "Null",
                                  style: TextStyle(color: Colors.black)),
                            ));
                            Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Order ID: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.order.orderId ?? "No infor")
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("COD: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.order.cod.toString())
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Fee: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.order.fee.toString())
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Phone sender: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.order.phoneNumberSender ?? "No infor")
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Name sender: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.order.nameSender ?? "No infor")
            ],
          ),
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
                  child: const Text(
                    "Xoá đơn hàng này",
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
                      child: const Text(
                        "Mã QR",
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
                      child: const Text(
                        "Người gửi/nhận",
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
                      child: const Text(
                        "Đơn hàng",
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
