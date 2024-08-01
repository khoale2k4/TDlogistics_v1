import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/delivery/bloc/driver_api.dart';
import 'package:logistics_app/delivery/bloc/load.dart';
import 'package:logistics_app/delivery/bloc/noticefication.dart';
import 'package:logistics_app/delivery/models/shipment.dart';
import 'package:logistics_app/delivery/models/vehicle.dart';
import 'package:logistics_app/delivery/view/driver/shipments.dart';
import 'package:logistics_app/delivery/view/shipper/staff_information.dart';
import 'package:logistics_app/delivery/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../client/view/login/email_phone.dart';
import '../models/current.dart';
import 'shipper/orders/orders.dart';

Future<void> checkLoginStatus(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');
  cookie = prefs.getString('cookie');
  print(email);
  print(password);
  print(cookie);

  if (email != null && password != null && cookie != null) {
    bool rs = await loadAll(context);
    if (!rs) return;
    reload();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StaffInfor()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}

Future<void> saveLoginInfo(String email, String password, String cookie) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', password);
  await prefs.setString('cookie', cookie);
  print(email);
  print(password);
  print(cookie);
}

class SplashScreenDeli extends StatefulWidget {
  @override
  _SplashScreenDeliState createState() => _SplashScreenDeliState();
}

class _SplashScreenDeliState extends State<SplashScreenDeli> {
  @override
  void initState() {
    super.initState();
    startNotice();
    checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('lib/client/assets/logoNoWord2.png')),
            Text(
              "Đang tải dữ liệu...",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

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
      body:
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('lib/client/assets/background.gif'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          //   child:
          Center(
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
                              await saveLoginInfo(
                                  username!, password!, cookie!);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Đăng nhập thành công')),
                              );
                              bool rs = await loadAll(context);
                              if (!rs) return;
                              reload();
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StaffInfor()),
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginUser()),
                          );
                        },
                        child: const Text(
                          'QUAY LẠI',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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
