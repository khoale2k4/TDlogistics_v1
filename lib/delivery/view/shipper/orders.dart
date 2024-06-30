import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/bloc/load.dart';
import 'package:logistics_app/delivery/bloc/orders_operation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/models/current.dart';
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
                                const Divider(
                                  height: 2,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width - 80,
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
                                          final qrResult = await Navigator.push(
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
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                250,
                                          ),
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: filteredOrders.length,
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            60,
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
                                ),
                              ],
                            ),
                          ),
                        )
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
          fee = rs["data"].toString();
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
                                Expanded(
                                  child: Container(),
                                ),
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
                                Expanded(
                                  child: Container(),
                                ),
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
                                Expanded(
                                  child: Container(),
                                ),
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
                                Expanded(
                                  child: Container(),
                                ),
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

  void showSendImages(Order order) {
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
                order.sendImgs!.isEmpty
                    ? const Text('Danh sách trống')
                    : Container(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: order.sendImgs!.length,
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
                                          'Ảnh gửi hàng',
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
                                          order.sendImgs![index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  }));
                                },
                                child: Image.memory(
                                  order.sendImgs![index],
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
                  'Ảnh ký gửi hàng',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                order.sendSig == null
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
                                    order.sendSig!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }));
                          },
                          child: Image.memory(
                            order.sendSig!,
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

  void comfirm(Order order) async {
    List<Uint8List> images = [];
    List<File> files = [];
    Uint8List? signature;
    File? file;
    bool clicked = false;
    bool imagesBound = false;
    bool signatBound = false;
    bool loading = false;

    Future<void> pickImage(bool isSignature, StateSetter setState) async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        if (isSignature) {
          setState(() {
            signature = image;
            file = File(pickedFile.path);
          });
        } else {
          setState(() {
            images.add(image);
            files.add(File(pickedFile.path));
          });
        }
      }
    }

    void removeImage(int index) {
      setState(() {
        images.removeAt(index);
      });
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xác nhận đơn hàng',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ảnh nhận hàng',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        images.length < 3
                            ? InkWell(
                                onTap: () {
                                  pickImage(false, setState);
                                },
                                child: Container(
                                  height: 100,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return Scaffold(
                                              appBar: AppBar(
                                                title: Text(
                                                  'Ảnh gửi hàng',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.black,
                                                iconTheme: IconThemeData(
                                                    color: Colors.grey),
                                              ),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 27, 27, 27),
                                              body: Center(
                                                child: Image.memory(
                                                  images[index],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              floatingActionButton: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    removeImage(index);
                                                  });
                                                },
                                                child: const Text("Xoá ảnh",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20)),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Image.memory(
                                      images[index],
                                      fit: BoxFit.contain,
                                      width: 150,
                                      height: 150,
                                    ));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    clicked == true && images.isEmpty
                        ? const Text("Vui lòng chọn ảnh",
                            style: TextStyle(color: Colors.red))
                        : Container(),
                    imagesBound
                        ? const Text("Vượt quá dung lượng cho phép",
                            style: TextStyle(color: Colors.red))
                        : Container(),
                    SizedBox(height: 10),
                    Text(
                      'Ảnh ký nhận',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        await pickImage(true, setState);
                      },
                      child: signature == null
                          ? Container(
                              height: 75,
                              width: 125,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Icon(Icons.add),
                              ),
                            )
                          : Container(
                              height: 75,
                              width: 125,
                              child: Image.memory(
                                signature!,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    clicked == true && signature == null
                        ? const Text("Vui lòng chọn ảnh",
                            style: TextStyle(color: Colors.red))
                        : Container(),
                    signatBound
                        ? const Text("Vượt quá dung lượng cho phép",
                            style: TextStyle(color: Colors.red))
                        : Container(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Quay lại'),
                        ),
                        SizedBox(width: 10),
                        loading
                            ? CircularProgressIndicator()
                            : TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.red)),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (signature == null || images.isEmpty) {
                                    setState(() {
                                      clicked = true;
                                      imagesBound = false;
                                      signatBound = false;
                                    });
                                  } else {
                                    var sign =
                                        await ordersOperation.updateSignature(
                                            order.orderId!,
                                            order.id!.toString(),
                                            UploadSignature(file: file!));
                                    var imag =
                                        await ordersOperation.updateImages(
                                            order.orderId!,
                                            order.id!.toString(),
                                            UploadImages(files: files));
                                    print(sign);
                                    print(imag);
                                    print(sign["message"]);
                                    print(imag["message"]);
                                    setState(() {
                                      if (sign["message"] ==
                                          "Reached max size") {
                                        signatBound = true;
                                      } else {
                                        signatBound = false;
                                      }
                                      if (imag["message"] ==
                                              "Reached max size" ||
                                          imag["message"] ==
                                              "Quá số lượng ảnh cho phép. Số lượng ảnh cho phép tối đa là 3 ảnh.") {
                                        imagesBound = true;
                                      } else {
                                        imagesBound = false;
                                      }
                                    });
                                    if (sign["error"] == false &&
                                        imag["error"] == false) {
                                      ConfirmingCompletedTaskInfo info =
                                          ConfirmingCompletedTaskInfo(
                                              id: widget.order.id!);
                                      await shippersOperation
                                          .confirmCompletedTask(info);
                                      orders.removeWhere((order) =>
                                          order.orderId ==
                                          widget.order.orderId);

                                      loadHistory();

                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              'Xác nhận đơn hàng thành công'),
                                        ),
                                      );
                                    }
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: Text(
                                  'Xác nhận',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<String> addressConvert(Order order) {
    String rs = "";
    List<String> rsList = [];
    if (order.detailSource != "") rs += (order.detailSource ?? "");
    if (order.wardSource != "")
      rs += (rs != "" ? ", " : "") + (order.wardSource ?? "");
    if (order.districtSource != "")
      rs += (rs != "" ? ", " : "") + (order.districtSource ?? "");
    if (order.provinceSource != "")
      rs += (rs != "" ? ", " : "") + (order.provinceSource ?? "");
    rsList.add(rs);

    rs = "";
    if (order.detailDest != "") rs += (order.detailDest ?? "");
    if (order.wardDest != "")
      rs += (rs != "" ? ", " : "") + (order.wardDest ?? "");
    if (order.districtDest != "")
      rs += (rs != "" ? ", " : "") + (order.districtDest ?? "");
    if (order.provinceDest != "")
      rs += (rs != "" ? ", " : "") + (order.provinceDest ?? "");
    rsList.add(rs);

    return rsList;
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
                "Người nhận: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.order.nameReceiver ?? "Chưa có thông tin")
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "SĐT: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Expanded(
                child: Text(
                  widget.order.phoneNumberReceiver ?? "Chưa có thông tin",
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Địa chỉ: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Expanded(
                child: Text(
                  addressConvert(widget.order)[1],
                  softWrap: true,
                ),
              ),
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
                  showSendImages(widget.order);
                },
                child: const Text(
                  'Xem ảnh',
                  style: TextStyle(color: Colors.pink),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {
                  showDetail(widget.order);
                },
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {
                  comfirm(widget.order);
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
