import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/change_neighborhood_name_widget.dart';
// import cubits, models, colors...

class NeighborhoodOptionsSheet extends StatelessWidget {
  final ResidentialNeighborhoodModel neighborhood;
  final ResidentialNeighborhoodsCubit cubit;

  const NeighborhoodOptionsSheet({
    super.key,
    required this.neighborhood,
    required this.cubit,
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
            locale.residentialNeighborhoodOptions,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: Text(locale.ChangeNeighborhoodName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.setResidentialNeighborhood(neighborhood);
              context.showBottomSheet(
                BlocProvider.value(
                  value: cubit,
                  child: ChangeNeighborhoodNameWidget(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: Text(locale.ChangeNeighborhoodManagerName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoute.changeBlockManager,
                arguments: context.read<ResidentialNeighborhoodsCubit>()
                  ..setResidentialNeighborhood(neighborhood),
              );
            },
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: Text(locale.delete),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColor.white,
            ),
            onPressed: () => _confirmDelete(context, locale),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, locale) async {
    Navigator.pop(context);
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.confirmDelete),
        content: Text(locale.deleteNotAllowed),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(locale.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              cubit.deleteResidentialNeighborhood(neighborhood.neighborhoodId);
            },
            child: Text(
              locale.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
