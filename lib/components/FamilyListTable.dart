import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/table.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/models/family.dart';

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
        familyCubit.setFamily(selectedFamily);
        Navigator.pushNamed(
          context,
          AppRoute.familyDetiles,
          arguments: familyCubit,
        );
      },
      onRowLongPress: (index, rowObject) async {
        final selectedFamily = families[index];
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'خيارات الأسرة',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
                    Navigator.pop(context);
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
      },
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                familyCubit.deleteFamily(family.id);
                Navigator.of(context).pop();
                BlocProvider.of<BlockCubit>(
                  context,
                ).getBlockDetailes(family.blockId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف الأسرة بنجاح'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
