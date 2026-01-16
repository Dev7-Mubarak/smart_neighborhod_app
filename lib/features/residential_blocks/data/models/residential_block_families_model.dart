import 'package:smart_negborhood_app/features/residential_blocks/data/models/family_model.dart';

class ResidentialBlockFamiliesModel {
  late int id;
  late String name;
  late String blockManagerId;
  late String blockManagerName;
  late List<FamilyModel> families;

  ResidentialBlockFamiliesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    blockManagerId = json['blockManagerId'] ?? '';
    blockManagerName = json['blockManagerName'] ?? '';
    if (json['families'] != null) {
      families = (json['families'] as List<dynamic>)
          .map((e) => FamilyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      families = [];
    }
  }
}
