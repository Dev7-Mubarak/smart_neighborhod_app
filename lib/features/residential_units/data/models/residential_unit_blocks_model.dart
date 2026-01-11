import 'package:smart_negborhood_app/features/residential_units/data/models/unit_block_model.dart';

class ResidentialUnitBlocksModel {
  late int id;
  late String name;
  late String unitManagerId;
  late String unitManagerName;
  late List<UnitBlock> blocks;

  ResidentialUnitBlocksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    unitManagerId = json['unitManagerId'] ?? '';
    unitManagerName = json['unitManagerName'] ?? '';
    if (json['blocks'] != null) {
      blocks = (json['blocks'] as List<dynamic>)
          .map((e) => UnitBlock.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      blocks = [];
    }
  }
}
