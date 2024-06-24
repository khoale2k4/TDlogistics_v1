import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapOperation{
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    LatLng? rs;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyB1D4XCGPDidtXUwOw1K-gQ8VPB2c4IxC8'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
            rs = LatLng(location['lat'], location['lng']);
      }
      return rs != null ? rs : null;
    } else {
      throw Exception('Failed to load coordinates');
    }
  }
}