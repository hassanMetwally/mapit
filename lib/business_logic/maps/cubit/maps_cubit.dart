import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapit/data/models/place_location.dart';
import 'package:mapit/data/models/searched_place.dart';
import 'package:mapit/data/repositories/maps_repository.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsRepository mapsRepository;

  MapsCubit({required this.mapsRepository}) : super(MapsInitial());

  fetchpredictedPlaces(String placeName, String sessionToken) async {
    final places =
        await mapsRepository.fetchSearchedPlaces(placeName, sessionToken);
    emit(PlacesLoaded(places: places));
  }

  fetchPlaceLocation(String placeId, String sessionToken) async {
    final placeLocation =
        await mapsRepository.fetchPlaceLocation(placeId, sessionToken);
    emit(PlaceLocationLoaded(placeLocation: placeLocation));
  }
}
