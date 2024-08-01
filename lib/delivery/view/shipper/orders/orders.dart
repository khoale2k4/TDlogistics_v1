import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/widgets/ggmap_direction.dart';
import '../../../widgets/drawer.dart';
import '../../../models/order.dart';
import '../../../widgets/qr_scanner.dart';
import 'order_card.dart';

Order? cur;

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool isCollapsed = false;
  List<Order> filteredOrders = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredOrders.addAll(orders);
  }

  void updateSearch(String str) {
    setState(() {
      searchController.text = str;
    });
  }

  void searchId(String id) {
    setState(() {
      filteredOrders =
          orders.where((order) => order.orderId!.contains(id)).toList();
      currentPage = 1; // Reset to first page after search
    });
  }

  void chooseAPoint() {
    setState(() {
      isCollapsed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredOrders.length / itemsPerPage).ceil();
    List<Order> currentOrders = filteredOrders
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      drawer: const MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/client/assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: !isCollapsed
            ? Stack(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    "Tất cả",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Divider(height: 2, color: Colors.black),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      textAlign: TextAlign.left,
                                      controller: searchController,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            filteredOrders = orders;
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 15),
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            final qrResult =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRViewExample()),
                                            );

                                            if (qrResult != null) {
                                              updateSearch(qrResult);
                                              searchId(qrResult);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: isLoading
                                        ? CircularProgressIndicator()
                                        : filteredOrders.isEmpty
                                            ? Container(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                width: double.maxFinite,
                                                child: const Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Text("Danh sách trống"),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              )
                                            : ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height -
                                                          320,
                                                ),
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount:
                                                      currentOrders.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          height: 10,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60,
                                                        ),
                                                        OrderCard(
                                                          order: currentOrders[
                                                              index],
                                                          func: chooseAPoint,
                                                          searchId: searchId,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: currentPage > 1
                                            ? () {
                                                setState(() {
                                                  currentPage--;
                                                });
                                              }
                                            : null,
                                        child: Icon(Icons.arrow_back),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(60, 60),
                                          foregroundColor: Colors.blue,
                                          backgroundColor: Colors.white,
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          '$currentPage / $totalPages',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: currentPage < totalPages
                                            ? () {
                                                setState(() {
                                                  currentPage++;
                                                });
                                              }
                                            : null,
                                        child: Icon(Icons.arrow_forward),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue,
                                          minimumSize: Size(60, 60),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                          ),
                          Container()
                        ],
                      ),
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
              )
            : GGMapDirection(
                order: cur!,
                retur: () {
                  setState(() {
                    isCollapsed = false;
                  });
                }),
      ),
    );
  }
}
