class ResidentialNeighborhoodModel {
  late int neighborhoodId;
  late String neighborhoodName;
  late int unitsCount;
  late int blocksCount;
  late String managerId;
  late String managerName;

  ResidentialNeighborhoodModel.fromJson(Map<String, dynamic> json) {
    neighborhoodId = json["neighborhoodId"];
    neighborhoodName = json["neighborhoodName"] ?? "";
    unitsCount = json["unitsCount"] ?? 0;
    blocksCount = json["blocksCount"] ?? 0;
    managerId = json["managerId"] ?? "";
    managerName = json["managerName"] ?? "غير معين";
  }
}
