import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirections {
  late LatLngBounds bounds;
  late List<PointLatLng> polylinePoints;
  late String totalDistance;
  late String totalDuration;

  PlaceDirections.fromJson(Map<String, dynamic> json) {
    final northeast = json['bounds']['northeast'];
    final southwest = json['bounds']['southwest'];

    bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );

    polylinePoints = PolylinePoints().decodePolyline(json['overview_polyline']['points']);

    late String distance;
    late String duration;

    if ((json['legs'] as List).isNotEmpty) {
      final leg = json['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    totalDistance = distance;
    totalDuration = duration;
  }
}
