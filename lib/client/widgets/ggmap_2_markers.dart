import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/client/models/current.dart';

class GGMap2Marker extends StatefulWidget {
  final String add1;
  final String add2;
  final Function() func;
  const GGMap2Marker(
      {super.key, this.add1 = "", this.add2 = "", required this.func});

  @override
  State<GGMap2Marker> createState() => _GGMap2MarkerState();
}

class _GGMap2MarkerState extends State<GGMap2Marker> {
  LatLng? _location1;
  LatLng? _location2;
  late GoogleMapController mapController;
  CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(10.762622, 106.660172));

  bool isExpanded = true;

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

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (widget.add1 != "") {
      _location1 = await mapOperation.getCoordinatesFromAddress(widget.add1);
    }
    if (widget.add2 != "") {
      _location2 = await mapOperation.getCoordinatesFromAddress(widget.add2);
    }
    initCamera();
  }

  void initCamera() {
    if (mounted) {
      setState(() {
        if (_location1 != null && _location2 != null) {
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
            zoom: 19.0,
          );

          source = Marker(
              markerId: const MarkerId('origin'),
              infoWindow: const InfoWindow(title: 'Origin'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: _location1!);
          destination = Marker(
              markerId: const MarkerId('destination'),
              infoWindow: const InfoWindow(title: 'Destination'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: _location2!);
          mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        } else if (_location1 != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Không tìm được vị trí nhận'),
          ));
          _initialCameraPosition = CameraPosition(
            target: _location1!,
            zoom: 14.0,
          );

          source = Marker(
              markerId: const MarkerId('origin'),
              infoWindow: const InfoWindow(title: 'Origin'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: _location1!);

          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(_location1!, 14),
          );
        } else if (_location2 != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Không tìm được vị trí gửi'),
          ));
          _initialCameraPosition = CameraPosition(
            target: _location2!,
            zoom: 14.0,
          );
          destination = Marker(
              markerId: const MarkerId('destination'),
              infoWindow: const InfoWindow(title: 'Destination'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: _location2!);
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(_location2!, 14),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Không tìm được vị trí mà bạn đã nhập'),
          ));
          _initialCameraPosition = CameraPosition(
            target: LatLng(10.762622, 106.660172), // Thành phố Hồ Chí Minh
            zoom: 11.0,
          );
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(10.762622, 106.660172), 11),
          );
        }
      });
    }
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {source, destination},
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
              icon: const Icon(Icons.map, color: Colors.black),
              onPressed: () {
                widget.func();
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
              child: Text(isExpanded ? "Ẩn" : "Hiện"),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 15,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.white,
                child: Icon(Icons.zoom_in, size: 36.0),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                onPressed: _zoomOut,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.white,
                child: Icon(Icons.zoom_out, size: 36.0),
              ),
            ],
          ),
        ),
        isExpanded
            ? Positioned(
                top: 100,
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
                          _location1 != null
                              ? mapController.animateCamera(
                                  CameraUpdate.newLatLng(
                                      _location1 ?? LatLng(0, 0)))
                              : print("ok");
                        },
                        child: Row(
                          children: [
                            Icon(Icons.place, color: Colors.blue, size: 50),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('Điểm gửi: ${widget.add1}',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _location2 != null
                              ? mapController.animateCamera(
                                  CameraUpdate.newLatLng(
                                      _location2 ?? LatLng(0, 0)))
                              : print("ok");
                        },
                        child: Row(
                          children: [
                            Icon(Icons.place, color: Colors.red, size: 50),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('Điểm nhận: ${widget.add2}',
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
