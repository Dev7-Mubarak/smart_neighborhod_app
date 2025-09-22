import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../cubits/block_cubit/block_cubit.dart';
import '../../cubits/block_cubit/block_state.dart';
import '../../../people/data/models/Person.dart';

class ChangeBlockManagerView extends StatefulWidget {
  const ChangeBlockManagerView({super.key});

  @override
  State<ChangeBlockManagerView> createState() => _ChangeBlockManagerViewState();
}

class _ChangeBlockManagerViewState extends State<ChangeBlockManagerView> {
  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPerson;
  late PersonCubit _personCubit;
  late BlockCubit _blockCubit;

  @override
  void initState() {
    super.initState();
    _personCubit = context.read<PersonCubit>()..getPeople();
    _blockCubit = context.read<BlockCubit>();
    _emailController = TextEditingController(
      text: _blockCubit.block?.email ?? '',
    );
    _selectedPerson = _blockCubit.block?.personId;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return BlocListener<BlockCubit, BlockState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddBlock) {
          context.showLoadingDialog();
        }
        if (state is BlockUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is BlocksFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              locale.changeManager,
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  child: Text(locale.failedToLoadPeople),
                                );
                              }
                              Person? initialSelectedPerson;
                              if (_selectedPerson != null) {
                                initialSelectedPerson = state.people.firstWhere(
                                  (person) => person.id == _selectedPerson,
                                );
                              }
                              return DropdownSearch<Person>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: locale.searchFamilyHead,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (context, person, isSelected) {
                                    return ListTile(
                                      title: Text(person.fullName),
                                      selected: isSelected,
                                    );
                                  },
                                  fit: FlexFit.loose,
                                ),
                                items: state.people,
                                itemAsString: (Person? u) => u?.fullName ?? '',
                                onChanged: (Person? data) {
                                  _blockCubit.changeSelectedBlockManager(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedPerson,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: locale.chooseFamilyHead,
                                    hintText: locale.chooseFamilyHead,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                validator: (Person? item) {
                                  if (item == null) {
                                    return locale.pleaseChooseFamilyHead;
                                  }
                                  return null;
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 20),
                        SmallText(text: locale.email),
                        CustomTextFormField(
                          controller: _emailController,
                          suffixIcon: null,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return locale.pleaseEnterUsername;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SmallText(text: locale.password),
                        CustomTextFormField(
                          controller: _passwordController,
                          suffixIcon: null,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return locale.passwordValidationHint;
                            }
                            if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[0-9])',
                            ).hasMatch(value)) {
                              return locale.passwordValidationHint;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallButton(
                        text: locale.save,
                        onPressed: () {
                          _blockCubit.changeBlockManager(
                            id: _blockCubit.block?.id ?? 0,
                            personId: _blockCubit.selectedManager ?? 0,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
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
      ),
    );
  }
}
