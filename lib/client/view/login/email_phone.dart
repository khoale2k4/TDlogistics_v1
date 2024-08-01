// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logistics_app/client/bloc/noticefication.dart';
import 'package:logistics_app/client/bloc/socket.dart';
import 'package:logistics_app/delivery/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/load_orders.dart';
import '../../bloc/load_user_infor.dart';
import '../../widgets/drawer.dart';
import '../customer_information.dart';
import 'email_validation.dart';
import '../../models/current.dart';
import '../../models/language.dart';

Future<void> checkLoginStatus(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? phoneNumber = prefs.getString('phoneNumber');
  String? cookie2 = prefs.getString('cookie');

  void cantLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginUser()),
    );
  }

  void showExpired() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(expiredToken),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(close),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  if (email != null && phoneNumber != null && cookie2 != null) {
    cookie = cookie2;
    bool isNotExpired = await loadUserInfor();
    if (!isNotExpired) {
      logoutCleanEmail();
      cantLogin();
      showExpired();
      return;
    }
    await loadOrders();
    connectSocket();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Infor()),
    );
  } else {
    cantLogin();
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus(context);
    startNotice();
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

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  String email = "levodangkhoatg2@gmail.com";
  String phone = "0708103015";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Center(
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
              Text(
                greeting,
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
                            email = value;
                          },
                          decoration: InputDecoration(
                            labelText: emailField,
                            prefixIcon: Icon(Icons.mail),
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
                            phone = value;
                          },
                          decoration: InputDecoration(
                            labelText: phoneNumField,
                            prefixIcon: Icon(Icons.phone),
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
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 15),
                                      CircularProgressIndicator(),
                                      SizedBox(height: 15),
                                      Text(sendingOTP),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            if (email == "" || phone == "") {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(missingInfo)),
                              );
                              return;
                            }
                            var result =
                                // await usersAuthenticate.sendOTP(phone, email);
                                await authOperation.sendOTP(phone, email);
                            print(phone + email);
                            print(result);
                            Navigator.pop(context);
                            if (result['error'] == "No error") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmailValidation(
                                      phoneNum: phone, email: email),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '$errorSendingOTP ${result['message'] ?? "Lỗi web"}')),
                              );
                            }
                          },
                          child: Text(
                            submit,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: Text(
                            business,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            en = !en;
                          });
                          print(en);
                          if (en) {
                            toEnLanguage();
                          } else {
                            toViLanguage();
                          }
                        },
                        icon: const Icon(
                          Icons.language,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
