import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/delivery/bloc/driver_api.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/models/order.dart';
import 'package:logistics_app/delivery/models/shipment.dart';
import 'package:logistics_app/delivery/models/vehicle.dart';
import 'package:logistics_app/delivery/view/driver/shipments.dart';
import '../models/current.dart';
import 'shipper/orders.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPartnet = false;
  String? username = "minhluxuan2k15";
  String? password = "minhluxuan@TDlogistics2k24";

  void showLoading() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15),
              CircularProgressIndicator(),
              SizedBox(height: 15),
              Text('Đang đăng nhập'),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(180),
                  bottomRight: Radius.circular(180),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      Image.asset('lib/client/assets/logo.png', height: 75),
                      const SizedBox(height: 20),
                      const Text(
                        'TD LOGISTICS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "XIN CHÀO,",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Tên tài khoản',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isPartnet,
                                side: BorderSide(color: Colors.white),
                                fillColor: WidgetStatePropertyAll(Colors.white),
                                checkColor: Colors.green,
                                shape: CircleBorder(
                                    side: BorderSide(color: Colors.white)),
                                onChanged: (value) {
                                  setState(() {
                                    isPartnet = true;
                                  });
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isPartnet = true;
                                  });
                                },
                                child: Text(
                                  "Đối tác vận tải khác",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight:
                                          isPartnet ? FontWeight.bold : null),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: !isPartnet,
                                side: BorderSide(color: Colors.white),
                                fillColor: WidgetStatePropertyAll(Colors.white),
                                checkColor: Colors.green,
                                shape: CircleBorder(
                                    side: BorderSide(color: Colors.white)),
                                onChanged: (value) {
                                  setState(() {
                                    isPartnet = false;
                                  });
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isPartnet = false;
                                  });
                                },
                                child: Text(
                                  "Bưu cục/Đại lý",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight:
                                          !isPartnet ? FontWeight.bold : null),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () async {
                          showLoading();
                          if (isPartnet) {
                            var result = await staffsAuthenticate.login(
                                username!, password!);
                            if (result["message"] == "Xác thực thành công.") {
                              var info = await staffsOperation
                                  .getAuthenticatedStaffInfo();

                              setState(() {
                                shipper.fromJson(info["data"]);
                              });

                              
                          var staffAvatar = await staffsOperation.getAvatar(FindingAvatarCondition(staffId: shipper.staffId!));
                          setState(() {
                            imageBytes = Uint8List.fromList(List<int>.from(staffAvatar["data"]));
                          });

                              var orderHistory =
                                  (await shippersOperation.getHistory(
                                      GettingShipperHistoryInfo(option: 0)));
                              var hisData = orderHistory["data"];
                              for (int i = 0; i < hisData.length; i++) {
                                setState(() {
                                  history
                                      .add(Order.fromJson(hisData[i]["order"]));
                                  history[i].id = hisData[i]["id"];
                                  history[i].completeDate =
                                      hisData[i]["completed_at"];
                                });
                              }

                              result = await shippersOperation.getTask(
                                  GettingTasksCondition(
                                      staffId: shipper.staffId!, option: 0));

                              var tasks = result["data"];
                              for (int i = 0; i < tasks.length; i++) {
                                setState(() {
                                  orders.add(Order.fromJson(tasks[i]["order"]));
                                  orders[i].id = tasks[i]["id"];
                                });
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đăng nhập thành công')),
                              );
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderList()),
                              );
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Sai tài khoản hoặc mật khẩu!')),
                              );
                            }
                          } else {
                            var result = await partnerStaffAuthenticate.login(
                                username!, password!);
                            if (result["message"] == "Xác thực thành công.") {
                              var info = await partnerStaffOperation
                                  .getAuthenticatedPartnerStaffInfo();
                              setState(() {
                                driver.fromJson(info["data"]);
                              });

                              result = (await driversOperation.getTask(
                                  GettingDriverTasksCondition(
                                      staffId: driver.staffId, option: 0)));
                              var vehs = result["data"];

                              for (int i = 0; i < vehs.length; i++) {
                                Shipment shipment = Shipment();
                                Vehicle vehicle = Vehicle();
                                setState(() {
                                  shipment.fromJson(vehs[i]["shipment"]);
                                  vehicle.fromJson(vehs[i]);
                                  vehicle.shipment = shipment;
                                  vehicles.add(vehicle);
                                });
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đăng nhập thành công')),
                              );
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ShipmentList()),
                              );
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Sai tài khoản hoặc mật khẩu!')),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'XÁC THỰC',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
