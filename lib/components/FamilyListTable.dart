import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/table.dart';
import 'package:smart_negborhood_app/models/family.dart';

class FamilyListTable extends StatelessWidget {
  final List<Family> families;

  const FamilyListTable({super.key, required this.families});

  @override
  Widget build(BuildContext context) {
    return CustomTableWidget(
      columnTitles: const ['رقم التواصل', 'التصنيف', 'رب الأسرة', 'رقم'],
      columnFlexes: const [4, 2, 3, 1],
      rowData: families.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [
          family.familyHeadPhoneNumber,
          family.familyTypeName,
          family.familyHeadName,
          '${index + 1}',
        ];
      }).toList(),
    );
  }
}
