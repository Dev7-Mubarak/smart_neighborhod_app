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
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/dashboard_stats_widget.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/neighborhood_card_widget.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/neighborhood_options_sheet.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
import '../../data/models/residential_neighborhood_model.dart';

class ResidentialNeighborhoodView extends StatefulWidget {
  const ResidentialNeighborhoodView({super.key});

  @override
  State<ResidentialNeighborhoodView> createState() =>
      _ResidentialNeighborhoodViewState();
}

class _ResidentialNeighborhoodViewState
    extends State<ResidentialNeighborhoodView> {
  late final ResidentialNeighborhoodsCubit _residentialNeighborhoodsCubit;
  late final ProfileModel? _profileModel;
  late TextEditingController _searchingController;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _residentialNeighborhoodsCubit =
        context.read<ResidentialNeighborhoodsCubit>()
          ..getResidentialNeighborhoodsDashboard();
    _searchingController = TextEditingController();
    _profileModel = SharedPreferencesService.getProfile();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  void _showOptions(
    ResidentialNeighborhoodModel neighborhood,
    AppLocalizations locale,
  ) {
    context.showBottomSheet(
      NeighborhoodOptionsSheet(
        neighborhood: neighborhood,
        cubit: _residentialNeighborhoodsCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;

    return BlocListener<
      ResidentialNeighborhoodsCubit,
      ResidentialNeighborhoodsState
    >(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddResidentialNeighborhood) {
          context.showLoadingDialog();
        } else if (state is ResidentialNeighborhoodAddedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is ResidentialNeighborhoodUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is ResidentialNeighborhoodDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is ResidentialNeighborhoodsFailure ||
            state is FailureForUpdateOrAddResidentialNeighborhood) {
          Navigator.of(context, rootNavigator: true).pop();
          final errorMsg = state is ResidentialNeighborhoodsFailure
              ? state.errorMessage
              : (state as FailureForUpdateOrAddResidentialNeighborhood)
                    .errorMessage;
          context.showErrorSnackBar(errorMsg);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header & Search Section
              _buildHeaderSection(context, locale),

              // 2. Main Content (Stats & Grid)
              Expanded(child: _buildContentBody(crossAxisCount, locale)),
            ],
          ),
        ),
      ),
    );
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
                  AppRoute.addResidentialNeighborhood,
                  arguments: BlocProvider.of<ResidentialNeighborhoodsCubit>(
                    context,
                  ),
                );
                // .then((_) {
                //   _residentialNeighborhoodsCubit
                //       .getResidentialNeighborhoodsDashboard(
                //         search: _searchingController.text.trim(),
                //       );
                // });
              },
            ),
          if (_profileModel?.role == AppRole.Admin.name)
            const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: locale.lookingNeighborhood,
              bachgroundColor: AppColor.gray2,
              suffixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _residentialNeighborhoodsCubit.filterNeighborhoods('');
                },
                icon: const Icon(Icons.close),
              ),
              prefixIcon: Icons.search,
              onChanged: (String query) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 300), () {
                  _residentialNeighborhoodsCubit.filterNeighborhoods(
                    query.trim(),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBody(int crossAxisCount, AppLocalizations locale) {
    return BlocBuilder<
      ResidentialNeighborhoodsCubit,
      ResidentialNeighborhoodsState
    >(
      buildWhen: (previous, current) =>
          current is ResidentialNeighborhoodsLoaded ||
          current is ResidentialNeighborhoodsLoading ||
          current is ResidentialNeighborhoodsFailure,
      builder: (context, state) {
        if (state is ResidentialNeighborhoodsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ResidentialNeighborhoodsFailure) {
          return OnFailureWidget(
            onRetry: () => _residentialNeighborhoodsCubit
                .getResidentialNeighborhoodsDashboard(),
          );
        } else if (state is ResidentialNeighborhoodsLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                DashboardStatsWidget(data: state.dashboardData),
                const SizedBox(height: 20),
                if (state.filteredNeighborhoods.isEmpty)
                  SizedBox(height: 200, child: Center(child: NoResultWidget()))
                else
                  StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: state.filteredNeighborhoods.map((neighborhood) {
                      return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: NeighborhoodCardWidget(
                          neighborhood: neighborhood,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.residentialNeighborhoodUnits,
                              arguments:
                                  BlocProvider.of<
                                      ResidentialNeighborhoodsCubit
                                    >(context)
                                    ..getResidentialNeighborhoodUnits(
                                      neighborhood.neighborhoodId,
                                    ),
                            );
                          },
                          onLongPress: () {
                            if (_profileModel?.role == AppRole.Admin.name) {
                              _showOptions(neighborhood, locale);
                            }
                          },
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
}
