import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/DropdownSearch.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/API/dio_consumer.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_model.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_cubit.dart';

import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';

class AddResidentialUnitView extends StatefulWidget {
  const AddResidentialUnitView({super.key});

  @override
  State<AddResidentialUnitView> createState() => _AddResidentialUnitViewState();
}

class _AddResidentialUnitViewState extends State<AddResidentialUnitView> {
  late final TextEditingController unitNameController;
  late final TextEditingController identifierController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late PersonCubit personCubit;
  late ResidentialNeighborhoodsCubit residentialNeighborhoodsCubit;
  late ResidentialUnitsCubit unitsCubit;
  int? _selectedNeighborhoodId;
  bool isNeighborhoodPreSelected = false;
  @override
  void initState() {
    super.initState();
    residentialNeighborhoodsCubit =
        context.read<ResidentialNeighborhoodsCubit>()
          ..getResidentialNeighborhoodsDashboard();
    personCubit = context.read<PersonCubit>()..getPeople();
    unitsCubit = context.read<ResidentialUnitsCubit>();
    unitNameController = TextEditingController();
    identifierController = TextEditingController();
    passwordController = TextEditingController();
    _selectedNeighborhoodId = unitsCubit.selectedNeighborhoodId;
    if (_selectedNeighborhoodId != null) {
      isNeighborhoodPreSelected = true;
    } else {
      isNeighborhoodPreSelected = false;
    }
  }

  @override
  void dispose() {
    unitNameController.dispose();
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Center(
          child: Text(
            locale.AddResidentialUnit,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColor.gray,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(text: locale.ResidentialUnitName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        bachgroundColor: AppColor.white,
                        controller: unitNameController,
                        keyboardType: TextInputType.name,
                        suffixIcon: null,
                        validator: AppValidator.validateEmptyField,
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: locale.ResidentialNeighborhoodName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<
                        ResidentialNeighborhoodsCubit,
                        ResidentialNeighborhoodsState
                      >(
                        builder: (context, state) {
                          if (state is ResidentialNeighborhoodsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is ResidentialNeighborhoodsFailure) {
                            return OnFailureWidget(
                              onRetry: () => residentialNeighborhoodsCubit
                                  .getResidentialNeighborhoodsDashboard(),
                            );
                          }
                          if (state is ResidentialNeighborhoodsLoaded) {
                            final items = state.filteredNeighborhoods;
                            if (items.isEmpty) {
                              return Center(
                                child: Text(locale.noManagersAvailable),
                              );
                            }
                            ResidentialNeighborhoodModel?
                            initialSelectedNeighborhood;
                            if (_selectedNeighborhoodId != null) {
                              initialSelectedNeighborhood = items.firstWhere(
                                (neighborhood) =>
                                    neighborhood.neighborhoodId ==
                                    unitsCubit.selectedNeighborhoodId,
                              );
                            }
                            return CustomDropdownSearchWidget<
                              ResidentialNeighborhoodModel
                            >(
                              enabled: !isNeighborhoodPreSelected,
                              items: items,
                              itemAsString: (ResidentialNeighborhoodModel? u) =>
                                  u?.neighborhoodName ?? '',
                              onChanged: (ResidentialNeighborhoodModel? data) {
                                unitsCubit.changeSelectedNeighborhoodId(
                                  data?.neighborhoodId,
                                );
                              },
                              selectedItem: initialSelectedNeighborhood,
                              labelText: locale.chooseNeighborhood,
                              hintText: locale.chooseNeighborhood,
                              searchHintText: locale.searchNeighborhoodHint,
                              validator: (item) =>
                                  AppValidator.validateDropdown(item),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: locale.ResidentialUnitManagerName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<PersonCubit, dynamic>(
                        builder: (context, state) {
                          if (state is PersonLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is PersonLoaded) {
                            if (state.people.isEmpty) {
                              return Center(
                                child: Text(locale.noManagersAvailable),
                              );
                            }
                            return CustomDropdownSearchWidget<Person>(
                              items: state.people,
                              itemAsString: (Person? u) => u?.fullName ?? '',
                              onChanged: (Person? data) {
                                unitsCubit.changeSelectedUnitManager(data?.id);
                              },
                              selectedItem: null,
                              labelText: locale.chooseManager,
                              hintText: locale.chooseManager,
                              searchHintText: locale.searchManagerHint,
                              validator: (Person? item) =>
                                  AppValidator.validateDropdown(item),
                            );
                          } else if (state is PersonFailure) {
                            return OnFailureWidget(
                              onRetry: () => personCubit.getPeople(),
                            );
                          } else {
                            return Center(child: Text(locale.unknownError));
                          }
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: locale.username),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: identifierController,
                        suffixIcon: null,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.validateEmptyField,
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: locale.password),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: passwordController,
                        suffixIcon: null,
                        keyboardType: TextInputType.text,
                        validator: AppValidator.validatePassword,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallButton(
                      text: locale.add,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          unitsCubit.addNewUnit(
                            name: unitNameController.text,
                            identifier: identifierController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    SmallButton(
                      text: locale.cancel,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
