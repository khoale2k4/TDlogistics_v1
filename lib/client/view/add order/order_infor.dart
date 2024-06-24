import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sender_receiver.dart';

class OrderInfor extends StatefulWidget {
  final bool clicked;
  final Function() func;
  const OrderInfor({
    super.key,
    required this.func,
    required this.clicked,
  });

  @override
  State<OrderInfor> createState() => _OrderInforState();
}

class _OrderInforState extends State<OrderInfor> {
  late TextEditingController money;
  late TextEditingController weight;
  late TextEditingController length;
  late TextEditingController height;
  late TextEditingController width;
  List<int> suggestions = [1000, 10000, 100000, 1000000];
  String? _selectedMethod = sendingMethod;

  final List<String> _shippingMethods = [
    'CPN: Giao hàng nhanh',
    'TTK: Giao hàng tiết kiệm',
    'HTT: Giao hàng hoả tốc',
  ];

  List<int> getSuggestList(int start) {
    if (start == 0) return [];
    List<int> result = [];
    int tem = start;
    while (tem < 1000) {
      tem *= 10;
    }
    for (int i = 0; i < 4 && tem < 1000000000; i++) {
      result.add(tem);
      tem *= 10;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    money = TextEditingController();
    weight = TextEditingController();
    length = TextEditingController();
    height = TextEditingController();
    width = TextEditingController();

    weight.text = wei.toString();
    length.text = len.toString();
    height.text = hei.toString();
    width.text = wid.toString();
    money.text = mon.toString();
    suggestions = getSuggestList(mon);
  }

  @override
  void dispose() {
    money.dispose();
    weight.dispose();
    length.dispose();
    height.dispose();
    width.dispose();
    super.dispose();
  }

  void _setSuggestedValue(int value) {
    setState(() {
      money.text = value.toString();
    });
  }

  String _formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thêm chi tiết",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: widget.func,
                child: const Text("Quay lại"),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiền thu hộ (có thể để trống)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: money,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Tiền thu hộ (vnd)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value == "" || value == "0") {
                      money.text = "0";
                      setState(() {
                        suggestions = [];
                        mon = 0;
                      });
                    } else {
                      int? intValue = int.tryParse(value);
                      if (intValue == null || intValue < 0) {
                        return;
                      }
                      setState(() {
                        suggestions = getSuggestList(int.parse(value));
                        mon = int.parse(value);
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                money.text == "0" || money.text == ""
                    ? Container()
                    : Wrap(
                        spacing: 10,
                        children: suggestions.map((suggestion) {
                          final isSelected =
                              money.text == suggestion.toString();
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                isSelected ? Colors.red : Colors.white,
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                isSelected ? Colors.white : Colors.black,
                              ),
                              side: WidgetStateProperty.all(
                                BorderSide(
                                  color: isSelected ? Colors.red : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: ()  {
                              _setSuggestedValue(suggestion);
                              setState(() {
                                mon = suggestion;
                                money.text = suggestion.toString();
                              });
                            },
                            child: Text(
                              _formatNumber(suggestion),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Khối lượng",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                weight.text == "0" && widget.clicked
                    ? const Text(
                        "Vui lòng nhập khối lượng",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: weight,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Khối lượng (g)",
                    border: const OutlineInputBorder(),
                    suffix: TextButton(
                      onPressed: () {
                        setState(() {
                          weight.text = (int.parse(weight.text) + 1).toString();
                          wei = int.parse(weight.text);
                        });
                      },
                      child: const Text(
                        "+",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    prefix: TextButton(
                      onPressed: () {
                        if (int.parse(weight.text) > 0) {
                          setState(() {
                            weight.text =
                                (int.parse(weight.text) - 1).toString();
                            wei = int.parse(weight.text);
                          });
                        }
                      },
                      child: const Text(
                        "-",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kích thước",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                (length.text == "0" ||
                            height.text == "0" ||
                            width.text == "0") &&
                        widget.clicked
                    ? const Text(
                        "Vui lòng nhập kích thước đầy đủ",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: length,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Dài (cm)",
                    border: const OutlineInputBorder(),
                    suffix: TextButton(
                      onPressed: () {
                        setState(() {
                          length.text = (int.parse(length.text) + 1).toString();
                          len = int.parse(length.text);
                        });
                      },
                      child: const Text(
                        "+",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    prefix: TextButton(
                      onPressed: () {
                        if (int.parse(length.text) > 0) {
                          setState(() {
                            length.text =
                                (int.parse(length.text) - 1).toString();
                            len = int.parse(length.text);
                          });
                        }
                      },
                      child: const Text(
                        "-",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: width,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Rộng (cm)",
                    border: const OutlineInputBorder(),
                    suffix: TextButton(
                      onPressed: () {
                        setState(() {
                          width.text = (int.parse(width.text) + 1).toString();
                          wid = int.parse(width.text);
                        });
                      },
                      child: const Text(
                        "+",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    prefix: TextButton(
                      onPressed: () {
                        if (int.parse(width.text) > 0) {
                          setState(() {
                            width.text = (int.parse(width.text) - 1).toString();
                            wid = int.parse(width.text);
                          });
                        }
                      },
                      child: const Text(
                        "-",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: height,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Cao (cm)",
                    border: const OutlineInputBorder(),
                    suffix: TextButton(
                      onPressed: () {
                        setState(() {
                          height.text = (int.parse(height.text) + 1).toString();
                          hei = int.parse(height.text);
                        });
                      },
                      child: const Text(
                        "+",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    prefix: TextButton(
                      onPressed: () {
                        if (int.parse(height.text) > 0) {
                          setState(() {
                            height.text =
                                (int.parse(height.text) - 1).toString();
                            hei = int.parse(height.text);
                          });
                        }
                      },
                      child: const Text(
                        "-",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Loại hình vận chuyển',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _selectedMethod == null && widget.clicked
                    ? const Text(
                        "Vui lòng chọn loại hình",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedMethod,
                  hint: const Text('Chọn loại hình vận chuyển'),
                  items: _shippingMethods.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMethod = newValue;
                      sendingMethod = _selectedMethod!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
