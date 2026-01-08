import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_model.dart';

class ResidentialNeighborhoodDashboardModel {
  late int totalNeighborhoods;
  late int totalUnits;
  late int totalBlocks;
  late List<ResidentialNeighborhoodModel> neighborhoods;

  ResidentialNeighborhoodDashboardModel.fromJson(Map<String, dynamic> json) {
    totalNeighborhoods = json["totalNeighborhoods"] ?? 0;
    totalUnits = json["totalUnits"] ?? 0;
    totalBlocks = json["totalBlocks"] ?? 0;
    if (json['neighborhoods'] != null) {
      neighborhoods = (json["neighborhoods"] as List<dynamic>)
          .map(
            (e) => ResidentialNeighborhoodModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      neighborhoods = [];
    }
  }
}
