import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class CusCare extends StatefulWidget {
  const CusCare({super.key});

  @override
  State<CusCare> createState() => _CusCareState();
}

class _CusCareState extends State<CusCare> {
  final snackBar = SnackBar(
    content: const Text('Tính năng này chưa khả dụng'),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 223, 223),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height - 40,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(20.0),
                      height: 100,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: const Text(
                        "Xin chào, chúng tôi có thể giúp gì cho bạn?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Các vấn đề khác",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                              "Các vấn đề như chương trình khuyến mãi, tài khoản, lỗi ứng dụng,... sẽ được báo cáo tại đây"),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Gửi yêu cầu trợ giúp",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(20.0),
                      height: 352,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Trung tâm trợ giúp",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Bạn có thể tìm hướng dẫn cho các vấn đề thường gặp tại đây",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Giới thiệu khách hàng",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Chương trình ưu đãi",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Quy trình vận hành đơn hàng",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Bản giá dịch vụ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Điều khoản và chính sách",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Phương thức thanh toán và chính sách trả trước",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text(
                              "Các kênh hỗ trợ khách hàng",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.cyan),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(20.0),
                      height: 190,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "lib/client/assets/customer.png",
                            height: 100,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hỗ trợ nhanh",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: const Text(
                                    "Giải đáp thắc mắc nhanh chóng",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: const Text(
                                      "Trò chuyện ngay",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
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
