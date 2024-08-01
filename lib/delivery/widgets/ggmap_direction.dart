import 'dart:convert';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logistics_app/delivery/models/order.dart';
import 'package:geolocator/geolocator.dart';
class GGMapDirection extends StatefulWidget {
  final Order order;
  final Function() retur;
  const GGMapDirection({
    super.key,
    required this.order,
    required this.retur,
  });

  @override
  State<GGMapDirection> createState() => _GGMapDirectionState();
}

class _GGMapDirectionState extends State<GGMapDirection> {
  final String host = '192.168.1.3'; // Địa chỉ IP của thiết bị chạy server
  final int port = 8080;
  Socket? socket;

  void connectSocket() async {
    try {
      // Tạo kết nối đến server
      socket = await Socket.connect(host, port);
      print(
          'Connected to: ${socket!.remoteAddress.address}:${socket!.remotePort}');

      // Gửi dữ liệu đến server
      socket!.write('Hello, server from dart!\n');

      // Lắng nghe dữ liệu từ server
      socket!.listen((List<int> data) {
        print(String.fromCharCodes(data));
      }, onDone: () {
        print('Disconnected from server');
        socket!.destroy();
      }, onError: (error) {
        print('Error: $error');
        socket!.destroy();
      });
    } catch (e) {
      print('Unable to connect: $e');
    }
  }

  LatLng? _location1;
  LatLng? _location2;
  String add1 = "";
  String add2 = "";
  late GoogleMapController mapController;
  final Set<Polyline> _polylines = {};
  CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(10.762622, 106.660172));

  bool _isExpanded = true;

  Marker source = Marker(
    markerId: const MarkerId('origin'),
    infoWindow: const InfoWindow(title: 'Origin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );
  Marker destination = Marker(
    markerId: const MarkerId('destination'),
    infoWindow: const InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );

  List<String> addressConvert(Order order) {
    String rs = "";
    List<String> rsList = [];
    if (order.detailSource != "") rs += (order.detailSource ?? "");
    if (order.wardSource != "")
      rs += (rs != "" ? ", " : "") + (order.wardSource ?? "");
    if (order.districtSource != "")
      rs += (rs != "" ? ", " : "") + (order.districtSource ?? "");
    if (order.provinceSource != "")
      rs += (rs != "" ? ", " : "") + (order.provinceSource ?? "");
    rsList.add(rs);

    rs = "";
    if (order.detailDest != "") rs += (order.detailDest ?? "");
    if (order.wardDest != "")
      rs += (rs != "" ? ", " : "") + (order.wardDest ?? "");
    if (order.districtDest != "")
      rs += (rs != "" ? ", " : "") + (order.districtDest ?? "");
    if (order.provinceDest != "")
      rs += (rs != "" ? ", " : "") + (order.provinceDest ?? "");
    rsList.add(rs);

    return rsList;
  }

  List<LatLng> _decodePolyline(String poly) {
    var list = poly.codeUnits;
    var lList = new List.empty(growable: true);
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 0x20);

      if ((result & 1) != 0) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    List<LatLng> positions = new List.empty(growable: true);
    for (var i = 0; i < lList.length; i += 2) {
      positions.add(LatLng(lList[i], lList[i + 1]));
    }
    return positions;
  }

  Future<void> _drawRoute() async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.order.latSource!},${widget.order.longSource!}&destination=${widget.order.latDestination!},${widget.order.longDestination!}&key=AIzaSyB1D4XCGPDidtXUwOw1K-gQ8VPB2c4IxC8'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final overviewPolyline = route['overview_polyline']['points'];
          final points = _decodePolyline(overviewPolyline);
          if (mounted) {
            setState(() {
              _polylines.add(Polyline(
                polylineId: PolylineId('route'),
                points: points,
                color: Colors.blue,
                width: 5,
              ));
            });
          }
        }
      } else {
        throw Exception('Failed to load directions');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    // connectSocket();
    _location1 = LatLng(widget.order.latSource??0, widget.order.longSource ??0);
    _location2 =
        LatLng(widget.order.latDestination??0, widget.order.longDestination??0);
        print(_location1!);
    List<String> adds = addressConvert(widget.order);
    add1 = adds[0];
    add2 = adds[1];
    mapController = controller;
    initCamera();
    _drawRoute();
  }

  void initCamera() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _location1!.latitude < _location2!.latitude
            ? _location1!.latitude
            : _location2!.latitude,
        _location1!.longitude < _location2!.longitude
            ? _location1!.longitude
            : _location2!.longitude,
      ),
      northeast: LatLng(
        _location1!.latitude > _location2!.latitude
            ? _location1!.latitude
            : _location2!.latitude,
        _location1!.longitude > _location2!.longitude
            ? _location1!.longitude
            : _location2!.longitude,
      ),
    );
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      ),
      zoom: 11.0,
    );
    setState(() {
      source = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _location1!,
      );
      destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: _location2!,
      );
    });
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  void _getPermissions() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    _getCurrentLocation();
  }

  LatLng current = LatLng(0, 0);

  void _getCurrentLocation() {
    print("smth");
    Geolocator.getPositionStream().listen((Position position) {
      if (mounted)
        setState(() {
          current = LatLng(position.latitude, position.longitude);
        });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {source, destination},
          polylines: _polylines,
        ),
        Positioned(
          top: 40,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                widget.retur();
              },
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextButton(
              child: Text(_isExpanded ? "Ẩn thông tin" : "Hiện thông tin"),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.location_on,
                  size: 36.0, color: Colors.black),
              onPressed: () {
                mapController.animateCamera(CameraUpdate.newLatLng(current));
              },
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 15,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.white,
                child: Icon(Icons.zoom_in, size: 36.0, color: Colors.black),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                onPressed: _zoomOut,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.white,
                child: Icon(Icons.zoom_out, size: 36.0, color: Colors.black),
              ),
            ],
          ),
        ),
        _isExpanded
            ? Positioned(
                top: _isExpanded ? 100 : 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.newLatLng(
                              _location1 ?? LatLng(0, 0)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.place, color: Colors.blue, size: 50),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                  'Điểm gửi: ${add1} \nTên: ${widget.order.nameSender} \nSĐT: ${widget.order.phoneNumberSender}',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.newLatLng(
                              _location2 ?? LatLng(0, 0)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.place, color: Colors.red, size: 50),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                  'Điểm nhận: ${add2}\nTên: ${widget.order.nameReceiver} \nSĐT: ${widget.order.phoneNumberReceiver}',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
