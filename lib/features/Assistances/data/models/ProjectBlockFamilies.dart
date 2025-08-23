import 'package:smart_negborhood_app/features/families/data/models/family.dart';

class ProjectBlockFamilies {
  late int blockId;
  late String blockName;
  late List<Family> families;

  ProjectBlockFamilies({
    required this.blockId,
    required this.blockName,
    required this.families,
  });

  factory ProjectBlockFamilies.fromJson(Map<String, dynamic> json) {
    return ProjectBlockFamilies(
      blockId: json["blockId"] as int,
      blockName: json["blockName"] as String,
      families: (json["families"] as List<dynamic>)
          .map((e) => Family.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
