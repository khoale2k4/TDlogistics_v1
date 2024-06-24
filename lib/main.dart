import 'package:flutter/material.dart';
import 'package:logistics_app/client/view/add%20order/add_order.dart';
import 'package:logistics_app/client/view/customer_information.dart';
import 'package:logistics_app/client/view/history.dart';
import 'package:logistics_app/delivery/widgets/qr_scanner.dart';
// import 'package:logistics_app/client/view/login/email_validation.dart';
import 'client/view/login/email_phone.dart';
// import 'client/view/add order/add_order.dart';
// import 'client/view/customer_information.dart';
import 'delivery/view/login.dart';
import 'client/widgets/ggmap_2_markers.dart';
import 'delivery/widgets/ggmap_direction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: 
        LoginUser(),
        // History(),
        // Infor(),
        // QRViewExample(),
        // OrderList(),
        // OrderForm(),
        // Scaffold(body: 
        // GGMapDirection(
        //   SourceLat: 21.0277644, SourceLong:  105.8341598,
        //   DestinationLat:  15.8800584, DestinationLong:  108.3380469,
        //   source: "Thành phố Hà Nội", destination: "Thành phố Hội An",
        // )
        // ),
        // home: Scaffold(body: 
        //   GGMap2Marker(
        //     add1: "123, Phuong Pham Ngu Lao, Quan 1, Thanh pho Ho Chi Minh", 
        //     add2:"321, Phuong Pham Ngu Lao, Quan 1, Thanh pho Ho Chi Minh"
        //   )
        // ),
    );
  }
}