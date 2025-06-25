import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import 'package:smart_negborhood_app/components/custom_navigation_bar.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';

import '../../components/constants/small_text.dart';
import '../../components/custom_text_input_filed.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../models/Person.dart';

import 'package:dropdown_search/dropdown_search.dart';

class AddUpdateBlock extends StatefulWidget {
  const AddUpdateBlock({super.key});

  @override
  State<AddUpdateBlock> createState() => _AddUpdateBlockState();
}

class _AddUpdateBlockState extends State<AddUpdateBlock> {
  late final TextEditingController blockNameController;
  late final TextEditingController usernameController;
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // int? _personId;
  Person? _selectedPerson;
  late PersonCubit personCubit;
  late BlockCubit blockCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    blockCubit = context.read<BlockCubit>();
    blockNameController = TextEditingController(
      text: blockCubit.block?.name ?? '',
    );
    usernameController = TextEditingController(
      text: blockCubit.block?.userName ?? '',
    );

    _selectedPerson = blockCubit.selectedManager;
  }

  @override
  void dispose() {
    blockNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlockCubit, BlockState>(
      listener: (context, state) {
        if (state is BlockAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is BlocksFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              blockCubit.block == null
                  ? 'إضافة مربع سكني جديد'
                  : 'تعديل بيانات مربع سكني',
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  const SmallText(text: 'اسم المربع السكني'),
                  const SizedBox(height: AppSize.spasingBetweenInputBloc),
                  CustomTextFormField(
                    bachgroundColor: AppColor.white,
                    controller: blockNameController,
                    keyboardType: TextInputType.name,
                    suffixIcon: null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال اسم المربع السكني';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  const SmallText(text: 'مدير المربع السكني'),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                return const Center(
                                  child: Text('لا يوجد مديرين متاحين'),
                                );
                              }

                              if (_selectedPerson == null &&
                                  state.people.isNotEmpty) {
                                _selectedPerson = state.people.first;
                              }

                              return DropdownSearch<Person>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "ابحث عن مدير...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (context, person, isSelected) {
                                    return ListTile(
                                      title: Text(
                                        person.fullName,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      selected: isSelected,
                                    );
                                  },
                                  fit: FlexFit.loose,
                                ),
                                items: state.people,
                                itemAsString: (Person? u) => u?.fullName ?? '',
                                onChanged: (Person? data) {
                                  blockCubit.changeSelectedManager(data);
                                },
                                selectedItem: _selectedPerson,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر المدير",
                                    hintText: "اختر مدير المربع السكني",
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
                                    return "الرجاء اختيار مدير للمربع";
                                  }
                                  return null;
                                },
                              );
                            }

                            return Container();
                          },
                        ),
                        const SizedBox(height: 20),
                        const SmallText(text: 'اسم المستخدم'),
                        CustomTextFormField(
                          controller: usernameController,
                          suffixIcon: null,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال اسم المستخدم';
                            }
                            return null;
                          },
                        ),
                        if (blockCubit.block == null) ...[
                          const SizedBox(height: 20),
                          const SmallText(text: 'كلمة المرور'),
                          CustomTextFormField(
                            controller: passwordController,
                            suffixIcon: null,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                              }
                              if (!RegExp(
                                r'^(?=.*[A-Z])(?=.*[0-9])',
                              ).hasMatch(value)) {
                                return 'يجب أن تحتوي على حرف كبير ورقم على الأقل';
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallButton(
                        text: 'إلغاء',
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      SmallButton(
                        text: blockCubit.block == null ? 'إضافة' : 'تعديل',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (blockCubit.block == null) {
                              blockCubit.addNewBlock(
                                blockNameController.text,
                                usernameController.text,
                                passwordController.text,
                              );
                            } else {
                              blockCubit.updateBlock(
                                userName: usernameController.text,
                                id: blockCubit.block!.id,
                                name: blockNameController.text,
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}
