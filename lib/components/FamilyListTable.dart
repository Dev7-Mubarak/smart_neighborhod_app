import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/table.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/models/assistance.dart';
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

      onRowTap: (index) {
        final selectedFamily = families[index];
        FamilyCubit familyCubit = context.read<FamilyCubit>();
        familyCubit.setFamilyId(selectedFamily.id);
        Navigator.pushNamed(
          context,
          AppRoute.familyDetiles,
          arguments: familyCubit,
        );
      },
    );
  }
}

class FamilyAssistancesListTable extends StatelessWidget {
  final List<Assistance> familyAssisytances;

  const FamilyAssistancesListTable({
    super.key,
    required this.familyAssisytances,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTableWidget(
      columnTitles: const ['ملاحظات', 'تاريخ الأستلام', 'نوع المساعدة', 'رقم'],
      columnFlexes: const [4, 2, 3, 1],
      rowData: familyAssisytances.asMap().entries.map((entry) {
        int index = entry.key;
        var familyAssisytance = entry.value;
        return [
          familyAssisytance.notes ?? 'لا يوجد ملاحظات',
          familyAssisytance.deliverDate ?? 'لا يوجد تاريخ تسليم',
          familyAssisytance.name,
          '${index + 1}',
        ];
      }).toList(),

      onRowTap: (index) {
        final selectedFamily = familyAssisytances[index];
        FamilyCubit familyCubit = context.read<FamilyCubit>();
        familyCubit.setFamilyId(selectedFamily.id);
        Navigator.pushNamed(
          context,
          AppRoute.familyDetiles,
          arguments: context.read<FamilyCubit>(),
        );
      },
    );
  }
}
