import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/delivery/bloc/driver_api.dart';
import 'package:logistics_app/delivery/bloc/load.dart';
import 'package:logistics_app/delivery/bloc/staff_shipper_api.dart';
import 'package:logistics_app/delivery/models/order.dart';
import 'package:logistics_app/delivery/models/shipment.dart';
import 'package:logistics_app/delivery/models/shipper.dart';
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
  bool isPartnet = true;
  bool showPassword = false;
  String? username = "minhluxuanSP";
  String? password = "LUXUANMINH@2k4";

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
                      // const SizedBox(height: 20),
                      // const Text(
                      //   'TD LOGISTICS',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
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
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: Icon(showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
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
                            var result =
                                await authOperation.login(username!, password!);
                            print(result);
                            if (result["error"] == false) {
                              var info = await staffsOperation
                                  .getAuthenticatedStaffInfo();
                              if (info["data"] == null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(info["message"])),
                                );
                                return;
                              }

                              setState(() {
                                shipper = Shipper.fromJson(info["data"]);
                              });
                              if (shipper.account!.role! != "SHIPPER") {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Bạn không phải SHIPPER')),
                                );
                                return;
                              }

                              await loadHistory();
                              await loadTasks();
                              await loadAvatar();

                              for(var i = 0; i < orders.length; i++){
                                await loadImages(orders[i]);
                              }
                              for(var i = 0; i < history.length; i++){
                                await loadImages(history[i]);
                                print(history[i].receiveImgs);
                              }


                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
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
                                SnackBar(
                                    content: Text('Lỗi: ${result["message"]}')),
                              );
                            }
                          } else {
                            var result =
                                await authOperation.login(username!, password!);
                            if (result["error"] == false) {
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
