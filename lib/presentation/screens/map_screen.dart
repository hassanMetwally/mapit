// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapit/business_logic/maps/cubit/maps_cubit.dart';
import 'package:mapit/constants/constants.dart';
import 'package:mapit/data/models/place_location.dart';
import 'package:mapit/data/models/searched_place.dart';
import 'package:mapit/helpers/location_helper.dart';
import 'package:mapit/presentation/widgets/app_drawer.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/place_directions.dart';
import '../widgets/place_item.dart';
import '../widgets/time_and_distance.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //these variables for Map
  final Completer<GoogleMapController> _mapCompleterController = Completer();
  static Position? currentPosition;
  static final CameraPosition _currentCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  //these variables for fetchSearchedPlaces
  FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();
  List<SearchedPlace> places = [];

  // these variables for fetchPlaceLocation
  Set<Marker> markers = {};
  late SearchedPlace searchedPlace;
  late PlaceLocation searchedPlaceLocation;
  late Marker searchedPlaceLocationMarker;
  late Marker currentPlaceLocationMarker;
  late CameraPosition searchedPlaceCameraPosition;

  // these variables for fetchPlaceDirections
  PlaceDirections? placeDirections;
  late List<LatLng> polylinePoints;
  late String time;
  late String distance;
  var progressIndicator = false;
  bool isSearchedPlaceMarkerClicked = false;
  bool isTimeAndDistanceVisible = false;



  // ************************ Current Location Functions *******************
  //

  Future<void> getCurrentPosition() async {
    currentPosition = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _mapCompleterController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
  }


  //************************ Serched Place Functions ***********************
  //

  void getSearchedPlacePredictions(String query) {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context).fetchpredictedPlaces(query, sessionToken);
  }

  Widget buildPredictionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded) {
          places = (state).places;
          if (places.isNotEmpty) {
            return buildPlacesList();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPlacesList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            searchedPlace = places[index];
            floatingSearchBarController.close();
            getSelectedPlaceLocation();
            polylinePoints.clear();
            removeAllMarkersAndUpdateUI();
          },
          child: PlaceItem(
            placePrediction: places[index],
          ),
        );
      },
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  void removeAllMarkersAndUpdateUI() {
    setState(() {
      markers.clear();
    });
  }

  getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context).fetchPlaceLocation(searchedPlace.placeId, sessionToken);
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          searchedPlaceLocation = (state).placeLocation;
          _goToSearchedPlaceLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getTheNewCameraPosition() {
    searchedPlaceCameraPosition = CameraPosition(
      target: LatLng(searchedPlaceLocation.lat, searchedPlaceLocation.lng),
      bearing: 0.0,
      tilt: 0.0,
      zoom: 12,
    );
  }

  Future<void> _goToSearchedPlaceLocation() async {
    getTheNewCameraPosition();
    final GoogleMapController mapController = await _mapCompleterController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(searchedPlaceCameraPosition));
    buildSearchedPlaceMarker();
  }

  buildSearchedPlaceMarker() {
    searchedPlaceLocationMarker = Marker(
      position: searchedPlaceCameraPosition.target,
      markerId: MarkerId('1'),
      onTap: () {
        buildCurrentLocationMarker();
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
      infoWindow: InfoWindow(title: searchedPlace.description),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUI(searchedPlaceLocationMarker);
  }

  buildCurrentLocationMarker() {
    currentPlaceLocationMarker = Marker(
      markerId: MarkerId('2'),
      position: _currentCameraPosition.target,
      infoWindow: InfoWindow(title: "Your current Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    addMarkerToMarkersAndUpdateUI(currentPlaceLocationMarker);
  }

  addMarkerToMarkersAndUpdateUI(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }






  // ********** Directions functions *************
  //

  buildDiretionsBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceDirectionsLoaded) {
          placeDirections = (state).placeDirections;
          getPolylinePoints();
        }
      },
      child: Container(),
    );
  }

  getPolylinePoints() {
    polylinePoints = placeDirections!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  getDirections() {
    BlocProvider.of<MapsCubit>(context).fetchDirections(
      LatLng(currentPosition!.latitude, currentPosition!.longitude),
      LatLng(searchedPlaceLocation.lat, searchedPlaceLocation.lng),
    );
  }





  // ******************** UI **********************
  //

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: floatingSearchBarController,
      elevation: 6,
      hintStyle: TextStyle(fontSize: 18),
      queryStyle: TextStyle(fontSize: 18),
      hint: 'Find a place...',
      border: BorderSide(style: BorderStyle.none),
      margins: EdgeInsets.fromLTRB(20, 50, 20, 0),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      backgroundColor: Colors.white,
      iconColor: AppColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      progress: progressIndicator,
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)), onPressed: () {}),
        ),
      ],
      onQueryChanged: (query) {
        getSearchedPlacePredictions(query);
      },
      onFocusChanged: (_) {
        setState(() {
          isTimeAndDistanceVisible = false;
        });
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPredictionsBloc(),
              buildSelectedPlaceLocationBloc(),
              buildDiretionsBloc(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      padding: EdgeInsets.only(top: 160, left: 325),
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: _currentCameraPosition,
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _mapCompleterController.complete(controller);
      },
      polylines: placeDirections != null
          ? {
              Polyline(polylineId: const PolylineId('polyline1'), color: Colors.black, width: 8, points: polylinePoints),
            }
          : {},
    );
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentPosition != null
              ? _buildMap()
              : Center(
                  child: CircularProgressIndicator(),
                ),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked
              ? DistanceAndTime(
                  isTimeAndDistanceVisible: isTimeAndDistanceVisible,
                  placeDirections: placeDirections,
                )
              : Container(),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        backgroundColor: AppColors.blue,
        child: Icon(Icons.place, color: Colors.white),
      ),
    );
  }
}
