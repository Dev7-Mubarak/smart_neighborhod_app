import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/NavigationBar.dart';
import 'package:smart_neighborhod_app/components/boldText.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/default_text_form_filed.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';
import 'package:smart_neighborhod_app/cubits/person_cubit/person_cubit.dart';

import '../../cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../models/Person.dart';

import 'package:dropdown_search/dropdown_search.dart';

class AddNewBlock extends StatefulWidget {
  const AddNewBlock({super.key});

  @override
  State<AddNewBlock> createState() => _AddNewBlockState();
}

class _AddNewBlockState extends State<AddNewBlock> {
  final TextEditingController nameBlockController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // int? _personId;
  Person? _selectedPerson;

  @override
  void initState() {
    super.initState();
    context.read<PersonCubit>().getPeople();
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
          title: const Center(
            child: Text(
              'إضافة مربع سكني جديد',
              style: TextStyle(
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
                  const boldtext(
                    boldSize: .2,
                    fontcolor: Colors.black54,
                    fontsize: 18,
                    text: 'اسم المربع السكني',
                  ),
                  const SizedBox(height: 18),
                  DefaultTextFormFiled(
                    bordercolor: AppColor.gray2,
                    fillcolor: AppColor.white,
                    hintText: 'اسم المربع السكني',
                    controller: nameBlockController,
                    isPassword: false,
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

                              if (_selectedPerson == null &&
                                  state.people.isNotEmpty) {
                                _selectedPerson = state.people
                                    .first; // يمكن تفعيل هذا إذا أردت تحديد أول عنصر تلقائياً
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
                                  setState(() {
                                    _selectedPerson = data;
                                  });
                                },
                                selectedItem: _selectedPerson,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر المدير",
                                    hintText: "اختر مدير المربع السكني",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
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
                            //   if (state is PersonLoaded && state.people.isEmpty) {
                            //     return const Center(
                            //         child: Text('لا يوجد مديرين'));
                            //   }

                            //   if (state is PersonFailure) {
                            //     return Center(child: Text(state.errorMessage));
                            //   }

                            //   if (_personId == null && state is PersonLoaded) {
                            //     _personId = state.people.first.id;
                            //   }

                            //   if (state is PersonLoaded) {
                            //     return DropdownButtonFormField<int>(
                            //       value: _personId,
                            //       decoration: const InputDecoration(
                            //         labelText: 'Manager',
                            //         border: OutlineInputBorder(),
                            //       ),
                            //       items: state.people.map((person) {
                            //         return DropdownMenuItem(
                            //           value: person.id,
                            //           child: Text(person.fullName),
                            //         );
                            //       }).toList(),
                            //       onChanged: (value) {
                            //         if (value != null) {
                            //           setState(() {
                            //             _personId = value;
                            //           });
                            //         }
                            //       },
                            //     );
                            //   }

                            //   return Container();
                            // },
                            return Container();
                          },
                        ),
                        const SizedBox(height: 20),
                        buildLabel('البريد الإلكتروني للمستخدم'),
                        DefaultTextFormFiled(
                          hintText: 'البريد الإلكتروني',
                          bordercolor: AppColor.gray2,
                          fillcolor: AppColor.white,
                          controller: usernameController,
                          isPassword: false,
                          suffixIcon: null,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'الرجاء إدخال بريد إلكتروني صالح';
                            }
                            return null;
                          },
                          // validator: (value) {
                          //   if (value == null || value.trim().isEmpty) {
                          //     return 'الرجاء إدخال اسم المستخدم';
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 20),
                        buildLabel('كلمة المرور'),
                        DefaultTextFormFiled(
                          hintText: 'كلمة المرور',
                          bordercolor: AppColor.gray2,
                          fillcolor: AppColor.white,
                          controller: passwordController,
                          isPassword: true,
                          suffixIcon: null,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              // غير من 6 إلى 8
                              return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                            }
                            // إضافة تحقق من الأحرف الكبيرة والأرقام إن لزم
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
                        text: 'إضافة',
                        onPressed: () {
                          // التحقق من صحة الفورم قبل الإرسال
                          if (_formKey.currentState!.validate()) {
                            context.read<BlockCubit>().addNewBlock(
                                  nameBlockController.text,
                                  _selectedPerson?.id,
                                  usernameController.text,
                                  passwordController.text,
                                );
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
        bottomNavigationBar: const navigationBar(),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
