import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/common/widgets/table.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/data/models/family.dart';
import 'package:smart_negborhood_app/features/residential_blocks/cubits/BlockDetailCubit/block_detail_cubit.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/family_model.dart';

class FamilyListTable extends StatelessWidget {
  final List<Family> families;
  final FamilyCubit familyCubit;
  final BlockDetailCubit blockDetailCubit;
  final ProfileModel profileModel;

  const FamilyListTable({
    super.key,
    required this.families,
    required this.familyCubit,
    required this.blockDetailCubit,
    required this.profileModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTableWidget(
      columnTitles: const ["رقم", "إسم العائلة", "التصنيف", "الموقع"],
      columnFlexes: const [1, 3, 2, 3],
      rowData: families.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [
          '${index + 1}',
          family.name,
          family.familyCategoryName,
          family.location,
        ];
      }).toList(),
      originalObjects: families,

      onRowTap: (index) {
        final selectedFamily = families[index];
        familyCubit.setFamily(selectedFamily);
        Navigator.pushNamed(
          context,
          AppRoute.familyDetiles,
          arguments: familyCubit,
        );
      },
    );
  }
}
