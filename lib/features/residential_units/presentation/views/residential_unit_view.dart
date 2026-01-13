import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_negborhood_app/core/config/generated/l10n.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_cubit.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_state.dart';
import 'package:smart_negborhood_app/features/residential_units/data/models/residential_unit_model.dart';
import 'package:smart_negborhood_app/features/residential_units/presentation/widgets/unit_options_sheet.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/common/widgets/stat_item_widget.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';

class ResidentialUnitView extends StatefulWidget {
  const ResidentialUnitView({super.key});

  @override
  State<ResidentialUnitView> createState() => _ResidentialUnitViewState();
}

class _ResidentialUnitViewState extends State<ResidentialUnitView> {
  late final ResidentialUnitsCubit _unitsCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  late final ProfileModel? _profileModel;

  @override
  void initState() {
    super.initState();
    _unitsCubit = context.read<ResidentialUnitsCubit>()
      ..getResidentialUnitsDashboard();
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
          Navigator.pop(context);
        } else if (state is ResidentialUnitUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is ResidentialUnitDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is ResidentialUnitsFailure ||
            state is FailureForUpdateOrAddResidentialUnit) {
          Navigator.of(context, rootNavigator: true).pop();
          final errorMsg = state is ResidentialUnitsFailure
              ? state.errorMessage
              : (state as FailureForUpdateOrAddResidentialUnit).errorMessage;
          context.showErrorSnackBar(errorMsg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Center(
            child: Text(
              locale.residentialUnits,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SmallButton(
                      text: locale.add,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.addResidentialUnit,
                          arguments: BlocProvider.of<ResidentialUnitsCubit>(
                            context,
                          ),
                        ).then((value) {
                          _unitsCubit.getResidentialUnitsDashboard();
                        });
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
                            _unitsCubit.filterUnits('');
                          },
                          icon: const Icon(Icons.close),
                        ),
                        prefixIcon: Icons.search,
                        onChanged: (String query) {
                          _delay?.cancel();
                          _delay = Timer(const Duration(milliseconds: 300), () {
                            _unitsCubit.filterUnits(query.trim());
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildContentBody(crossAxisCount, locale)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentBody(int crossAxisCount, locale) {
    return BlocBuilder<ResidentialUnitsCubit, ResidentialUnitsState>(
      buildWhen: (previous, current) =>
          current is ResidentialUnitsLoaded ||
          current is ResidentialUnitsLoading ||
          current is ResidentialUnitsFailure,
      builder: (context, state) {
        if (state is ResidentialUnitsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ResidentialUnitsFailure) {
          return OnFailureWidget(
            onRetry: () => _unitsCubit.getResidentialUnitsDashboard(),
          );
        } else if (state is ResidentialUnitsLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                // Dashboard stats (total units / total blocks)
                Row(
                  children: [
                    Expanded(
                      child: StatItemWidget(
                        title: locale.Units,
                        count: state.dashboardData.totalUnits,
                        icon: Icons.home,
                        color: const Color(0xFFEFA98D),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatItemWidget(
                        title: locale.Blocks,
                        count: state.dashboardData.totalBlocks,
                        icon: Icons.grid_view,
                        color: const Color(0xFFE8618C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (state.filteredUnits.isEmpty)
                  SizedBox(height: 200, child: Center(child: NoResultWidget()))
                else
                  StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: state.filteredUnits.map((unit) {
                      return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.residentialUnitBlocks,
                              arguments: BlocProvider.of<ResidentialUnitsCubit>(
                                context,
                              )..getResidentialUnitBlocks(unit.id),
                            );
                          },
                          onLongPress: () {
                            if (_profileModel?.role == AppRole.Admin.name) {
                              _showOptions(unit, locale);
                            }
                          },
                          child: Container(
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    color: AppColor.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    child: Icon(
                                      Icons.home_work_rounded,
                                      size: 40,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        Text(
                                          '${unit.blocksCount} ${locale.Blocks}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Replaced by shared StatItemWidget

  void _showOptions(ResidentialUnitModel unit, locale) {
    context.showBottomSheet(UnitOptionsSheet(unit: unit, cubit: _unitsCubit));
  }

  Widget _buildHeaderSection(BuildContext context, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_profileModel?.role == AppRole.Admin.name)
            SmallButton(
              text: locale.add,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoute.addResidentialUnit,
                  arguments: BlocProvider.of<ResidentialUnitsCubit>(context),
                );
              },
            ),
          if (_profileModel?.role == AppRole.Admin.name)
            const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: locale.lookingunit,
              bachgroundColor: AppColor.gray2,
              suffixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _unitsCubit.filterUnits('');
                },
                icon: const Icon(Icons.close),
              ),
              prefixIcon: Icons.search,
              onChanged: (String query) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 300), () {
                  _unitsCubit.filterUnits(query.trim());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
