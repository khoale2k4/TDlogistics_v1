// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_app/client/bloc/api_customer.dart';
import '../widgets/drawer.dart';
import '../models/current.dart';

class Infor extends StatefulWidget {
  const Infor({super.key});

  @override
  State<Infor> createState() => _InforState();
}

class _InforState extends State<Infor> {
  bool editing = false;

  void setProvince(String str) {
    if (str == "") return;
    setState(() {
      user.city = str;
    });
  }

  void setDistrict(String str) {
    if (str == "") return;
    setState(() {
      user.district = str;
    });
  }

  void setWard(String str) {
    if (str == "") return;
    setState(() {
      user.ward = str;
    });
  }

  void setAddress(String str) {
    if (str == "") return;
    setState(() {
      user.address = str;
    });
  }

  void setName(String str) {
    if (str == "") return;
    setState(() {
      user.name = str;
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        setState(() {
          imageBytes = image;
        });

        UpdatingAvatarPayload updatingUserAvatarInfo =
            UpdatingAvatarPayload(avatar: File(pickedFile.path));

        var response = await customerOperation.updateAvatar(updatingUserAvatarInfo);
        if (response['error'] != 'false') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${response['message']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật ảnh đại diện thành công')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      user.role!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: imageBytes != null
                            ? MemoryImage(imageBytes!)
                            : const AssetImage("lib/client/assets/avt.jpg")
                                as ImageProvider,
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: MediaQuery.of(context).size.height - (editing?450:390),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(title: "Mã người dùng", info: user.id!),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Họ và tên",
                              info: user.name ?? "Chưa có thông tin",
                              func: setName,
                              edit: editing,
                              initText: user.name,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                                title: "Số điện thoại", info: user.phoneNum!),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Email",
                              info: user.email ?? "Chưa có thông tin",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Tỉnh/Thành phố",
                              info: user.city ?? "Chưa có thông tin",
                              func: setProvince,
                              edit: editing,
                              initText: user.city,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Quận/Huyện",
                              info: user.district ?? "Chưa có thông tin",
                              func: setDistrict,
                              edit: editing,
                              initText: user.district,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Phường/Xã",
                              info: user.ward ?? "Chưa có thông tin",
                              func: setWard,
                              edit: editing,
                              initText: user.ward,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(
                              title: "Địa chỉ chi tiết",
                              info: user.address ?? "Chưa có thông tin",
                              func: setAddress,
                              edit: editing,
                              initText: user.address,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CardInfo(title: "Vai trò", info: user.role!),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (editing) {
                            UpdatingCustomerParams params =
                                UpdatingCustomerParams(customerId: user.id!);
                            UpdatingCustomerPayload payload =
                                UpdatingCustomerPayload(
                              detailAddress: user.address,
                              district: user.district,
                              fullname: user.name,
                              province: user.city,
                              ward: user.ward,
                            );

                            var update = await customerOperation.updateInfo(
                                params, payload);
                            print(update);
                            if (update["error"] != "No error") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Không thể cập nhật thông tin')),
                              );
                            } else {
                              setState(() {
                                user.id = update['data']['id'];
                                user.name = update['data']['fullname'];
                                user.city = update['data']['province'];
                                user.district = update['data']['district'];
                                user.ward = update['data']['ward'];
                                user.address = update['data']['detailAddress'];
                                user.email = update['data']["account"]['email'];
                                user.phoneNum =
                                    update['data']["account"]['phoneNumber'];
                                user.role = update['data']["account"]['role'];
                                user.detail = null;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Cập nhật thông tin thành công')),
                              );
                            }
                          }
                          setState(() {
                            editing = !editing;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            Text(
                              editing ? "Lưu" : "Chỉnh sửa",
                              style: const TextStyle(color: Colors.green),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    editing
                        ? Container(
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  editing = !editing;
                                });

                                var infor = await customerOperation.getAuthenticatedCustomerInfo();
                                
                              setState(() {
                                user.id = infor['data']['id'];
                                user.name = infor['data']['fullname'];
                                user.city = infor['data']['province'];
                                user.district = infor['data']['district'];
                                user.ward = infor['data']['ward'];
                                user.address = infor['data']['detailAddress'];
                                user.email = infor['data']["account"]['email'];
                                user.phoneNum =
                                    infor['data']["account"]['phoneNumber'];
                                user.role = infor['data']["account"]['role'];
                                user.detail = null;
                              });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Huỷ",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
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

class CardInfo extends StatefulWidget {
  final String title;
  final String info;
  final Function(String str)? func;
  final bool edit;
  final String? initText;
  const CardInfo({
    super.key,
    required this.title,
    required this.info,
    this.func,
    this.edit = false,
    this.initText,
  });

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 223, 223, 223),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          widget.edit
              ? TextFormField(
                  onChanged: (value) {
                    widget.func!(value);
                  },
                  initialValue: widget.initText,
                  decoration: InputDecoration(
                    hintText: widget.info,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gapPadding: 10),
                  ),
                )
              : Text(
                  widget.info,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
        ],
      ),
    );
  }
}
