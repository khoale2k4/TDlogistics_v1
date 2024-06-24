// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'username_passwork.dart';
import 'email_validation.dart';
import '../../models/current.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  String email = "levodangkhoatg2@gmail.com";
  String phone = "0708103015";

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
                            email = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
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
                            labelText: 'Số điện thoại',
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
                                builder: (BuildContext context) => const Dialog(
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
                                          Text('Đang gửi OTP tới Email'),
                                          SizedBox(height: 15),
                                        ],
                                      ),
                                    )));
                            if (email == "" || phone == "") {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Bạn nhập thiếu gì rồi!')),
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
                                        'Gửi OTP thất bại: ${result['message'] ?? "Lỗi web"}')),
                              );
                            }
                          },
                          child: const Text(
                            'XÁC MINH',
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
                                  builder: (context) => const LoginUserPass()),
                            );
                          },
                          child: const Text(
                            'KHÁCH HÀNG DOANH NGHIỆP',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () => {},
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
