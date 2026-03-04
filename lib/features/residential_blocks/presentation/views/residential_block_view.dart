import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/config/generated/l10n.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/stat_item_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/common/enums/app_role.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/features/residential_blocks/presentation/widgets/block_card_widget.dart';
import '../../presentation/widgets/block_options_sheet.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import '../../cubits/residential_blocks_cubit/residential_blocks_cubit.dart';
import '../../cubits/residential_blocks_cubit/residential_blocks_state.dart';

class ResidentialBlockView extends StatefulWidget {
  const ResidentialBlockView({super.key});

  @override
  State<ResidentialBlockView> createState() => _ResidentialBlockViewState();
}

class _ResidentialBlockViewState extends State<ResidentialBlockView> {
  late ResidentialBlocksCubit _blocksCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  late final ProfileModel? _profileModel;

  void reset() {
    if (_profileModel?.role!.toLowerCase() ==
        AppRoles.blockManager.name.toLowerCase()) {
      _blocksCubit.getResidentialBlocksMeDashboard();
    } else {
      _blocksCubit.getResidentialBlocksDashboard();
    }
  }

  @override
  void initState() {
    super.initState();
    _profileModel = SharedPreferencesService.getProfile();
    _blocksCubit = context.read<ResidentialBlocksCubit>();
    reset();
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

    return BlocListener<ResidentialBlocksCubit, ResidentialBlocksState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddResidentialBlock) {
          context.showLoadingDialog();
        } else if (state is ResidentialBlockAddedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is ResidentialBlockUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is ResidentialBlockDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is ResidentialBlocksFailure) {
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is FailureForUpdateOrAddResidentialBlock) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(locale.residentialBlocks),
        ),
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
          if (_profileModel?.role!.toLowerCase() ==
                  AppRoles.admin.name.toLowerCase() ||
              _profileModel?.role!.toLowerCase() ==
                  AppRoles.unitManager.name.toLowerCase() ||
              _profileModel?.role!.toLowerCase() ==
                  AppRoles.residentialNeighborhoodManager.name.toLowerCase())
            SmallButton(
              text: locale.add,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoute.addResidentialBlock,
                  arguments: BlocProvider.of<ResidentialBlocksCubit>(context),
                );
              },
            ),
          if (_profileModel?.role!.toLowerCase() ==
                  AppRoles.admin.name.toLowerCase() ||
              _profileModel?.role!.toLowerCase() ==
                  AppRoles.unitManager.name.toLowerCase() ||
              _profileModel?.role!.toLowerCase() ==
                  AppRoles.residentialNeighborhoodManager.name.toLowerCase())
            const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: locale.searchResidentialBlock,
              bachgroundColor: AppColor.gray2,
              suffixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _blocksCubit.filterBlocks('');
                },
                icon: const Icon(Icons.close),
              ),
              prefixIcon: Icons.search,
              onChanged: (String query) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 300), () {
                  _blocksCubit.filterBlocks(query.trim());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBody(int crossAxisCount, AppLocalizations locale) {
    return BlocBuilder<ResidentialBlocksCubit, ResidentialBlocksState>(
      buildWhen: (previous, current) =>
          current is ResidentialBlocksLoaded ||
          current is ResidentialBlocksLoading ||
          current is ResidentialBlocksFailure,
      builder: (context, state) {
        if (state is ResidentialBlocksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ResidentialBlocksFailure) {
          return OnFailureWidget(onRetry: () => reset());
        } else if (state is ResidentialBlocksLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatItemWidget(
                          title: locale.Blocks,
                          count: state.dashboardData.totalBlocks,
                          icon: Icons.grid_view,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatItemWidget(
                          title: locale.Families,
                          count: state.dashboardData.totalFamilies,
                          icon: Icons.people,
                          color: const Color(0xFFEFA98D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (state.filteredBlocks.isEmpty)
                    SizedBox(
                      height: 200,
                      child: Center(child: NoResultWidget()),
                    )
                  else
                    StaggeredGrid.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: state.filteredBlocks.map((block) {
                        return StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: BlockCardWidget(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.residentialBlockFamilies,
                                arguments:
                                    BlocProvider.of<ResidentialBlocksCubit>(
                                      context,
                                    )..getBlockFamilies(block.id),
                              );
                              // Navigator.pushNamed(
                              //   context,
                              //   AppRoute.residentialBlockDetial,
                              //   arguments: block.id,
                              // );
                            },
                            onLongPress: () {
                              if (_profileModel?.role!.toLowerCase() ==
                                      AppRoles.admin.name.toLowerCase() ||
                                  _profileModel?.role!.toLowerCase() ==
                                      AppRoles.unitManager.name.toLowerCase() ||
                                  _profileModel?.role!.toLowerCase() ==
                                      AppRoles
                                          .residentialNeighborhoodManager
                                          .name
                                          .toLowerCase()) {
                                context.showBottomSheet(
                                  BlockOptionsSheet(
                                    block: block,
                                    cubit: _blocksCubit,
                                  ),
                                );
                              }
                            },
                            block: block,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
