import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_units/data/models/residential_unit_model.dart';
import '../../cubits/residential_units_cubit/residential_units_cubit.dart';
import 'change_unit_name_widget.dart';

class UnitOptionsSheet extends StatelessWidget {
  final ResidentialUnitModel unit;
  final ResidentialUnitsCubit cubit;
  const UnitOptionsSheet({super.key, required this.unit, required this.cubit});
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
            locale.residentialUnitsOptions,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: Text(locale.ChangeUnitName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.setSelectedUnit(unit);
              context.showBottomSheet(
                BlocProvider.value(
                  value: cubit,
                  child: const ChangeUnitNameWidget(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: Text(locale.ChangeUnitManagerName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.setSelectedUnit(unit);
              Navigator.pushNamed(
                context,
                AppRoute.changeResidentialUnitManager,
                arguments: cubit,
              );
            },
          ),
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
                cubit.deleteUnit(unit.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
