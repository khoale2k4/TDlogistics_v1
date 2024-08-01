import 'package:flutter/material.dart';
import '../../models/language.dart';
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
  final List<String> detailsList = [
    "Mặt tiền/Mặt phố",
    "Bãi xe",
    "Hẻm/Ngõ 2m",
    "Hẻm/Ngõ 3m",
    "Hẻm/Ngõ ô tô"
  ];

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController numberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    addressController = TextEditingController(text: widget.user.address);
    numberController = TextEditingController(text: widget.user.phoneNum);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void updateUser() {
    setState(() {
      widget.user.name = nameController.text;
      widget.user.phoneNum = numberController.text;
      widget.user.address = addressController.text;
      widget.user.city = widget.user.city!;
      widget.user.district = widget.user.district!;
      widget.user.ward = widget.user.ward!;
      widget.user.detail = widget.user.detail!;
    });
  }

  bool isPhoneValid(String str) {
    return str.isNotEmpty && str[0] == '0' && str.length >= 10 && str.length <= 11;
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
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) => updateUser(),
            controller: addressController,
            decoration: InputDecoration(
              hintText: addressInput,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.address!.isEmpty && widget.next)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.address!.isEmpty && widget.next)
                      ? Colors.red
                      : Colors.grey,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.address!.isEmpty && widget.next)
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            ),
          ),
          if (widget.user.address!.isEmpty && widget.next)
            Text(
              remindAddress,
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 11),
            ),
          const SizedBox(height: 10),
          PlaceDropDown(
            setCity: (str) {
              setState(() => widget.user.city = str);
              updateUser();
            },
            setDis: (str) {
              setState(() => widget.user.district = str);
              updateUser();
            },
            setWard: (str) {
              setState(() => widget.user.ward = str);
              updateUser();
            },
            hasError: widget.next,
            user: widget.user,
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: (widget.user.detail == null || widget.user.detail!.isEmpty) && widget.next
                    ? Colors.red
                    : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(detailInput),
                value: widget.user.detail!.isEmpty ? null : widget.user.detail,
                onChanged: (newValue) {
                  setState(() {
                    widget.user.detail = newValue!;
                    updateUser();
                  });
                },
                items: detailsList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          if ((widget.user.detail == null || widget.user.detail!.isEmpty) && widget.next)
            Text(
              remingDetail,
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 11),
            ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) => updateUser(),
            controller: nameController,
            decoration: InputDecoration(
              hintText: widget.titlte == senderLocation ? nameSenderInput : nameReceiverInput,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.name!.isEmpty || widget.user.name!.split(" ").length == 1) && widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.name!.isEmpty || widget.user.name!.split(" ").length == 1) && widget.next
                      ? Colors.red
                      : Colors.grey,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.name!.isEmpty || widget.user.name!.split(" ").length == 1) && widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              suffixIcon: const Icon(Icons.person_2_rounded, size: 20),
            ),
          ),
          if ((widget.user.name!.isEmpty) && widget.next)
            Text(
              "${remindName}${widget.titlte == senderLocation ? nameSenderInput : nameReceiverInput}",
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 11),
            ),
          if (widget.user.name!.split(" ").length == 1 && widget.next)
            Text(
              "${remindName}${full} ${widget.titlte == senderLocation ? nameSenderInput : nameReceiverInput}",
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 11),
            ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) => updateUser(),
            controller: numberController,
            decoration: InputDecoration(
              hintText: phoneNumField,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.phoneNum!.isEmpty || !isPhoneValid(widget.user.phoneNum!)) && widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.phoneNum!.isEmpty || !isPhoneValid(widget.user.phoneNum!)) && widget.next
                      ? Colors.red
                      : Colors.grey,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (widget.user.phoneNum!.isEmpty || !isPhoneValid(widget.user.phoneNum!)) && widget.next
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              suffixIcon: const Icon(Icons.phone, size: 20),
            ),
          ),
          if (widget.user.phoneNum!.isEmpty && widget.next)
            Text(
              remindPhone,
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 11),
            ),
          if (!isPhoneValid(widget.user.phoneNum!) && widget.next)
            Text(
              remindPhoneCorrect,
              style: const TextStyle(color: Color(0xFFE57373), fontSize: 11),
            ),
        ],
      ),
    );
  }
}
