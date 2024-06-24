import 'package:flutter/material.dart';
import '../../widgets/dropdown_getplace.dart';
import '../../models/user.dart';

class InforForm extends StatefulWidget {
  final String titlte;
  final User user;
  final bool next;

  const InforForm({
    super.key,
    required this.titlte,
    required this.user,
    required this.next,
  });

  @override
  State<InforForm> createState() => _InforFormState();
}

class _InforFormState extends State<InforForm> {
  List<String> detailsList = [
    "Mặt tiền/Mặt phố",
    "Bãi xe",
    "Hẻm/Ngõ 2m",
    "Hẻm/Ngõ 3m",
    "Hẻm/Ngõ ô tô"
  ];
  String name = "";
  String phoneNum = "";
  String address = "";
  String city = "";
  String district = "";
  String ward = "";
  String? detail;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController numberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    addressController = TextEditingController(text: widget.user.address);
    numberController = TextEditingController(text: widget.user.phoneNum);
    setState(() {
      name = widget.user.name!;
      phoneNum = widget.user.phoneNum!;
      address = widget.user.address!;
      city = widget.user.city!;
      district = widget.user.district!;
      ward = widget.user.ward!;
      detail = widget.user.detail!;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void setCity(String str) {
    setState(() {
      city = str;
    });
    updateUser();
  }

  void setDis(String str) {
    setState(() {
      district = str;
    });
    updateUser();
  }

  void setWard(String str) {
    setState(() {
      ward = str;
    });
    updateUser();
  }

  void updateUser() {
    setState(() {
      widget.user.name = name;
      widget.user.phoneNum = phoneNum;
      widget.user.address = address;
      widget.user.city = city;
      widget.user.district = district;
      widget.user.ward = ward;
      widget.user.detail = detail;
    });
  }

  bool isPhoneValid(String str) {
    if (str == "") return false;
    if (str[0] != "0") return false;
    if (str.length > 11 || str.length < 10) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titlte,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                address = value;
              });
              updateUser();
            },
            controller: addressController,
            decoration: InputDecoration(
              hintText: "Nhập số nhà, tên đường",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.address == "" && widget.next)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.address == "" && widget.next)
                      ? Colors.red
                      : Colors.grey,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.address == "" && widget.next)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            ),
          ),
          (widget.user.address == "" && widget.next)
              ? const Text(
                  "   Vui lòng nhập số nhà, tên đường",
                  style: TextStyle(color: Color(0xFFE57373), fontSize: 11),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          PlaceDropDown(
            setCity: setCity,
            setDis: setDis,
            setWard: setWard,
            hasError: widget.next,
            user: widget.user,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.5,
                  color: (widget.user.detail == null ||
                              widget.user.detail == "") &&
                          widget.next
                      ? Colors.red
                      : Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Chi tiết địa điểm'),
                value: widget.user.detail == "" ? null : widget.user.detail,
                onChanged: (newValue) {
                  setState(() {
                    detail = newValue;
                    updateUser();
                  });
                },
                items:
                    detailsList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          (widget.user.detail == null || widget.user.detail == "") &&
                  widget.next
              ? const Text(
                  "   Vui lòng chọn thông tin chi tiết",
                  style: TextStyle(color: Color(0xFFE57373), fontSize: 11),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: (value) {
              name = value;
              updateUser();
            },
            controller: nameController,
            decoration: InputDecoration(
              hintText: widget.titlte == "Địa điểm lấy hàng"
                  ? "Tên người gửi"
                  : "Tên người nhận",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.name == "" || widget.user.name!.split(" ").length == 1) && widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.name == "" || widget.user.name!.split(" ").length == 1) && widget.next
                      ? Colors.red
                      : Colors.grey,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.name == "" || widget.user.name!.split(" ").length == 1) && widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              suffixIcon: const Icon(
                Icons.person_2_rounded,
                size: 20,
              ),
            ),
          ),
          (widget.user.name == null || widget.user.name == "") && widget.next
              ? Text(
                  "   Vui lòng nhập ${widget.titlte == "Địa điểm lấy hàng" ? "tên người gửi" : "tên người nhận"}",
                  style:
                      const TextStyle(color: Color(0xFFE57373), fontSize: 11),
                )
              : widget.user.name!.split(" ").length == 1 && widget.next?
              Text(
                  "   Vui lòng nhập đầy đủ ${widget.titlte == "Địa điểm lấy hàng" ? "tên người gửi" : "tên người nhận"}",
                  style:
                      const TextStyle(color: Color(0xFFE57373), fontSize: 11),
                )
              :Container(),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: (value) {
              phoneNum = value;
              updateUser();
            },
            controller: numberController,
            decoration: InputDecoration(
              hintText: "Số điện thoại",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.phoneNum == "" ||
                              !isPhoneValid(widget.user.phoneNum!)) &&
                          widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.phoneNum == "" ||
                              !isPhoneValid(widget.user.phoneNum!)) &&
                          widget.next
                      ? Colors.red
                      : Colors.grey,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.phoneNum == "" ||
                              !isPhoneValid(widget.user.phoneNum!)) &&
                          widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              suffixIcon: const Icon(
                Icons.phone,
                size: 20,
              ),
            ),
          ),
          (widget.user.phoneNum == "") && widget.next
              ? Text(
                  "   Vui lòng nhập số điện thoại ${widget.titlte == "Địa điểm lấy hàng" ? "người gửi" : "người nhận"}",
                  style:
                      const TextStyle(color: Color(0xFFE57373), fontSize: 11),
                )
              : !isPhoneValid(widget.user.phoneNum!) && widget.next
                  ? const Text(
                      "   Vui lòng nhập đúng số điện thoại",
                      style: TextStyle(color: Color(0xFFE57373), fontSize: 11),
                    )
                  : Container(),
        ],
      ),
    );
  }
}
