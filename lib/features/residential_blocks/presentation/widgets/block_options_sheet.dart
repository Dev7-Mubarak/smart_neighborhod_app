import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';

import '../../data/models/residential_block_model.dart';
import '../../cubits/residential_blocks_cubit/residential_blocks_cubit.dart';
import 'change_block_name_widget.dart';

class BlockOptionsSheet extends StatelessWidget {
  final ResidentialBlockModel block;
  final ResidentialBlocksCubit cubit;
  const BlockOptionsSheet({
    super.key,
    required this.block,
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
            locale.residentialBlocksOptions,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: Text(locale.changeBlockName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.setSelectedBlock(block);
              context.showBottomSheet(
                BlocProvider.value(
                  value: cubit,
                  child: const ChangeBlockNameWidget(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: Text(locale.changeBlockManager),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.setSelectedBlock(block);

              Navigator.pushNamed(
                context,
                AppRoute.changeResidentialBlockManager,
                arguments: cubit,
              );
            },
          ),
          const SizedBox(height: 8),
          // Delete option removed
        ],
      ),
    );
  }
}
