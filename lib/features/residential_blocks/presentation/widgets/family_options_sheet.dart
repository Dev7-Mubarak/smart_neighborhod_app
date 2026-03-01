import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/data/models/family.dart';

import '../../cubits/residential_blocks_cubit/residential_blocks_cubit.dart';

class FamilyOptionsSheet extends StatelessWidget {
  final Family family;
  final FamilyCubit cubit;
  final ResidentialBlocksCubit residentialBlocksCubit;

  const FamilyOptionsSheet({
    super.key,
    required this.family,
    required this.cubit,
    required this.residentialBlocksCubit,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale.FamilyOptions,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: Text(locale.edit),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              cubit.setFamilyForUpdate(family);
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateFamily,
                arguments: {
                  'familyCubit': cubit,
                  'blockId': cubit.family?.blockId,
                },
              ).then((_) {
                Navigator.pop(context);
                residentialBlocksCubit.getBlockFamilies(cubit.family!.blockId);
              });
            },
          ),
          const SizedBox(height: 8),

          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: Text(locale.delete),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              final confirmed = await context.showAlertDialog();
              if (confirmed == true) {
                Navigator.pop(context);
                cubit.deleteFamily(family.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
