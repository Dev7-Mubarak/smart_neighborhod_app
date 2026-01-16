import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_negborhood_app/core/common/enums/app_role.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/services/API/dio_consumer.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import 'package:smart_negborhood_app/features/residential_blocks/cubits/residential_blocks_cubit/residential_blocks_cubit.dart';
import 'package:smart_negborhood_app/features/residential_blocks/cubits/residential_blocks_cubit/residential_blocks_state.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/family_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_cubit.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_state.dart';
import 'package:smart_negborhood_app/features/residential_units/data/models/residential_unit_model.dart';
import 'package:smart_negborhood_app/features/residential_units/presentation/widgets/unit_options_sheet.dart';

class ResidentialBlockFamiliesView extends StatefulWidget {
  const ResidentialBlockFamiliesView({super.key});

  @override
  State<ResidentialBlockFamiliesView> createState() =>
      _ResidentialBlockFamiliesViewState();
}

class _ResidentialBlockFamiliesViewState
    extends State<ResidentialBlockFamiliesView> {
  late ResidentialBlocksCubit _residentialBlocksCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  @override
  void initState() {
    super.initState();
    _residentialBlocksCubit = context.read<ResidentialBlocksCubit>();
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
    return BlocBuilder<ResidentialBlocksCubit, ResidentialBlocksState>(
      buildWhen: (previous, current) =>
          current is ResidentialBlockFamiliesLoaded ||
          current is ResidentialBlockFamiliesLoading ||
          current is FailureForUpdateOrAddResidentialBlock,
      builder: (context, state) {
        String title = locale.Families;

        if (state is ResidentialBlockFamiliesLoaded) {
          title = state.blockWithFamilies.name;
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
                    hintText: locale.lookingFamily,
                    bachgroundColor: AppColor.gray2,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchingController.clear();
                        _residentialBlocksCubit.filterBlockfamilies('');
                      },
                      icon: const Icon(Icons.close),
                    ),
                    prefixIcon: Icons.search,
                    onChanged: (String query) {
                      _delay?.cancel();
                      _delay = Timer(const Duration(milliseconds: 300), () {
                        _residentialBlocksCubit.filterBlockfamilies(
                          query.trim(),
                        );
                      });
                    },
                  ),

                  SizedBox(height: 5),
                  Expanded(child: _buildBody(state, crossAxisCount, locale)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ResidentialBlocksState state, int crossAxisCount, locale) {
    if (state is ResidentialBlockFamiliesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FailureForUpdateOrAddResidentialBlock) {
      return OnFailureWidget(onRetry: () {});
    }

    if (state is ResidentialBlockFamiliesLoaded) {
      if (state.allBlockFamilies.isEmpty) {
        return Center(child: NoResultWidget());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: state.allBlockFamilies.map((family) {
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: _buildFamilyCard(family, locale),
            );
          }).toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFamilyCard(FamilyModel family, locale) {
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
                Icons.family_restroom,
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
                    family.name,
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
                      const Icon(Icons.group, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          family.familyCategoryName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          family.location,
                          textAlign: TextAlign.center,
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
