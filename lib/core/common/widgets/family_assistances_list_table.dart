import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/common/widgets/table.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/assistance.dart';

class FamilyAssistancesListTable extends StatelessWidget {
  final List<Assistance> familyAssisytances;

  const FamilyAssistancesListTable({
    super.key,
    required this.familyAssisytances,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTableWidget(
      columnTitles: const ['رقم', 'نوع المساعدة', 'تاريخ الأستلام'],
      columnFlexes: const [1, 2, 3],
      rowData: familyAssisytances.asMap().entries.map((entry) {
        int index = entry.key;
        var familyAssisytance = entry.value;
        return [
          '${index + 1}',
          familyAssisytance.name,
          familyAssisytance.deliverDate,
        ];
      }).toList(),
    );
  }
}
