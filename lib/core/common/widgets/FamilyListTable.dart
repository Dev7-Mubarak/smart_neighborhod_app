import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/table.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/cubits/block_cubit/block_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/data/models/family.dart';

class FamilyListTable extends StatelessWidget {
  final List<Family> families;
  final FamilyCubit familyCubit;

  const FamilyListTable({
    super.key,
    required this.families,
    required this.familyCubit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTableWidget(
      columnTitles: const ['رقم', 'رب الأسرة', 'التصنيف', 'رقم التواصل'],
      columnFlexes: const [1, 3, 2, 2],
      rowData: families.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [
          '${index + 1}',
          family.familyHeadName,
          family.familyCategoryName,
          family.familyHeadPhoneNumber,
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
      onRowLongPress: (index, rowObject) {
        final selectedFamily = families[index];
        _showOptionsBottomSheet(context, selectedFamily, familyCubit);
      },
    );
  }

  void _showOptionsBottomSheet(
    BuildContext context,
    Family selectedFamily,
    FamilyCubit familyCubit,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'خيارات الأسرة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('تعديل الأسرة'),
              onPressed: () {
                Navigator.pop(context);
                familyCubit.setFamily(selectedFamily);
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdateFamily,
                  arguments: familyCubit,
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('حذف الأسرة'),
              onPressed: () {
                _showDeleteConfirmationDialog(
                  context,
                  selectedFamily,
                  familyCubit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    Family family,
    FamilyCubit familyCubit,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذه الأسرة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                await familyCubit.deleteFamily(family.id);
                BlocProvider.of<BlockCubit>(
                  context,
                ).getBlockDetailes(family.blockId);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close sheet
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
