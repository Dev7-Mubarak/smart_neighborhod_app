import 'package:smart_negborhood_app/features/residential_units/data/models/residential_unit_model.dart';

class ResidentialNeighborhoodUnitModel {
  late int id;
  late String name;
  late String neighborhoodManagerId;
  late String neighborhoodManagerName;
  late List<ResidentialUnitModel> residentialUnits;

  ResidentialNeighborhoodUnitModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"] ?? "";
    neighborhoodManagerId = json["neighborhoodManagerId"] ?? 0;
    neighborhoodManagerName = json["neighborhoodManagerName"] ?? 0;
    if (json['residentialUnits'] != null) {
      residentialUnits = (json["residentialUnits"] as List<dynamic>)
          .map((e) => ResidentialUnitModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      residentialUnits = [];
    }
  }
}
