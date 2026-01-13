import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_cubit.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_state.dart';
import 'package:smart_negborhood_app/features/residential_units/data/models/unit_block_model.dart';

class ResidentialUnitBlocksView extends StatefulWidget {
  const ResidentialUnitBlocksView({super.key});

  @override
  State<ResidentialUnitBlocksView> createState() =>
      _ResidentialUnitBlocksViewState();
}

class _ResidentialUnitBlocksViewState extends State<ResidentialUnitBlocksView> {
  late ResidentialUnitsCubit _unitsCubit;
  late TextEditingController _searchingController;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _unitsCubit = context.read<ResidentialUnitsCubit>();
    _searchingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;

    return BlocBuilder<ResidentialUnitsCubit, ResidentialUnitsState>(
      buildWhen: (previous, current) =>
          current is ResidentialUnitBlocksLoaded ||
          current is ResidentialUnitBlocksLoading ||
          current is ResidentialUnitBlocksFailure,
      builder: (context, state) {
        String title = locale.Blocks;

        if (state is ResidentialUnitBlocksLoaded) {
          title = state.unitWithBlocks.name;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SearchableTextFormField(
                    controller: _searchingController,
                    hintText: locale.searchResidentialBlock,
                    bachgroundColor: AppColor.gray2,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchingController.clear();
                        _unitsCubit.filterResidentialUnitBlocks('');
                      },
                      icon: const Icon(Icons.close),
                    ),
                    prefixIcon: Icons.search,
                    onChanged: (String query) {
                      _delay?.cancel();
                      _delay = Timer(const Duration(milliseconds: 300), () {
                        _unitsCubit.filterResidentialUnitBlocks(query.trim());
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  Expanded(child: _buildBody(state, crossAxisCount, locale)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ResidentialUnitsState state, int crossAxisCount, locale) {
    if (state is ResidentialUnitBlocksLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ResidentialUnitBlocksFailure) {
      return OnFailureWidget(onRetry: () {});
    }

    if (state is ResidentialUnitBlocksLoaded) {
      if (state.allBlocks.isEmpty) {
        return Center(child: NoResultWidget());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: state.allBlocks.map((block) {
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: _buildBlockCard(block, locale),
            );
          }).toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBlockCard(UnitBlock block, locale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: AppColor.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.home_work_rounded,
                size: 40,
                color: AppColor.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    block.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          block.blockManagerName,
                          textAlign: TextAlign.center,
                          // maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
