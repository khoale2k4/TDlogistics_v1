import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/models/order.dart';
import 'package:logistics_app/delivery/widgets/qr_scanner.dart';
import '../../widgets/drawer.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Order> filteredOrders = [];
  TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    filteredOrders.addAll(history);
  }
  void updateSearch(String str) {
    setState(() {
      searchController.text = str;
    });
  }

  void searchId(String id) {
    setState(() {
      filteredOrders =
          history.where((order) => order.orderId!.contains(id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
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
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width - 80,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          filteredOrders = history;
                                        });
                                      } else {
                                        setState(() {
                                          searchId(value);
                                        });
                                      }
                                    },
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm theo mã đơn hàng',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async{
                                          final qrResult = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QRViewExample()),
                                          );

                                          if (qrResult != null) {
                                            updateSearch(qrResult);
                                            searchId(qrResult);
                                          }},
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: filteredOrders.isEmpty
                              ? const Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text("Danh sách trống"),
                                  ],
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height -
                                            250,
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: filteredOrders.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                          ),
                                          HisCard(order: filteredOrders[index]),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
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
      ),
    );
  }
}

class HisCard extends StatefulWidget {
  final Order order;
  const HisCard({super.key, required this.order});

  @override
  State<HisCard> createState() => _HisCardState();
}

class _HisCardState extends State<HisCard> {
  void showReceiveImages(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ảnh nhận hàng',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                order.receiveImgs!.isEmpty
                    ? const Text('Danh sách trống')
                    : Container(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: order.receiveImgs!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: Text(
                                          'Ảnh nhận',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.black,
                                        iconTheme:
                                            IconThemeData(color: Colors.grey),
                                      ),
                                      backgroundColor:
                                          const Color.fromARGB(255, 27, 27, 27),
                                      body: Center(
                                        child: Image.memory(
                                          order.receiveImgs![index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  }));
                                },
                                child: Image.memory(
                                  order.receiveImgs![index],
                                  fit: BoxFit.contain,
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                const Text(
                  'Ảnh ký nhận hàng',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                order.receiveSig == null
                    ? const Text('Không có chữ ký')
                    : Container(
                        height: 100,
                        width: 75,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                    'Ảnh ký gửi hàng',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                  iconTheme: IconThemeData(color: Colors.grey),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 27, 27, 27),
                                body: Center(
                                  child: Image.memory(
                                    order.receiveSig!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }));
                          },
                          child: Image.memory(
                            order.receiveSig!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Đóng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width - 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "ID: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(widget.order.orderId ?? "Chưa có thông tin"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Người nhận: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(widget.order.nameReceiver ?? "Chưa có thông tin"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "SĐT người nhận: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(widget.order.phoneNumberReceiver ?? "Chưa có thông tin"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Khối lượng: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text("${widget.order.mass ?? "0"} g"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "COD: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text("${widget.order.cod ?? "0"} VNĐ"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Ngày giao: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text((widget.order.lastUpdate ?? "Đang được giao")
                    .replaceFirst("T", " ")
                    .replaceFirst(".000Z", "")),
              ],
            ),
              TextButton(
                onPressed: () {
                  showReceiveImages(widget.order);
                },
                child: const Text(
                  'Xem ảnh',
                  style: TextStyle(color: Colors.pink),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
