// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapit/constants/constants.dart';
import 'package:mapit/helpers/location_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static Position? position;
  final Completer<GoogleMapController> _mapController = Completer();

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  @override
  void initState() {
    getMyCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            position != null
                ? buildMap()
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
        floatingActionButton: Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
          child: FloatingActionButton(
            onPressed: _goToMyCurrentLocation,
            child: Icon(Icons.place, color: Colors.white),
            backgroundColor: AppColor.blue,
          ),
        ),
      ),
    );
  }
}
