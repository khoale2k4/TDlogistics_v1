import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class PartnerStaffHistory extends StatefulWidget {
  const PartnerStaffHistory({super.key});

  @override
  State<PartnerStaffHistory> createState() => _PartnerStaffHistoryState();
}

class _PartnerStaffHistoryState extends State<PartnerStaffHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 223, 223),
      drawer: const MyDrawer(
        isStaff: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Lịch sử đơn hàng",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: BorderSide.strokeAlignCenter,
                          color: Colors.black,
                          indent: 10,
                          endIndent: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.red),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
