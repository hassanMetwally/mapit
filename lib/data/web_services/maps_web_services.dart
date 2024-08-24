import 'package:dio/dio.dart';
import 'package:mapit/constants/constants.dart';

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
      throw Future.error("Place prediction error : ", StackTrace.fromString(('this is its trace')));
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
      throw Future.error("Place Location error : ", StackTrace.fromString(('this is its trace')));
    }
  }
}
