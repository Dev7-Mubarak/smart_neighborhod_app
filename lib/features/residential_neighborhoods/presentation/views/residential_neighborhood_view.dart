import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
import '../../data/models/residential_neighborhood_model.dart';
import '../widgets/change_block_name_widget.dart';
import '../widgets/residential_neighborhood_card_widget.dart';

class ResidentialNeighborhoodView extends StatefulWidget {
  const ResidentialNeighborhoodView({super.key});

  @override
  State<ResidentialNeighborhoodView> createState() =>
      _ResidentialNeighborhoodViewState();
}

class _ResidentialNeighborhoodViewState
    extends State<ResidentialNeighborhoodView> {
  List<ResidentialNeighborhoodModel> residentialList = [];
  late final ResidentialNeighborhoodsCubit _residentialNeighborhoodsCubit;
  late final ProfileModel? _profileModel;

  @override
  void initState() {
    super.initState();
    _residentialNeighborhoodsCubit =
        context.read<ResidentialNeighborhoodsCubit>()
          ..getResidentialNeighborhoods();
    _profileModel = SharedPreferencesService.getProfile();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<
      ResidentialNeighborhoodsCubit,
      ResidentialNeighborhoodsState
    >(
      builder: (context, state) {
        if (state is ResidentialNeighborhoodsLoaded) {
          return buildLoadedListWidgets(state.allResidentialNeighborhoods);
        } else if (state is ResidentialNeighborhoodsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ResidentialNeighborhoodsFailure) {
          return OnFailureWidget(
            onRetry: () =>
                _residentialNeighborhoodsCubit.getResidentialNeighborhoods(),
          );
        } else {
          return OnFailureWidget(
            onRetry: () =>
                _residentialNeighborhoodsCubit.getResidentialNeighborhoods(),
          );
        }
      },
    );
  }

  Widget buildLoadedListWidgets(
    List<ResidentialNeighborhoodModel> residentialNeighborhoods,
  ) {
    if (residentialNeighborhoods.isEmpty) {
      return Center(child: NoResultWidget());
    }
    return ListView.builder(
      itemCount: residentialNeighborhoods.length,
      itemBuilder: (context, index) {
        return ResidentialNeighborhoodCardWidget(
          onTapCallback: (ctx, residentialNeighborhood) {
            Navigator.pushNamed(
              context,
              AppRoute.residentialBlockDetial,
              arguments: residentialNeighborhoods[index].id,
            );
          },
          residentialNeighborhood: residentialNeighborhoods[index],
          onLongPressCallback: (ctx, residentialNeighborhood) {
            if (_profileModel?.role == AppRole.Admin.name) {
              _showOptions(residentialNeighborhoods[index]);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
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
        } else if (state is ResidentialNeighborhoodDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is ResidentialNeighborhoodsFailure ||
            state is FailureForUpdateOrAddResidentialNeighborhood) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(
            state is ResidentialNeighborhoodsFailure
                ? state.errorMessage
                : (state as FailureForUpdateOrAddResidentialNeighborhood)
                      .errorMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                            arguments: _residentialNeighborhoodsCubit,
                          );
                        },
                      ),
                    if (_profileModel?.role == AppRole.Admin.name)
                      const SizedBox(
                        width: AppSize.spasingBetweenInputsAndLabale,
                      ),
                    Expanded(
                      child: SearchableTextFormField(
                        hintText: locale.searchResidentialBlock,
                        bachgroundColor: AppColor.gray2,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close),
                        ),
                        prefixIcon: Icons.search,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: buildBlocWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(ResidentialNeighborhoodModel residentialNeighborhood) {
    final locale = context.locale;

    context.showBottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'خيارات المربعات السكنية',
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
                _residentialNeighborhoodsCubit.setResidentialNeighborhood(
                  residentialNeighborhood,
                );
                context.showBottomSheet(
                  BlocProvider.value(
                    value: _residentialNeighborhoodsCubit,
                    child: ChangeBlockNameWidget(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: Text(locale.changeManager),
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
                    ..setResidentialNeighborhood(residentialNeighborhood),
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
              onPressed: () async {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(locale.confirmDelete),
                    content: Text(locale.deleteNotAllowed),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(locale.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _residentialNeighborhoodsCubit
                              .deleteResidentialNeighborhood(
                                residentialNeighborhood.id,
                              );
                        },
                        child: Text(
                          locale.delete,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
