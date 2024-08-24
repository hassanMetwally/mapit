import 'package:mapit/data/models/place_location.dart';
import 'package:mapit/data/models/searched_place.dart';
import 'package:mapit/data/web_services/maps_web_services.dart';

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
}
