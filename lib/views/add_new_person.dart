// import 'dart:html';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';
import 'package:smart_neighborhod_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_neighborhod_app/models/enums/blood_type.dart';
import 'package:smart_neighborhod_app/models/enums/marital_status.dart';
import 'package:smart_neighborhod_app/models/enums/occupation_status.dart';
import '../components/CustomDropdown.dart';
import '../components/NavigationBar.dart';
import '../components/constants/small_text.dart';
import '../components/custom_text_input_filed.dart';
import '../models/enums/identity_type.dart';
import 'package:intl/intl.dart';

class AddNewPerson extends StatefulWidget {
  const AddNewPerson({super.key});

  @override
  State<AddNewPerson> createState() => AaddNewPersonState();
}

class AaddNewPersonState extends State<AddNewPerson> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController thirdNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController identityNumberController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'إضافة شخص جديد',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColor.gray,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SmallText(text: 'الاسم الاول'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الاول',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم الثاني'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الثاني',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم الثالث'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الثالت',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم الربع'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الرابع',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'رقم الهوية'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'رقم الهوية',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'نوع الهوية'),
                  const SizedBox(height: 6),
                  BlocBuilder<PersonCubit, PersonState>(
                    builder: (context, state) {
                      return CustomDropdown(
                        items: IdentityType.values
                            .map((e) => e.displayName)
                            .toList(),
                        onChanged: (String? newValue) {
                          context
                              .read<PersonCubit>()
                              .changeSelectedIdentityType(IdentityType.values
                                  .firstWhere(
                                      (e) => e.displayName == newValue));
                        },
                        selectedValue: context
                            .read<PersonCubit>()
                            .selectedIdentityType
                            ?.displayName,
                        text: 'نوع الهوية',
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SmallText(text: 'الجنس'),
                      const SizedBox(height: 6),
                      BlocBuilder<PersonCubit, PersonState>(
                        builder: (context, state) {
                          return SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'ذكر',
                                      groupValue: context
                                          .read<PersonCubit>()
                                          .selectedGender,
                                      onChanged: (value) {
                                        context
                                            .read<PersonCubit>()
                                            .changeSelctedGender(value!);
                                      },
                                    ),
                                    const SmallText(
                                      text: 'ذكر',
                                    )
                                  ],
                                ),
                                const SizedBox(width: 30),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'أنثى',
                                      groupValue: context
                                          .read<PersonCubit>()
                                          .selectedGender,
                                      onChanged: (value) {
                                        context
                                            .read<PersonCubit>()
                                            .changeSelctedGender(value!);
                                      },
                                    ),
                                    const SmallText(text: 'انثى')
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'رقم التواصل'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Expanded(
                        child: CustomTextFormField(
                          hintText: 'رقم التواصل',
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: const Icon(
                          Icons.phone_callback,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'طريقة الإتصال'),
                  const SizedBox(height: 6),
                  BlocBuilder<PersonCubit, PersonState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const SmallText(text: 'اتصال'),
                                Checkbox(
                                  value: context.read<PersonCubit>().isCall,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (bool? value) {
                                    context
                                        .read<PersonCubit>()
                                        .changeContactType(
                                            isCall: value,
                                            isWhatsapp: context
                                                .read<PersonCubit>()
                                                .isWhatsapp);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                const SmallText(text: 'واتس اب'),
                                Checkbox(
                                  value: context.read<PersonCubit>().isWhatsapp,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      context
                                          .read<PersonCubit>()
                                          .changeContactType(
                                              isWhatsapp: value,
                                              isCall: context
                                                  .read<PersonCubit>()
                                                  .isCall);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الإيميل'),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'الايميل',
                        ),
                      ),
                      Icon(
                        Icons.email,
                        color: AppColor.primaryColor,
                        size: 30,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'تاريخ الميلاد'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth *',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () => _pickDate(context),
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'فصيلة الدم'),
                  const SizedBox(height: 6),
                  BlocBuilder<PersonCubit, PersonState>(
                    builder: (context, state) {
                      return CustomDropdown(
                        items:
                            BloodType.values.map((e) => e.displayName).toList(),
                        selectedValue: context
                            .read<PersonCubit>()
                            .selectedBloodType
                            ?.displayName,
                        onChanged: (newValue) {
                          context.read<PersonCubit>().changeSelectedBloodType(
                              BloodType.values.firstWhere(
                                  (e) => e.displayName == newValue));
                        },
                        text: 'فصيلة الدم',
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SmallText(text: 'الحالة الاجتماعية'),
                              const SizedBox(height: 6),
                              BlocBuilder<PersonCubit, PersonState>(
                                builder: (context, state) {
                                  return CustomDropdown(
                                    items: MaritalStatus.values
                                        .map((e) => e.displayName)
                                        .toList(),
                                    selectedValue: context
                                        .read<PersonCubit>()
                                        .selectedMaritalStatus
                                        ?.displayName,
                                    onChanged: (newValue) {
                                      context
                                          .read<PersonCubit>()
                                          .changeSelectedMaritalStatus(
                                              MaritalStatus.values.firstWhere(
                                                  (e) =>
                                                      e.displayName ==
                                                      newValue));
                                    },
                                    text: 'الحالة الاجتماعية',
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              const SmallText(text: 'الحالة المهنية'),
                              const SizedBox(height: 6),
                              BlocBuilder<PersonCubit, PersonState>(
                                builder: (context, state) {
                                  return CustomDropdown(
                                    items: OccupationStatus.values
                                        .map((e) => e.displayName)
                                        .toList(),
                                    selectedValue: context
                                        .read<PersonCubit>()
                                        .selectedOccupationStatus
                                        ?.displayName,
                                    onChanged: (newValue) {
                                      context
                                          .read<PersonCubit>()
                                          .changeSelectedOccupationStatus(
                                              OccupationStatus.values
                                                  .firstWhere((e) =>
                                                      e.displayName ==
                                                      newValue));
                                    },
                                    text: 'الحالة المهنية',
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ImagePicker()
                              .pickImage(source: ImageSource.gallery)
                              .then((value) => context
                                  .read<PersonCubit>()
                                  .uplodePorfilePicture(value!));
                        },
                        child: const Icon(
                          Icons.camera_alt_sharp,
                        ),
                      ),
                      //                       SmallButton(
                      //   text: 'إضافة صورة شخصية',
                      //   onPressed:
                      //   ImagePicker().pickImage(source: ImageSource.gallery)
                      //   .then((value) => context.read<PersonCubit>().uplodePorfilePicture(value)),
                      // ),
                      // const SizedBox(width: 20),
                      Expanded(
                        child: BlocBuilder<PersonCubit, PersonState>(
                          builder: (context, state) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black26, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: context
                                          .read<PersonCubit>()
                                          .profilePicture ==
                                      null
                                  ? const Icon(Icons.person)
                                  : CircleAvatar(
                                      backgroundImage: FileImage(File(context
                                          .read<PersonCubit>()
                                          .profilePicture!
                                          .path)),
                                    ),
                              //         size: 60, color: Colors.grey),
                              // child: _pickedImage == null
                              //     ? const Icon(Icons.person,
                              //         size: 60, color: Colors.grey)
                              //     : ClipRRect(
                              //         borderRadius: BorderRadius.circular(8),
                              //         child: Image.file(
                              //           _pickedImage!,
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                            );
                          },
                        ),
                      ),
                    ],
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                SmallButton(
                  text: 'إضافة',
                  onPressed: () {
                    // context.read<PersonCubit>()
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const navigationBar(),
    );
  }
}
