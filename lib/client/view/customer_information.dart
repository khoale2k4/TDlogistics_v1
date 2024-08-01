// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_app/client/bloc/api_customer.dart';
import '../models/language.dart';
import '../widgets/drawer.dart';
import '../models/current.dart';

class Infor extends StatefulWidget {
  const Infor({super.key});

  @override
  State<Infor> createState() => _InforState();
}

class _InforState extends State<Infor> {
  bool editing = false;
  bool updating = false;

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

  Future<String?> showOptionDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(imageSource),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('Option 1');
              },
              child: Row(
                children: [
                  Icon(Icons.camera),
                  const SizedBox(width: 10),
                  Text(camera),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('Option 2');
              },
              child: Row(
                children: [
                  Icon(Icons.photo),
                  const SizedBox(width: 10),
                  Text(gallery),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop('Null');
                  },
                  child: Text(close),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      String? result = await showOptionDialog(context);
      if (result == "Null") return;
      final pickedFile = await ImagePicker().pickImage(
          source:
              result == "Option 1" ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        setState(() {
          imageBytes = image;
        });

        UpdatingAvatarPayload updatingUserAvatarInfo =
            UpdatingAvatarPayload(avatar: File(pickedFile.path));

        var response =
            await customerOperation.updateAvatar(updatingUserAvatarInfo);
        if (response['error'] != 'false') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$error ${response['message']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successUploadImage)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/client/assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
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
                              color: Colors.white,
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
                        height: MediaQuery.of(context).size.height -
                            (editing ? 450 : 390),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: updating
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 10),
                                  Text(updatingInfo)
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(title: userID, info: user.id!),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                      title: name,
                                      info: user.name ?? noInfor,
                                      func: setName,
                                      edit: editing,
                                      initText: user.name,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                        title: phoneNumField,
                                        info: user.phoneNum!),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                      title: "Email",
                                      info: user.email ?? noInfor,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                      title: city,
                                      info: user.city ?? noInfor,
                                      func: setProvince,
                                      edit: editing,
                                      initText: user.city,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                      title: district,
                                      info: user.district ?? noInfor,
                                      func: setDistrict,
                                      edit: editing,
                                      initText: user.district,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                      title: ward,
                                      info: user.ward ?? noInfor,
                                      func: setWard,
                                      edit: editing,
                                      initText: user.ward,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CardInfo(
                                      title: detail,
                                      info: user.address ?? noInfor,
                                      func: setAddress,
                                      edit: editing,
                                      initText: user.address,
                                    ),
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
                            if (updating) return;
                            if (editing) {
                              setState(() {
                                updating = true;
                              });
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
                                  SnackBar(content: Text(faildUpdate)),
                                );
                              } else {
                                setState(() {
                                  user.id = update['data']['id'];
                                  user.name = update['data']['fullname'];
                                  user.city = update['data']['province'];
                                  user.district = update['data']['district'];
                                  user.ward = update['data']['ward'];
                                  user.address =
                                      update['data']['detailAddress'];
                                  user.email =
                                      update['data']["account"]['email'];
                                  user.phoneNum =
                                      update['data']["account"]['phoneNumber'];
                                  user.role = update['data']["account"]['role'];
                                  user.detail = null;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(successUpdateInfo)),
                                );
                              }

                              setState(() {
                                updating = false;
                              });
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
                                editing ? save : edit,
                                style: const TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      editing && !updating
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

                                  var infor = await customerOperation
                                      .getAuthenticatedCustomerInfo();

                                  setState(() {
                                    user.id = infor['data']['id'];
                                    user.name = infor['data']['fullname'];
                                    user.city = infor['data']['province'];
                                    user.district = infor['data']['district'];
                                    user.ward = infor['data']['ward'];
                                    user.address =
                                        infor['data']['detailAddress'];
                                    user.email =
                                        infor['data']["account"]['email'];
                                    user.phoneNum =
                                        infor['data']["account"]['phoneNumber'];
                                    user.role =
                                        infor['data']["account"]['role'];
                                    user.detail = null;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      cancel,
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
              top: 45,
              right: 20,
              child: Builder(
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.red),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              en = !en;
                            });
                            print(en);
                            if (en) {
                              toEnLanguage();
                            } else {
                              toViLanguage();
                            }
                          },
                          icon: const Icon(
                            Icons.language,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
