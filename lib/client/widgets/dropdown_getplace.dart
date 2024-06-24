import 'package:flutter/material.dart';
import '../models/cities.dart';
import '../models/user.dart';

class PlaceDropDown extends StatefulWidget {
  final Function(String str) setCity;
  final Function(String str) setDis;
  final Function(String str) setWard;
  final User user;
  final bool hasError;

  const PlaceDropDown({
    super.key,
    required this.setCity,
    required this.setDis,
    required this.setWard,
    this.hasError = false,
    required this.user,
  });

  @override
  State<PlaceDropDown> createState() => _PlaceDropDownState();
}

class _PlaceDropDownState extends State<PlaceDropDown> {
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedDistrict =
          widget.user.district == "" ? null : widget.user.district;
      selectedProvince = widget.user.city == "" ? null : widget.user.city;
      selectedWard = widget.user.ward == "" ? null : widget.user.ward;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: widget.hasError &&
                          (selectedProvince == null || selectedProvince == "")
                      ? Colors.red
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Chọn Tỉnh/Thành'),
                  value: selectedProvince,
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.setCity(newValue!);
                      selectedProvince = newValue;
                      selectedDistrict = null;
                      selectedWard = null;
                    });
                  },
                  items: provinces.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            widget.hasError &&
                    (selectedProvince == null || selectedProvince == "")
                ? const Text(
                    "   Vui lòng chọn Tỉnh/Thành",
                    style: TextStyle(color: Color(0xFFE57373), fontSize: 11),
                  )
                : Container()
          ],
        ),
        if (selectedProvince != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: widget.hasError &&
                            (selectedDistrict == null || selectedDistrict == "")
                        ? Colors.red
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Chọn Quận/Huyện'),
                    value: selectedDistrict,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.setDis(newValue!);
                        selectedDistrict = newValue;
                        selectedWard = null;
                      });
                    },
                    items: provinces[selectedProvince]!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              widget.hasError &&
                      (selectedDistrict == null || selectedDistrict == "")
                  ? const Text(
                      "  Vui lòng chọn Quận/Huyện",
                      style: TextStyle(color: Color(0xFFE57373), fontSize: 11),
                    )
                  : Container()
            ],
          ),
        if (selectedDistrict != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: widget.hasError &&
                            (selectedWard == null || selectedWard == "")
                        ? Colors.red
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Chọn Phường/Xã'),
                    value: selectedWard,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.setWard(newValue!);
                        selectedWard = newValue;
                      });
                    },
                    items: districts[selectedDistrict]!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              widget.hasError && (selectedWard == null || selectedWard == "")
                  ? const Text(
                      "  Vui lòng chọn Phường?Xã",
                      style: TextStyle(color: Color(0xFFE57373), fontSize: 11),
                    )
                  : Container()
            ],
          ),
      ],
    );
  }
}
