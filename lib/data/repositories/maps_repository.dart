import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place_directions.dart';
import '../models/place_location.dart';
import '../models/searched_place.dart';
import '../web_services/maps_web_services.dart';

class MapsRepository {
  MapsWebServices mapsWebServices;
  MapsRepository({required this.mapsWebServices});
  Future<List<SearchedPlace>> fetchSearchedPlaces(String placeName, String sessionToken) async {
    final predictions = await mapsWebServices.fetchSearchedPlaces(placeName, sessionToken);
    return predictions.map((prediction) => SearchedPlace.fromJson(prediction)).toList();
  }

  Future<PlaceLocation> fetchPlaceLocation(String placeId, String sessionToken) async {
    final placeLocation = await mapsWebServices.fetchPlaceLocation(placeId, sessionToken);
    return PlaceLocation.fromJson(placeLocation);
  }

  Future<PlaceDirections> fetchDirections(LatLng origin, LatLng destination) async {
    final placeDirections = await mapsWebServices.fetchDirections(origin, destination);
    return PlaceDirections.fromJson(placeDirections);
  }
}
