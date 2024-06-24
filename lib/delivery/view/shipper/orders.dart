import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/bloc/orders_operation.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/bloc/shipment_api.dart';
import 'package:logistics_app/delivery/widgets/ggmap_direction.dart';
import '../../widgets/drawer.dart';
import '../../models/order.dart';
import '../../widgets/qr_scanner.dart';

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

  @override
  void initState() {
    // TODO: implement initState
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
    });
  }

  void chooseAPoint() {
    setState(() {
      isCollapsed = true;
    });
  }

  final snackBarNotAvailable = const SnackBar(
    content: Text('Tính năng này chưa khả dụng'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: !isCollapsed
          ? Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            Container(
                              padding: const EdgeInsets.all(20),
                              height: MediaQuery.of(context).size.height - 80,
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
                                    const Divider(
                                      height: 2,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width -
                                          80,
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
                                      height: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height -
                                              250,
                                      child: filteredOrders.isEmpty
                                          ? const Text("Danh sách trống")
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: filteredOrders.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    OrderCard(
                                                      order:
                                                          filteredOrders[index],
                                                      func: chooseAPoint,
                                                      searchId: searchId,
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
            )
          : GGMapDirection(
              order: cur!,
              retur: () {
                setState(() {
                  isCollapsed = false;
                });
              }),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final Function() func;
  final Function(String) searchId;
  const OrderCard(
      {super.key,
      required this.order,
      required this.func,
      required this.searchId});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  void showOptionDialog(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Chỉ đường',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.map, color: Colors.black),
                      Text(
                        'Đi tới bản đồ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      cur = order;
                    });
                    Navigator.of(context).pop();
                    widget.func();
                  },
                ),
              ],
            ),
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDetail(Order order) {
    bool isEditing = false;
    String len = order.length.toString();
    String hei = order.height.toString();
    String wid = order.width.toString();
    String mas = order.mass.toString();
    String cod = order.cod.toString();
    String fee = order.fee.toString();
    // String? selectedKey;
    bool isPositiveInteger(String value) {
      try {
        int parsedValue = int.parse(value);
        return parsedValue > 0;
      } catch (e) {
        return false;
      }
    }

    void updateFee() async {
      var rs = await ordersOperation.calculateFee(CalculatingFeeInfo(
        provinceSource: order.provinceSource ?? "",
        districtSource: order.districtSource ?? "",
        wardSource: order.wardSource ?? "",
        detailSource: order.detailSource ?? "",
        provinceDest: order.provinceDest ?? "",
        districtDest: order.districtDest ?? "",
        wardDest: order.wardDest ?? "",
        detailDest: order.detailDest ?? "",
        length: int.parse(len).toDouble(),
        height: int.parse(hei).toDouble(),
        width: int.parse(wid).toDouble(),
        mass: int.parse(mas).toDouble(),
        serviceType: order.serviceType ?? "",
      ));
      setState(() {
        if (rs['error'] == "No error")
          fee = rs["data"];
        else
          print("Không tính toán được");
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  isEditing ? "Sửa đổi thông tin" : 'Chi tiết đơn hàng',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: Colors.grey[200],
              actions: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: isEditing
                      ? Column(
                          children: [
                            const Text(
                              "Phí ship sẽ được tính toán tự động",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text(
                                  "Khối lượng: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Expanded(child: Container(),),
                                Container(
                                  height: 30,
                                  width: 60,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: mas,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        try {
                                          setState(() {
                                            mas = value;
                                          });
                                          updateFee();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Vui lòng nhập một số hợp lệ')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Text(" g")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Cao: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Expanded(child: Container(),),
                                Container(
                                  height: 30,
                                  width: 67,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: hei,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        try {
                                          setState(() {
                                            hei = value;
                                          });
                                          //updateFee();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Vui lòng nhập một số hợp lệ')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Text(" cm")
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Dài: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Expanded(child: Container(),),
                                Container(
                                  height: 30,
                                  width: 60,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: len,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        try {
                                          setState(() {
                                            len = value;
                                          });
                                          updateFee();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Vui lòng nhập một số hợp lệ')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Text(" cm")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Ngang: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Expanded(child: Container(),),
                                Container(
                                  height: 30,
                                  width: 60,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: wid,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        try {
                                          setState(() {
                                            wid = value;
                                          });
                                          updateFee();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Vui lòng nhập một số hợp lệ')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Text(" cm")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "COD: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Container(
                                  height: 30,
                                  width: 150,
                                  child: TextField(
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: cod,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        try {
                                          setState(() {
                                            cod = value;
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Vui lòng nhập một số hợp lệ')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Text(" VNĐ")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width - 150,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Phí ship: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: 158,
                                  child: Text(
                                    "$fee VNĐ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Container(
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton<String>(
                            //       isExpanded: true,
                            //       value: selectedKey,
                            //       hint: Text("Chọn trạng thái"),
                            //       items: statusCode.keys.map((int key) {
                            //         return DropdownMenuItem<String>(
                            //           value: key.toString(),
                            //           child: Text(statusCode[key]!),
                            //         );
                            //       }).toList(),
                            //       onChanged: (String? newValue) {
                            //         setState(() {
                            //           selectedKey = newValue;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                order.orderId ?? "Chưa có thông tin",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Người nhận: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(order.nameReceiver ?? "Chưa có thông tin")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "SĐT người nhận: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(order.phoneNumberReceiver ??
                                    "Chưa có thông tin")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Khối lượng: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text("${order.mass} g")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Cao: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text("${order.height} cm")
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Dài: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text("${order.length} cm")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Ngang: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text("${order.width} cm")
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "COD: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text("${order.cod} VNĐ")
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Tình trạng: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text("${statusCode[order.statusCode ?? 0]}")
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Ngày tạo đơn hàng: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  order.createdAt ??
                                      "Chưa có thông tin"
                                          .replaceFirst('T', ' ')
                                          .split('.')[0],
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Lần cập nhật cuối: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  order.lastUpdate ??
                                      "Chưa có thông tin"
                                          .replaceFirst('T', ' ')
                                          .split('.')[0],
                                )
                              ],
                            ),
                          ],
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(isEditing ? "Lưu" : "Sửa"),
                      onPressed: () async {
                        if (isEditing) {
                          var rs = await ordersOperation.update(
                            UpdatingOrderInfo(
                                cod: order.cod!.toDouble(),
                                height: order.height!.toDouble(),
                                length: order.length!.toDouble(),
                                mass: order.mass!.toDouble(),
                                width: order.width!.toDouble(),
                                statusCode: order.statusCode!),
                            UpdatingOrderCondition(orderId: order.orderId!),
                          );

                          if (rs['error'] == "No error") {
                            setState(() {
                              if (isPositiveInteger(cod))
                                order.cod = int.parse(cod);
                              if (isPositiveInteger(mas))
                                order.mass = int.parse(mas);
                              if (isPositiveInteger(hei))
                                order.height = int.parse(hei);
                              if (isPositiveInteger(len))
                                order.length = int.parse(len);
                              if (isPositiveInteger(wid))
                                order.width = int.parse(wid);
                              order.lastUpdate = DateTime.now().toString();
                              order.fee = int.parse(fee);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Cập nhật thông tin thành công'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Cập nhật thông tin thất bại'),
                              ),
                            );
                          }
                        }
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                    ),
                    TextButton(
                      child: const Text('Đóng'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> comfirm(Order order, bool finishedOrder) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            Column(
              children: [
                Text(
                  "Xác nhận ${finishedOrder ? "hoàn thành!" : "tiếp nhận đơn hàng!"}",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                          Navigator.pop(context, false);
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
                        style: const ButtonStyle(),
                        onPressed: () {
                          Navigator.pop(context, true);
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
        );
      },
    );

    return result ?? false; // Default to false if result is null
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    showOptionDialog(widget.order);
                  },
                  child:
                      const Text("Chỉ đường", style: TextStyle(fontSize: 15)))
            ],
          ),
          Text(widget.order.orderId ?? "Chưa có thông tin",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Vĩ độ bắt đầu: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.order.latSource.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Kinh độ bắt đầu: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.order.longSource.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Vĩ độ đích: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.order.latDestination.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Kinh độ đích: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.order.longDestination.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  showDetail(widget.order);
                },
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () async {
                  bool res = await comfirm(widget.order, false);
                  if (res) {
                    shipmentsOperation.undertake(UndertakingShipmentInfo(
                        shipmentId: widget.order.id.toString()));
                  }
                },
                child: const Text(
                  'Tiếp nhận',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () async {
                  bool res = await comfirm(widget.order, true);
                  if (res) {
                    shippersOperation.confirmCompletedTask(
                      ConfirmingCompletedTaskInfo(id: widget.order.id!),
                    );
                    setState(() {
                      orders.removeWhere(
                          (order) => order.orderId == widget.order.orderId);
                    });
                    widget.searchId("");
                  }
                },
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
