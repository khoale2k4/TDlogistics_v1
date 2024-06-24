import 'package:logistics_app/client/models/order.dart';
import 'package:logistics_app/client/models/current.dart';

void loadOrders() async {
  orders.clear();
  var orderHistory = (await ordersOperation.get());

  if (orderHistory.isNotEmpty && orderHistory["data"] != null) {
    for (int i = 0; i < orderHistory["data"].length; i++) {
      Order ord = Order();
      ord.fromJson(orderHistory["data"][i]);
      orders.add(ord);
    }
  }
}
