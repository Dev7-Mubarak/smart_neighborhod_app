import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/small_text.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/custom_text_input_filed.dart';
import '../../components/smallButton.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../cubits/person_cubit/person_cubit.dart';
import '../../models/Person.dart';

class ChangeBlockManager extends StatefulWidget {
  const ChangeBlockManager({super.key});

  @override
  State<ChangeBlockManager> createState() => _ChangeBlockManagerState();
}

class _ChangeBlockManagerState extends State<ChangeBlockManager> {
  late final TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Person? _selectedPerson;
  late PersonCubit personCubit;
  late BlockCubit blockCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    blockCubit = context.read<BlockCubit>();
    emailController =
        TextEditingController(text: blockCubit.block?.email ?? '');
    _selectedPerson = blockCubit.selectedManager;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlockCubit, BlockState>(
      listener: (context, state) {
        if (state is BlockManagerChanangeSuccessfully) {
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
              'تعديل مدير المربع السكني',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
        body: BlocBuilder<BlockCubit, BlockState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: state is BlocksLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 20),
                            const SmallText(
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
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (state is PersonLoaded) {
                                          if (state.people.isEmpty) {
                                            return const Center(
                                                child: Text(
                                                    'لا يوجد مديرين متاحين'));
                                          }

                                          if (_selectedPerson == null &&
                                              state.people.isNotEmpty) {
                                            _selectedPerson =
                                                state.people.first;
                                            blockCubit.changeSelectedManager(
                                                _selectedPerson);
                                          }

                                          return DropdownSearch<Person>(
                                            popupProps: PopupProps.menu(
                                              showSearchBox: true,
                                              searchFieldProps: TextFieldProps(
                                                decoration: InputDecoration(
                                                  hintText: "ابحث عن مدير...",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              menuProps: MenuProps(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              itemBuilder: (context, person,
                                                  isSelected) {
                                                return ListTile(
                                                  title: Text(
                                                    person.fullName,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                                  selected: isSelected,
                                                );
                                              },
                                              fit: FlexFit.loose,
                                            ),
                                            items: state.people,
                                            itemAsString: (Person? u) =>
                                                u?.fullName ?? '',
                                            onChanged: (Person? data) {
                                              blockCubit
                                                  .changeSelectedManager(data);
                                            },
                                            selectedItem: _selectedPerson,
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                labelText: "اختر المدير",
                                                hintText:
                                                    "اختر مدير المربع السكني",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
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
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'الرجاء إدخال الايميل';
                                        }
                                        final emailRegex = RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                        if (!emailRegex
                                            .hasMatch(value.trim())) {
                                          return 'الرجاء إدخال بريد إلكتروني صحيح';
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
                                  ]),
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
                                  text: 'تعديل',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      blockCubit.changeBlockManager(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );
                                      // Navigator.pop(context);
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
              ),
            );
          },
        ),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}
