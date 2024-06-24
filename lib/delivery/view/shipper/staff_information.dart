// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';
import '../../models/current.dart';

class StaffInfor extends StatefulWidget {
  const StaffInfor({super.key});

  @override
  State<StaffInfor> createState() => _StaffInforState();
}

class _StaffInforState extends State<StaffInfor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      shipper.role!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar(
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : const AssetImage("lib/client/assets/avt.jpg")
                              as ImageProvider,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: MediaQuery.of(context).size.height - 320,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Mã nhân viên",
                                info: (shipper.staffId ?? "Chưa có thông tin")
                                    .toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Vị trí",
                                info: shipper.position.toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Họ và tên",
                              info: shipper.fullname ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Căn cước công dân",
                                info: shipper.cccd.toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Số điện thoại",
                                info: shipper.phoneNumber!),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Email",
                              info: shipper.email ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Tỉnh/Thành phố",
                              info: shipper.province ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Quận/Huyện",
                              info: shipper.district ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Phường/Xã",
                              info: shipper.town ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Địa chỉ chi tiết",
                              info:
                                  shipper.detailAddress ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Ngân hàng",
                                info: shipper.bank.toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Số tài khoản",
                                info: shipper.bin.toString()),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
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
    );
  }
}

class CardInfo extends StatefulWidget {
  final String title;
  final String info;
  const CardInfo({
    super.key,
    required this.title,
    required this.info,
  });

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 223, 223, 223),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.info,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
