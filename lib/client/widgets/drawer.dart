import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';
import '../view/add order/add_order.dart';
import '../view/customer_care.dart';
import '../view/history/history.dart';
import '../view/login/email_phone.dart';
import '../view/customer_information.dart';
import '../models/current.dart';
import '../view/add order/sender_receiver.dart';

Future<void> logoutCleanEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await prefs.remove('phoneNumber');
  await prefs.remove('cookie');
}

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
          title: Text(
            confirmLogout,
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
                          child: Text(cancel),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: TextButton(
                          style: ButtonStyle(),
                          onPressed: () async {
                            await logoutCleanEmail();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginUser()),
                            );
                          },
                          child: Text(
                            agree,
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
                accountName: Text(
                  user.name ?? noInfor,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  user.email ?? noInfor,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: imageBytes != null
                      ? MemoryImage(imageBytes!)
                      : const AssetImage("lib/client/assets/avt.jpg")
                          as ImageProvider,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('lib/client/assets/pro_back.jpg'),
                  ),
                ),
              ),
              TextButton(
                iconAlignment: IconAlignment.start,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Infor()),
                  );
                },
                child: Text(
                  infomation,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.red),
                title: Text(addOrder),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderForm()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.red),
                title: Text(history),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const History()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.red),
                title: Text(support),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CusCare()),
                  );
                },
              ),
            ],
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(logoutText),
                onTap: () {
                  logout();
                  clearData();
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
