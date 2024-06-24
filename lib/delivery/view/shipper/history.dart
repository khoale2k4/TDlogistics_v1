import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/models/order.dart';
import '../../widgets/drawer.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 223, 223),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
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
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm theo mã đơn hàng',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: history.isEmpty
                              ? const Text("Danh sách trống")
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: history.length,
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
                                        HisCard(order: history[index]),
                                      ],
                                    );
                                  },
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
              top: 20,
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
                  "ID đơn hàng: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(widget.order.orderId??"Chưa có thông tin"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Người nhận: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(widget.order.nameReceiver??"Chưa có thông tin"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "SĐT người nhận: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(widget.order.phoneNumberReceiver??"Chưa có thông tin"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Khối lượng: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text("${widget.order.mass??"0"} g"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "COD: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text("${widget.order.cod??"0"} VNĐ"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Ngày giao: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text((widget.order.completeDate ?? "Đang được giao")
                    .replaceFirst("T", " ")
                    .replaceFirst(".000Z", "")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
