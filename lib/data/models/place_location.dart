class PlaceLocation {
  late double lat;
  late double lng;

  PlaceLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}
