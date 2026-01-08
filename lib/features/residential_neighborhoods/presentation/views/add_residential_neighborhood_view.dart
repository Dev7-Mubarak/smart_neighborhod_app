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
import 'package:smart_negborhood_app/features/residential_neighborhoods/cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';

import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';

class AddResidentialNeighborhoodView extends StatefulWidget {
  const AddResidentialNeighborhoodView({super.key});

  @override
  State<AddResidentialNeighborhoodView> createState() =>
      _AddResidentialNeighborhoodViewState();
}

class _AddResidentialNeighborhoodViewState
    extends State<AddResidentialNeighborhoodView> {
  late final TextEditingController neighborhoodNameController;
  late final TextEditingController identifierController;
  late final TextEditingController passwordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPersonId;
  late PersonCubit personCubit;
  late ResidentialNeighborhoodsCubit neighborhoodsCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    neighborhoodsCubit = context.read<ResidentialNeighborhoodsCubit>();
    neighborhoodNameController = TextEditingController();
    identifierController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    neighborhoodNameController.dispose();
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
            locale.AddResidentialNeighborhood,
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
                      SmallText(text: locale.ResidentialNeighborhoodName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        bachgroundColor: AppColor.white,
                        controller: neighborhoodNameController,
                        keyboardType: TextInputType.name,
                        suffixIcon: null,
                        validator: AppValidator.validateEmptyField,
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(
                        text: locale.ResidentialNeighborhoodManagerName,
                      ),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<PersonCubit, PersonState>(
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
                            Person? initialSelectedPerson;
                            if (_selectedPersonId != null) {
                              initialSelectedPerson = state.people.firstWhere(
                                (person) => person.id == _selectedPersonId,
                              );
                            }
                            return CustomDropdownSearchWidget<Person>(
                              items: state.people,
                              itemAsString: (Person? u) => u?.fullName ?? '',
                              onChanged: (Person? data) {
                                neighborhoodsCubit
                                    .changeSelectedNeighborhoodManager(
                                      data?.id,
                                    );
                              },
                              selectedItem: initialSelectedPerson,
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
                          neighborhoodsCubit.addNewNeighborhood(
                            neighborhoodNameController.text,
                            identifierController.text,
                            passwordController.text,
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
