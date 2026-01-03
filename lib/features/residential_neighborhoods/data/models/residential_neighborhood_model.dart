class ResidentialNeighborhoodModel {
  late int id;
  late String name;
  late String neighborhoodManagerId;
  late String neighborhoodManagerName;

  ResidentialNeighborhoodModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    neighborhoodManagerId = json["neighborhoodManagerId"];
    neighborhoodManagerName = json["neighborhoodManagerName"];
  }
}
