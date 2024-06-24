import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/client/models/user.dart';
import '../../widgets/dropdown_getplace.dart';

class Resignation extends StatefulWidget {
  const Resignation({super.key});

  @override
  State<Resignation> createState() => _ResignationState();
}

class _ResignationState extends State<Resignation> {
  String city = "";
  String district = "";
  String ward = "";
  User user = User("", "", "", "", "", "", "", "", "", "");

  void setCity(String str) {
    setState(() {
      city = str;
    });
  }

  void setDis(String str) {
    setState(() {
      district = str;
    });
  }

  void setWard(String str) {
    setState(() {
      ward = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "TDLogistics",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 3 / 4,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 400,
                    width: 275,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Thông tin doanh nghiệp",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Tên tài khoản"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Tên doanh nghiệp"),
                          ),
                          const TextField(
                            decoration: InputDecoration(hintText: "Mật khẩu"),
                          ),
                          const TextField(
                            decoration: InputDecoration(hintText: "Email"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Số điện thoại"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Tên ngân hàng"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Số tài khoản"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Địa chỉ cụ thể"),
                          ),
                          const TextField(
                            decoration: InputDecoration(hintText: "Mã số thuế"),
                          ),
                          PlaceDropDown(
                            setCity: setCity,
                            setDis: setDis,
                            setWard: setWard,
                            user: user,
                          ),
                          const Text(
                            "Đại diện doanh nghiệp",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const TextField(
                            decoration: InputDecoration(hintText: "Họ tên"),
                          ),
                          const TextField(
                            decoration: InputDecoration(hintText: "Email"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Số điện thoại"),
                          ),
                          const TextField(
                            decoration: InputDecoration(hintText: "Ngày sinh"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Tên ngân hàng"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Số tài khoản"),
                          ),
                          const TextField(
                            decoration:
                                InputDecoration(hintText: "Địa chỉ cụ thể"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'XÁC MINH',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
