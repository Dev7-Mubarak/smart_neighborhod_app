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
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_cubit.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_state.dart';
import 'package:smart_negborhood_app/features/residential_units/data/models/residential_unit_model.dart';
import 'package:smart_negborhood_app/features/residential_units/presentation/widgets/unit_options_sheet.dart';

class ResidentialNeighborhoodUnits extends StatefulWidget {
  const ResidentialNeighborhoodUnits({super.key});

  @override
  State<ResidentialNeighborhoodUnits> createState() =>
      _ResidentialNeighborhoodUnitsState();
}

class _ResidentialNeighborhoodUnitsState
    extends State<ResidentialNeighborhoodUnits> {
  late ResidentialNeighborhoodsCubit _residentialNeighborhoodsCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  late final ProfileModel? _profileModel;
  late ResidentialUnitsCubit _residentialUnitsCubit;
  @override
  void initState() {
    super.initState();
    _residentialNeighborhoodsCubit = context
        .read<ResidentialNeighborhoodsCubit>();
    _residentialUnitsCubit = BlocProvider.of<ResidentialUnitsCubit>(context);
    _searchingController = TextEditingController();
    _profileModel = SharedPreferencesService.getProfile();
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
    return BlocListener<ResidentialUnitsCubit, ResidentialUnitsState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddResidentialUnit) {
          context.showLoadingDialog();
        } else if (state is ResidentialUnitAddedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          // refresh neighborhood units list after add
          var neighId = _residentialUnitsCubit.selectedNeighborhoodId;
          if (neighId == null &&
              _residentialNeighborhoodsCubit.state
                  is ResidentialNeighborhoodUnitssLoaded) {
            neighId =
                (_residentialNeighborhoodsCubit.state
                        as ResidentialNeighborhoodUnitssLoaded)
                    .neighborhoodWithUnits
                    .id;
          }
          if (neighId != null) {
            _residentialNeighborhoodsCubit.getResidentialNeighborhoodUnits(
              neighId,
            );
          }
          Navigator.pop(context);
        } else if (state is ResidentialUnitDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          var neighId = _residentialUnitsCubit.selectedNeighborhoodId;
          if (neighId == null &&
              _residentialNeighborhoodsCubit.state
                  is ResidentialNeighborhoodUnitssLoaded) {
            neighId =
                (_residentialNeighborhoodsCubit.state
                        as ResidentialNeighborhoodUnitssLoaded)
                    .neighborhoodWithUnits
                    .id;
          }
          if (neighId != null) {
            _residentialNeighborhoodsCubit.getResidentialNeighborhoodUnits(
              neighId,
            );
          }
        } else if (state is ResidentialUnitUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          var neighId = _residentialUnitsCubit.selectedNeighborhoodId;
          if (neighId == null &&
              _residentialNeighborhoodsCubit.state
                  is ResidentialNeighborhoodUnitssLoaded) {
            neighId =
                (_residentialNeighborhoodsCubit.state
                        as ResidentialNeighborhoodUnitssLoaded)
                    .neighborhoodWithUnits
                    .id;
          }
          if (neighId != null) {
            _residentialNeighborhoodsCubit.getResidentialNeighborhoodUnits(
              neighId,
            );
          }
          Navigator.pop(context);
        } else if (state is FailureForUpdateOrAddResidentialUnit) {
          Navigator.of(context, rootNavigator: true).pop();
          final errorMsg = state.errorMessage;

          context.showErrorSnackBar(errorMsg);
        }
      },
      child:
          BlocBuilder<
            ResidentialNeighborhoodsCubit,
            ResidentialNeighborhoodsState
          >(
            buildWhen: (previous, current) =>
                current is ResidentialNeighborhoodUnitssLoaded ||
                current is ResidentialNeighborhoodUnitsLoading ||
                current is FailureForUpdateOrAddResidentialNeighborhood,
            builder: (context, state) {
              String title = locale.residentialUnits;

              if (state is ResidentialNeighborhoodUnitssLoaded) {
                title =
                    "${locale.unitsInNeighborhood}(${state.neighborhoodWithUnits.name}) ";
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SmallButton(
                              text: locale.add,
                              onPressed: () {
                                int? neighborhoodId;
                                if (state
                                    is ResidentialNeighborhoodUnitssLoaded) {
                                  neighborhoodId =
                                      state.neighborhoodWithUnits.id;
                                }
                                _residentialUnitsCubit
                                    .changeSelectedNeighborhoodId(
                                      neighborhoodId,
                                    );
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.addResidentialUnit,
                                  arguments: _residentialUnitsCubit,
                                );
                              },
                            ),
                            const SizedBox(
                              width: AppSize.spasingBetweenInputsAndLabale,
                            ),
                            Expanded(
                              child: SearchableTextFormField(
                                controller: _searchingController,
                                hintText: locale.lookingunit,
                                bachgroundColor: AppColor.gray2,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _searchingController.clear();
                                    _residentialNeighborhoodsCubit
                                        .filterNeighborhoodUnits('');
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                                prefixIcon: Icons.search,
                                onChanged: (String query) {
                                  _delay?.cancel();
                                  _delay = Timer(
                                    const Duration(milliseconds: 300),
                                    () {
                                      _residentialNeighborhoodsCubit
                                          .filterNeighborhoodUnits(
                                            query.trim(),
                                          );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: _buildBody(state, crossAxisCount, locale),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildBody(
    ResidentialNeighborhoodsState state,
    int crossAxisCount,
    locale,
  ) {
    if (state is ResidentialNeighborhoodUnitsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FailureForUpdateOrAddResidentialNeighborhood) {
      return OnFailureWidget(onRetry: () {});
    }

    if (state is ResidentialNeighborhoodUnitssLoaded) {
      if (state.allNeighborhoodUnits.isEmpty) {
        return Center(child: NoResultWidget());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: state.allNeighborhoodUnits.map((unit) {
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: GestureDetector(
                onLongPress: () {
                  if (_profileModel?.role == AppRoles.admin.name) {
                    _showOptions(unit, locale);
                  }
                },
                child: _buildUnitCard(unit, locale),
              ),
            );
          }).toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showOptions(ResidentialUnitModel unit, locale) {
    context.showBottomSheet(
      UnitOptionsSheet(unit: unit, cubit: _residentialUnitsCubit),
    );
  }

  Widget _buildUnitCard(ResidentialUnitModel unit, locale) {
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
                    unit.name,
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
                          unit.unitManagerName,
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
