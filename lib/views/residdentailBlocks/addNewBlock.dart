import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/custom_navigation_bar.dart';
import 'package:smart_neighborhod_app/components/boldText.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/constants/app_size.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';
import 'package:smart_neighborhod_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_neighborhod_app/models/Block.dart';

import '../../components/constants/small_text.dart';
import '../../components/custom_text_input_filed.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../models/Person.dart';

import 'package:dropdown_search/dropdown_search.dart';

class AddNewBlock extends StatefulWidget {
  const AddNewBlock({super.key, this.block});
  final Block? block;

  @override
  State<AddNewBlock> createState() => _AddNewBlockState();
}

class _AddNewBlockState extends State<AddNewBlock> {
  late final TextEditingController nameBlockController;
  final TextEditingController usernameController = TextEditingController();
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
    nameBlockController = TextEditingController(text: widget.block?.name ?? '');
  }

  @override
  void dispose() {
    nameBlockController.dispose();
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
                  fontSize: 22),
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
                  const SmallText(
                    text: 'اسم المربع السكني',
                  ),
                  const SizedBox(height: AppSize.spasingBetweenInputBloc),
                  CustomTextFormField(
                    bachgroundColor: AppColor.white,
                    controller: nameBlockController,
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
                  const boldtext(
                    boldSize: .2,
                    fontcolor: Colors.black54,
                    fontsize: 18,
                    text: 'مدير المربع السكني',
                  ),
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
                                  child: CircularProgressIndicator());
                            }
                            if (state is PersonLoaded) {
                              if (state.people.isEmpty) {
                                return const Center(
                                    child: Text('لا يوجد مديرين متاحين'));
                              }
                              if (blockCubit.selectedManager == null &&
                                  state.people.isNotEmpty) {
                                blockCubit.changeSelectedManager(state.people
                                    .first); // يمكن تفعيل هذا إذا أردت تحديد أول عنصر تلقائياً
                              }
                              // if (_selectedPerson == null &&
                              //     state.people.isNotEmpty) {
                              //   _selectedPerson = state.people
                              //       .first; // يمكن تفعيل هذا إذا أردت تحديد أول عنصر تلقائياً
                              // }

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
                                        horizontal: 12, vertical: 8),
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
                            if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])')
                                .hasMatch(value)) {
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
                          text: 'إلغاء',
                          onPressed: () => Navigator.pop(context)),
                      const SizedBox(width: 10),
                      SmallButton(
                        text: widget.block == null ? 'إضافة' : 'تعديل',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.block == null) {
                              blockCubit.addNewBlock(
                                nameBlockController.text,
                                usernameController.text,
                                passwordController.text,
                              );
                            } else {
                              blockCubit.updateBlock(
                                email: usernameController.text,
                                id: widget.block!.id,
                                name: nameBlockController.text,
                                password: passwordController.text,
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  )
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
