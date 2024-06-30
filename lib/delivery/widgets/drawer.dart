import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/view/driver/partner_staff_information.dart';
import 'package:logistics_app/delivery/view/driver/shipments.dart';
import 'package:logistics_app/delivery/view/shipper/staff_information.dart';
import '../models/current.dart';
import '../view/shipper/orders.dart';
import '../view/shipper/history.dart';
import '../view/login.dart';

class MyDrawer extends StatefulWidget {
  final bool isStaff;
  const MyDrawer({super.key, this.isStaff = true});

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
                                  builder: (context) => const Login()),
                            );
                            setState(() {
                              orders.clear();
                              vehicles.clear();
                            });
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
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              height: 50
                ),
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
              ListTile(
                leading: const Icon(Icons.person, color: Colors.red),
                title:
                    Text(widget.isStaff ? shipper.fullname! : driver.fullname!),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.isStaff
                            ? const StaffInfor()
                            : const PartnerStaffInfor()),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.shopping_bag_outlined, color: Colors.red),
                title: const Text('Tất cả đơn hàng'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.isStaff
                            ? const OrderList()
                            : const ShipmentList()),
                  );
                },
              ),
              widget.isStaff
                  ? ListTile(
                      leading: const Icon(Icons.history, color: Colors.red),
                      title: const Text('Lịch sử'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const History()),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Đăng xuất'),
                onTap: () {
                  logout();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
