import 'package:logistics_app/client/models/order.dart';
import 'package:logistics_app/client/models/current.dart';

Future<void> loadOrders() async {
  orders.clear();
  var orderHistory = (await ordersOperation.get());

  if (orderHistory.isNotEmpty && orderHistory["data"] != null) {
    for (int i = orderHistory["data"].length - 1; i >= 0; i--) {
      if(orderHistory["data"][i]["userId"] != user.id) continue;
      Order ord = Order.fromJson(orderHistory["data"][i]);
      orders.add(ord);
    } 
  }
}
