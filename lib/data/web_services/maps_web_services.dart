import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/constants.dart';

class MapsWebServices {
  late Dio dio;
  MapsWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSearchedPlaces(String placeName, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeSearchBaseUrl,
        queryParameters: {
          'input': placeName,
          'types': 'address',
          'components': 'country:eg',
          'key': googleAPIkey,
          'sessiontoken': sessionToken,
        },
      );
      return response.data['predictions'];
    } catch (error) {
      throw Future.error("GET Place prediction error : ", StackTrace.fromString(('this is its trace')));
    }
  }

  Future<Map<String, dynamic>> fetchPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeLocationBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'key': googleAPIkey,
          'sessiontoken': sessionToken,
        },
      );
      return response.data['result']['geometry']['location'];
    } catch (error) {
      throw Future.error("GET Place Location error : ", StackTrace.fromString(('this is its trace')));
    }
  }

  // origin = current location
  // destination = searched place location
  Future<Map<String, dynamic>> fetchDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(directionsBaseUrl, queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIkey,
      });
      return response.data['routes'][0];
    } catch (erroe) {
      throw Future.error("GET directions error : ", StackTrace.fromString(('this is its trace')));
    }
  }

}
