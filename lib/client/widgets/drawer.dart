import 'package:flutter/material.dart';
import '../view/add order/add_order.dart';
import '../view/customer_care.dart';
import '../view/history.dart';
import '../view/login/email_phone.dart';
import '../view/customer_information.dart';
import '../models/current.dart';
import '../view/add order/sender_receiver.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Hủy bỏ"),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: TextButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginUser()),
                            );
                          },
                          child: const Text(
                            "Xác nhận",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(height: 50, color: Colors.red),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    "lib/client/assets/logo.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              UserAccountsDrawerHeader(
                accountName: Text(user.name ?? "Chưa có thông tin", style: TextStyle(fontWeight: FontWeight.bold),),
                accountEmail: Text(user.email ?? "Chưa có thông tin", style: TextStyle(fontWeight: FontWeight.bold),),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: imageBytes != null
                            ? MemoryImage(imageBytes!)
                            : const AssetImage("lib/client/assets/avt.jpg")
                                as ImageProvider),
                
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Infor()),
                  );
                },
                child: const Text(
                  'Nhấn vào đây để chỉnh sửa thông tin',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.red),
                title: const Text('Thêm đơn hàng'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderForm()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.red),
                title: const Text('Lịch sử'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const History()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.red),
                title: const Text('Hỗ Trợ'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CusCare()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Đăng xuất'),
            onTap: () {
              logout();
              clearData();
            },
          ),
        ],
      ),
    );
  }
}
