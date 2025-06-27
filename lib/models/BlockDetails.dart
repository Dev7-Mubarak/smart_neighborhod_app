import 'package:smart_negborhood_app/models/family.dart';

class BlockDetails {
  final int id;
  final String name;
  final String managerName;
  final int familyCount;
  final int orphansCount;
  final int widowsCount;
  final List<Family> families;

  BlockDetails({
    required this.id,
    required this.name,
    required this.managerName,
    required this.familyCount,
    required this.orphansCount,
    required this.widowsCount,
    required this.families,
  });

  factory BlockDetails.fromJson(Map<String, dynamic> json) {
    return BlockDetails(
      id: json['block']['id'],
      name: json['block']['name'],
      managerName: json['block']['managerName'],
      familyCount: json['block']['totalFamilies'],
      orphansCount: json['block']['totalOrphans'],
      widowsCount: json['block']['totalWidows'],
      families: (json['families'] as List)
          .map((e) => Family.fromJson(e))
          .toList(),
    );
  }
}
