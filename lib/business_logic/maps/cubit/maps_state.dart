part of 'maps_cubit.dart';

abstract class MapsState {}

final class MapsInitial extends MapsState {}

final class PlacesLoaded extends MapsState {
  final List<SearchedPlace> places;
  PlacesLoaded({required this.places});
}

final class PlaceLocationLoaded extends MapsState{
  final PlaceLocation placeLocation;
  PlaceLocationLoaded({required this.placeLocation});
}
