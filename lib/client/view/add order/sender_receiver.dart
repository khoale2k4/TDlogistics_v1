import '../../models/user.dart';

User blank = User("", "", "", "", "", "", "", "", "", "");
User sender = User("", "", "", "", "", "", "", "", "", "");
User receiver = User("", "", "", "", "", "", "", "", "", "");

int mon = 0;
int wei = 0;
int hei = 0;
int wid = 0;
int len = 0;
int fee = 0;

String? sendingMethod;

void clearData(){
  sender = blank;
  receiver = blank;
  mon = 0;
  wei = 0;
  hei = 0;
  wid = 0;
  len = 0;
  fee = 0;
  sendingMethod = null;
}

String addressConvert(User user) {
  String rs = "";
  if (user.address != "") rs += user.address!;
  if (user.ward != "") rs += (rs != ""?", ":"") + user.ward!;
  if (user.district != "") rs += (rs != ""?", ":"") + user.district!;
  if (user.city != "") rs += (rs != ""?", ":"") + user.city!;
  return rs;
}