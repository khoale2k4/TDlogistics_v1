import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  var formatter = NumberFormat("#,### VNĐ", "vi_VN");
  return formatter.format(amount);
}