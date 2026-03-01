import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/DropdownSearch.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/features/residential_units/cubits/residential_units_cubit/residential_units_cubit.dart';

import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';

class ChangeUnitManagerView extends StatefulWidget {
  const ChangeUnitManagerView({super.key});

  @override
  State<ChangeUnitManagerView> createState() => _ChangeUnitManagerViewState();
}

class _ChangeUnitManagerViewState extends State<ChangeUnitManagerView> {
  late final TextEditingController _identifierController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPerson;
  late PersonCubit _personCubit;
  late ResidentialUnitsCubit _unitsCubit;

  @override
  void initState() {
    super.initState();
    _personCubit = context.read<PersonCubit>()..getPeople();
    _unitsCubit = context.read<ResidentialUnitsCubit>();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
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
            locale.ChangeUnitManagerName,
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
                      SmallText(text: locale.ResidentialUnitManagerName),
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
                            if (_selectedPerson != null) {
                              initialSelectedPerson = state.people.firstWhere(
                                (person) => person.id == _selectedPerson,
                              );
                            }
                            return CustomDropdownSearchWidget<Person>(
                              items: state.people,
                              itemAsString: (Person? u) => u?.fullName ?? '',
                              onChanged: (Person? data) {
                                _unitsCubit.changeSelectedUnitManager(data?.id);
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
                              onRetry: () => _personCubit.getPeople(),
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
                        controller: _identifierController,
                        suffixIcon: null,
                        validator: AppValidator.validateEmptyField,
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: locale.password),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        suffixIcon: null,
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
                      text: locale.update,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _unitsCubit.changeUnitManager(
                            identifier: _identifierController.text,
                            password: _passwordController.text,
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
