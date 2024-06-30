import 'package:flutter/material.dart';
import 'package:logistics_app/client/bloc/load_orders.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../bloc/load_user_infor.dart';
import '../customer_information.dart';
import '../../models/current.dart';
import '../../models/cities.dart';

class EmailValidation extends StatefulWidget {
  final String phoneNum;
  final String email;
  const EmailValidation(
      {super.key, required this.phoneNum, required this.email});

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  TextEditingController _pinCodeController = TextEditingController();

  void loadingData() {
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
                  Text('Đang tải dữ liệu'),
                  SizedBox(height: 15),
                ],
              ),
            )));
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
              "Nhập mã xác minh",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PinCodeTextField(
                    controller: _pinCodeController,
                    appContext: context,
                    keyboardType: TextInputType.number,
                    length: 4,
                    textStyle: const TextStyle(color: Colors.black),
                    onChanged: (value) {},
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.grey,
                      inactiveFillColor: Colors.white,
                      activeColor: Colors.white,
                      selectedColor: Colors.white,
                      inactiveColor: Colors.white,
                    ),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
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
                        loadingData();
                        load();
                        var result = await authOperation.verifyOTP(
                            widget.phoneNum,
                            _pinCodeController.text,
                            widget.email);

                        print(result);

                        if (result['error'] == "No error") {
                          await loadOrders();
                          await loadUserInfor();

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Infor()),
                          );
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Sai OTP. Vui lòng kiểm tra lại Email!')),
                          );
                        }
                      },
                      child: const Text(
                        'XÁC NHẬN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                        Navigator.pop(context);
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
          ],
        ),
      ),
    );
  }
}
