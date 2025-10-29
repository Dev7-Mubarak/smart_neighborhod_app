import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../cubits/blockCubit/block_cubit.dart';
import '../../../people/data/models/Person.dart';

class AddBlockView extends StatefulWidget {
  const AddBlockView({super.key});

  @override
  State<AddBlockView> createState() => _AddBlockViewState();
}

class _AddBlockViewState extends State<AddBlockView> {
  late final TextEditingController blockNameController;
  late final TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPersonId;
  late PersonCubit personCubit;
  late BlockCubit blockCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    blockCubit = context.read<BlockCubit>();
    blockNameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    blockNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Center(
          child: Text(
            'إضافة مربع سكني',
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
                              return const Center(
                                child: Text('لا يوجد مديرين متاحين'),
                              );
                            }

                            Person? initialSelectedPerson;
                            if (_selectedPersonId != null) {
                              initialSelectedPerson = state.people.firstWhere(
                                (person) => person.id == _selectedPersonId,
                              );
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
                                blockCubit.changeSelectedBlockManager(data?.id);
                              },
                              selectedItem: initialSelectedPerson,
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
                      const SmallText(text: 'الايميل'),
                      CustomTextFormField(
                        controller: emailController,
                        suffixIcon: null,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال الايميل';
                          }
                          final email = value.trim();
                          final emailRegex = RegExp(
                            r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$',
                          );
                          if (!emailRegex.hasMatch(email)) {
                            return 'الرجاء إدخال ايميل صالح';
                          }
                          return null;
                        },
                      ),
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
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallButton(
                      text: 'إضافة',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          blockCubit.addNewBlock(
                            blockNameController.text,
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    SmallButton(
                      text: 'إلغاء',
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
