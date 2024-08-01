import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:logistics_app/client/models/language.dart';
import 'package:logistics_app/delivery/view/shipper/orders/orders.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/order.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/bloc/load.dart';
import 'package:logistics_app/delivery/bloc/orders_operation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';

import 'signatureScreen.dart';

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
  String _formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(number);
  }

  bool isNotSent(int code) {
    return (code == 2 || code == 3 || code == 9 || code == 11);
  }

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
    bool isCalculating = false;

    bool isPositiveInteger(String value) {
      try {
        int parsedValue = int.parse(value);
        return parsedValue > 0;
      } catch (e) {
        return false;
      }
    }

    void updateFee(StateSetter setState) async {
      setState(() {
        isCalculating = true;
      });
      var rs = await ordersOperation.calculateFee(CalculatingFeeInfo(
        provinceSource: order.provinceSource ?? "",
        provinceDest: order.provinceDest ?? "",
        mass: int.parse(mas).toDouble(),
        serviceType: order.serviceType ?? "",
      ));
      print(rs);
      setState(() {
        try {
          String newFee = rs["data"].toInt().toString();
          fee = newFee;
        } catch (error) {
          print("Không tính toán được: $error");
        }
        isCalculating = false;
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
                                  width: 140,
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
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập một số hợp lệ'),
                                            ),
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
                                  width: 158,
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
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập một số hợp lệ'),
                                            ),
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
                                  width: 158,
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
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập một số hợp lệ'),
                                            ),
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
                                  width: 158,
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
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập một số hợp lệ'),
                                            ),
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
                                  width: 158,
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
                                                  'Vui lòng nhập một số hợp lệ'),
                                            ),
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
                                  child: isCalculating
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "$fee VNĐ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    updateFee(setState);
                                  },
                                  child: const Text("Tính phí ship"),
                                ),
                              ],
                            ),
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
                                taskId: order.id,
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

  void comfirm(Order order, {bool receive = true}) async {
    List<Uint8List> images = receive ? order.receiveImgs : order.sendImgs;
    List<File> files = [];
    Uint8List? signature = receive ? order.receiveSig : order.sendSig;
    File? file;
    bool clicked = false;
    bool imagesBound = false;
    bool signatBound = false;
    bool loading = false;

    Future<String?> showOptionDialog(BuildContext context) {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(imageSource),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop('Option 1');
                },
                child: Row(
                  children: [
                    Icon(Icons.touch_app),
                    const SizedBox(width: 10),
                    Text("Viết tay"),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop('Option 2');
                },
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    const SizedBox(width: 10),
                    Text(gallery),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop('Null');
                    },
                    child: Text(close),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

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
            images!.add(image);
            files.add(File(pickedFile.path));
          });
        }
      }
    }

    void removeImage(int index) {
      setState(() {
        images!.removeAt(index);
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
                      receive ? 'Xác nhận gửi hàng' : "Xác nhận nhận hàng",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      receive ? 'Ảnh gửi hàng' : "Ảnh nhận hàng",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        (images != null && images.length < 3)
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
                              itemCount: images!.length,
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
                                                receive
                                                    ? 'Ảnh gửi hàng'
                                                    : "Ảnh nhận hàng",
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
                                  ),
                                );
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
                      receive ? 'Ảnh ký gửi hàng' : "Ảnh ký nhận hàng",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        String? result = await showOptionDialog(context);

                        if (result == null || result == "Null") return;

                        if (result == 'Option 2')
                          await pickImage(true, setState);
                        else {
                          Uint8List? data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignatureScreen(),
                            ),
                          );
                          print("Signature");
                          print(data);
                          if (data != null) {
                            final tempDir = await getTemporaryDirectory();
                            File fileSign =
                                await File('${tempDir.path}/image.png')
                                    .create();
                            fileSign.writeAsBytesSync(data);
                            setState(() {
                              signature = data;
                              file = fileSign;
                            });
                          }
                        }
                      },
                      child: signature!.isEmpty
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
                                    var sign = (file != null
                                        ? await ordersOperation.updateSignature(
                                            order.orderId!,
                                            order.id!.toString(),
                                            UploadSignature(file: file!),
                                            receive ? "receive" : "send")
                                        : null);
                                    print(sign);
                                    var imag =
                                        await ordersOperation.updateImages(
                                            order.orderId!,
                                            order.id!.toString(),
                                            UploadImages(files: files),
                                            receive ? "receive" : "send");
                                    print(imag);
                                    setState(() {
                                      if (sign?["message"] ==
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
                                    if (sign?["error"] == false &&
                                        imag["error"] == false) {
                                      if (receive) {
                                        ConfirmingCompletedTaskInfo info =
                                            ConfirmingCompletedTaskInfo(
                                                id: widget.order.id!);
                                        await shippersOperation
                                            .confirmCompletedTask(info);
                                        orders.removeWhere((order) =>
                                            order.orderId ==
                                            widget.order.orderId);

                                        await loadTasksHistory();
                                      } 

                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(receive
                                              ? 'Xác nhận đơn hàng thành công!'
                                              : "Lưu ảnh thành công"),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            actions: <Widget>[
                                              const SizedBox(height: 20),
                                              Center(
                                                child: Text(
                                                  "Cập nhật ảnh",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Center(
                                                child: Column(
                                                  children: [
                                                    Text("Ảnh gửi/nhận"),
                                                    Text(imag["error"]
                                                        ? imag["message"]
                                                        : Container),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              sign != null
                                                  ? Center(
                                                      child: Column(
                                                        children: [
                                                          Text("Chữ ký"),
                                                          Text(
                                                            sign["message"],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
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
          isNotSent(widget.order.statusCode!)
              ? Row(
                  children: [
                    const Text(
                      "Người gửi: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(widget.order.nameSender ?? "Chưa có thông tin")
                  ],
                )
              : Row(
                  children: [
                    const Text(
                      "Người nhận: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                  (!isNotSent(widget.order.statusCode!)
                          ? widget.order.phoneNumberReceiver
                          : widget.order.phoneNumberSender) ??
                      "Chưa có thông tin",
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
                  comfirm(widget.order, receive: false);
                },
                child: const Text(
                  'Nhận hàng',
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
