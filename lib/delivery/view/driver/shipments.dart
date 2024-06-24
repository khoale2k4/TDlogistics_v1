import 'package:flutter/material.dart';
import 'package:logistics_app/delivery/bloc/driver_api.dart';
import 'package:logistics_app/delivery/bloc/vehicle_api.dart';
import 'package:logistics_app/delivery/models/current.dart';
import 'package:logistics_app/delivery/models/vehicle.dart';
import '../../widgets/drawer.dart';

double lat = 0.0;
double long = 0.0;

class ShipmentList extends StatefulWidget {
  const ShipmentList({super.key});

  @override
  State<ShipmentList> createState() => _ShipmentListState();
}

class _ShipmentListState extends State<ShipmentList> {
  bool isCollapsed = false;
  List<Vehicle> filteredVehicle = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredVehicle.addAll(vehicles);
  }

  List<Vehicle> searchId(String id) {
    List<Vehicle> rs = vehicles
        .where((vehicle) => vehicle.shipment!.shipmentId!.contains(id))
        .toList();
    return rs;
  }

  void chooseAPoint() {
    setState(() {
      isCollapsed = true;
    });
  }

  final snackBarNotAvailable = const SnackBar(
    content: Text('Tính năng này chưa khả dụng'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(
        isStaff: false,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: isCollapsed
                  ? Container()
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            Container(
                              padding: const EdgeInsets.all(20),
                              height: MediaQuery.of(context).size.height - 120,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Tất cả",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const Divider(
                                      height: 2,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextField(
                                        textAlign: TextAlign.left,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value.isEmpty) {
                                              filteredVehicle = vehicles;
                                            } else {
                                              filteredVehicle = searchId(value);
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Tìm kiếm theo mã lô hàng',
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height -
                                              300,
                                      child: filteredVehicle.isEmpty
                                          ? const Text("Danh sách trống")
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: filteredVehicle.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    VehicleCard(
                                                      vehicle: filteredVehicle[
                                                          index],
                                                      func: chooseAPoint,
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.map, color: Colors.grey),
              onPressed: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                });
              },
            ),
          ),
          Positioned(
            top: 20,
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

class VehicleCard extends StatefulWidget {
  final Vehicle vehicle;
  final Function() func;
  const VehicleCard({super.key, required this.vehicle, required this.func});

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  void showOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn địa điểm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_sharp,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.start, color: Colors.black),
                    Text(
                      'Vị trí bắt đầu',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    lat = widget.vehicle.shipment!.latSource!;
                    long = widget.vehicle.shipment!.longSource!;
                  });
                  Navigator.of(context).pop();
                  widget.func();
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(
                      Icons.start,
                      color: Colors.black,
                    ),
                    Text(
                      'Vị trí kết thúc',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    lat = widget.vehicle.shipment!.latDestination!;
                    long = widget.vehicle.shipment!.longDestination!;
                  });
                  Navigator.of(context).pop();
                  widget.func();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showDetail(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Chi tiết lô hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    vehicle.shipmentId!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Khối lượng lô hàng: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(vehicle.shipment!.mass.toString())
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ngày tạo lô hàng: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(vehicle.createdAt!
                        .replaceFirst('T', ' ')
                        .replaceFirst('.000Z', ''))
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Lần cập nhật cuối: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(vehicle.shipment!.lastUpdate!
                        .replaceFirst('T', ' ')
                        .replaceFirst('.000Z', ''))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> comfirm(Vehicle vehicle, bool finishedOrder) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            Column(
              children: [
                Text(
                  "Xác nhận ${finishedOrder ? "hoàn thành!" : "tiếp nhận đơn hàng!"}",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Hủy bỏ"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red),
                      child: TextButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          "Xác nhận",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    );

    return result ?? false; // Default to false if result is null
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    showOptionDialog();
                  },
                  child:
                      const Text("Chỉ đường", style: TextStyle(fontSize: 15)))
            ],
          ),
          Text(widget.vehicle.shipmentId!,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Vĩ độ bắt đầu: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.vehicle.shipment!.latSource.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Kinh độ bắt đầu: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.vehicle.shipment!.longSource.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Vĩ độ đích: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.vehicle.shipment!.latDestination.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Kinh độ đích: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(widget.vehicle.shipment!.longDestination.toString())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  showDetail(widget.vehicle);
                },
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () async {
                  bool res = await comfirm(widget.vehicle, false);
                  if (res) {
                    vehicleOperation.undertakeShipment(
                        UndertakingVehicleShipmentInfo(
                            shipmentId: widget.vehicle.id.toString()));
                  }
                },
                child: const Text(
                  'Tiếp nhận',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () async {
                  bool res = await comfirm(widget.vehicle, true);
                  if (res) {
                    driversOperation.confirmCompletedTask(
                        ConfirmingCompletedTaskCondition(
                            id: widget.vehicle.id!));
                    setState(() {
                      vehicles.removeWhere(
                          (vehicle) => vehicle.id == widget.vehicle.id);
                    });
                  }
                },
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
