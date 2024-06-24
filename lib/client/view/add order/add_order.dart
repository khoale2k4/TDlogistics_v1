import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logistics_app/client/bloc/load_orders.dart';
import 'package:logistics_app/client/bloc/api_orders.dart';
import 'package:logistics_app/client/models/cities.dart';
import 'package:logistics_app/client/models/current.dart';
import 'package:logistics_app/client/view/add%20order/confirm_order.dart';
import 'package:logistics_app/client/widgets/ggmap_2_markers.dart';
import '../../widgets/drawer.dart';
import '../../models/user.dart';
import 'infor_form.dart';
import 'sender_receiver.dart' as local;
import 'order_infor.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  bool isCollapsed = false;
  bool nextClicked = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  bool checkVaild(User user) {
    return (user.address != "" &&
        user.detail != "" &&
        user.city != "" &&
        user.district != "" &&
        user.name != "" &&
        user.phoneNum != "" &&
        user.phoneNum!.length >= 10 &&
        user.phoneNum!.length < 12);
  }

  bool checkValidOrder() {
    return (local.hei > 0 &&
        local.len > 0 &&
        local.wei > 0 &&
        local.wid > 0 &&
        local.sendingMethod != null);
  }

  void turnBack() {
    setState(() {
      currentPage--;
    });
  }

  void notCollapsed() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  final snackBar = SnackBar(
    content: const Text('Thêm đơn hàng thành công'),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),
  );

  final snackBarNotAvailable = const SnackBar(
    content: Text('Tính năng này chưa khả dụng'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: !isCollapsed
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.map, color: Colors.grey),
                                onPressed: () {
                                  notCollapsed();
                                  setState(() {
                                    nextClicked = false;
                                  });
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  return IconButton(
                                    icon: const Icon(Icons.menu,
                                        color: Colors.red),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: MediaQuery.of(context).size.height - 210,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.5, color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: currentPage == 1
                                  ? OrderInfor(
                                      func: turnBack,
                                      clicked: nextClicked,
                                    )
                                  : currentPage == 2
                                      ? ConfirmOrder(
                                          func: turnBack,
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Địa điểm",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Form(
                                              child: InforForm(
                                                titlte: "Địa điểm lấy hàng",
                                                user: local.sender,
                                                next: nextClicked,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Form(
                                              child: InforForm(
                                                titlte: "Địa điểm giao hàng",
                                                user: local.receiver,
                                                next: nextClicked,
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarNotAvailable);
                            },
                            child: const Text(
                              "Chính sách đền bù",
                              style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.red,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (currentPage == 0) {
                                  // sender_receiver info
                                  setState(() {
                                    nextClicked = true;
                                  });

                                  if (!checkVaild(local.receiver) ||
                                      !checkVaild(local.sender)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Vui lòng điền đầy đủ thông tin.')),
                                    );
                                    print(local.sender.longitude);
                                    return;
                                  }
                                  setState(() {
                                    currentPage++;
                                    nextClicked = false;
                                  });
                                } else if (currentPage == 1) {
                                  // order info
                                  setState(() {
                                    nextClicked = true;
                                  });

                                  if (checkValidOrder()) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const Dialog(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(height: 15),
                                              CircularProgressIndicator(),
                                              SizedBox(height: 15),
                                              Text('Đang tính toán chi phí'),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    CalculatingFeeInfo calcu =
                                        CalculatingFeeInfo(
                                      provinceSource: local.sender.city!,
                                      provinceDest: local.receiver.city!,
                                      // wardSource: local.sender.ward!,
                                      // detailSource: local.sender.address!,
                                      // provinceDest: local.receiver.city!,
                                      // districtDest: local.receiver.district!,
                                      // wardDest: local.receiver.ward!,
                                      // detailDest: local.receiver.address!,
                                      // length: local.len.toDouble(),
                                      // height: local.hei.toDouble(),
                                      // width: local.wid.toDouble(),
                                      mass: local.wei.toDouble(),
                                      serviceType:
                                          local.sendingMethod!.split(": ")[0],
                                    );
                                    var feeCalcu = await ordersOperation
                                        .calculateFee(calcu);
                                    if (feeCalcu["error"] == "No error") {
                                      setState(() {
                                        local.fee = feeCalcu["data"].toInt();
                                      });
                                      print(feeCalcu["data"]);
                                      print(local.fee);
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.yellow,
                                        content: Text(
                                          'Lỗi' + (feeCalcu.isNotEmpty?feeCalcu['error']:"Null"),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ));
                                      return;
                                    }

                                    setState(() {
                                      currentPage++;
                                      nextClicked = false;
                                    });
                                  }
                                } else {
                                  // confirm fee
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const Dialog(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(height: 15),
                                            CircularProgressIndicator(),
                                            SizedBox(height: 15),
                                            Text('Đang tạo đơn hàng'),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  LatLng? senderll = await mapOperation
                                      .getCoordinatesFromAddress(
                                          local.addressConvert(local.sender));
                                  LatLng? receivll = await mapOperation
                                      .getCoordinatesFromAddress(
                                          local.addressConvert(local.receiver));
                                  CreatingOrderByUserInformation newOrder =
                                      CreatingOrderByUserInformation(
                                    nameSender: local.sender.name!,
                                    provinceSource: local.sender.city!,
                                    districtSource: local.sender.district!,
                                    wardSource: local.sender.ward!,
                                    detailSource: local.sender.address!,
                                    nameReceiver: local.receiver.name!,
                                    phoneNumberSender: local.sender.phoneNum!,
                                    phoneNumberReceiver:
                                        local.receiver.phoneNum!,
                                    provinceDest: local.receiver.city!,
                                    districtDest: local.receiver.district!,
                                    wardDest: local.receiver.ward!,
                                    detailDest: local.receiver.address!,
                                    length: local.len,
                                    height: local.hei,
                                    width: local.wid,
                                    mass: local.wei,
                                    cod: local.mon.toDouble(),
                                    serviceType:
                                        local.sendingMethod!.split(": ")[0],
                                    latDestination: receivll?.latitude ?? 0.0,
                                    latSource: senderll?.latitude ?? 0.0,
                                    longDestination: receivll?.longitude ?? 0.0,
                                    longSource: senderll?.longitude ?? 0.0,
                                  );
print(newOrder.cod);
                                  Navigator.pop(context);
                                  var result = await ordersOperation
                                      .createByUser(newOrder);
                                  if (result["error"] == false) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.yellow,
                                      content: Text(
                                          'Thêm đơn hàng không thành công, ${result["message"]}',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ));
                                  }
                                  loadOrders();
                                  setState(() {
                                    currentPage = 0;
                                  });
                                }
                              },
                              child: Text(
                                currentPage == 2 ? "Xác nhận" : "Tiếp tục",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GGMap2Marker(
              add1: local.addressConvert(local.sender),
              add2: local.addressConvert(local.receiver),
              func: notCollapsed,
            ),
    );
  }
}
