import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/common/widgets/table.dart';
import 'package:smart_negborhood_app/models/assistance.dart';

class FamilyAssistancesListTable extends StatelessWidget {
  final List<Assistance> familyAssisytances;

  const FamilyAssistancesListTable({
    super.key,
    required this.familyAssisytances,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTableWidget(
      columnTitles: const ['تاريخ الأستلام', 'نوع المساعدة', 'رقم'],
      columnFlexes: const [2, 3, 1],
      rowData: familyAssisytances.asMap().entries.map((entry) {
        int index = entry.key;
        var familyAssisytance = entry.value;
        return [
          familyAssisytance.deliverDate,
          familyAssisytance.name,
          '${index + 1}',
        ];
      }).toList(),
    );
  }
}
