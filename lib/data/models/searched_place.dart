class SearchedPlace {
  late String placeId;
  late String description;

  SearchedPlace.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"];
    description = json["description"];
  }
}
