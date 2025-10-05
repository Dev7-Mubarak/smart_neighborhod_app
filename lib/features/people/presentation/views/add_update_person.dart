import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/core/common/enums/blood_type.dart';
import 'package:smart_negborhood_app/core/common/enums/gender.dart';
import 'package:smart_negborhood_app/core/common/enums/marital_status.dart';
import 'package:smart_negborhood_app/core/common/enums/occupation_status.dart';
import '../../../../core/common/widgets/CustomDropdown.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../data/models/Person.dart';

class AddUpdatePerson extends StatefulWidget {
  const AddUpdatePerson({super.key, this.person});
  final Person? person;
  @override
  State<AddUpdatePerson> createState() => AddUpdatePersonState();
}

class AddUpdatePersonState extends State<AddUpdatePerson> {
  late final TextEditingController firstNameController;
  late final TextEditingController secondNameController;
  late final TextEditingController thirdNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController birthDateController;
  late final TextEditingController phoneNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final cubit = context.read<PersonCubit>();
    firstNameController = TextEditingController(
      text: widget.person?.firstName ?? '',
    );
    secondNameController = TextEditingController(
      text: widget.person?.secondName ?? '',
    );
    thirdNameController = TextEditingController(
      text: widget.person?.thirdName ?? '',
    );
    lastNameController = TextEditingController(
      text: widget.person?.lastName ?? '',
    );

    final date =
        cubit.selectedDate ??
        widget.person?.dateOfBirth ??
        DateTime(2000, 1, 1);
    birthDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(date),
    );
    phoneNumberController = TextEditingController(
      text: widget.person?.phoneNumber,
    );

    cubit.selectedGender = widget.person?.gender;

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    thirdNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonCubit>();
    return BlocListener<PersonCubit, PersonState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddPerson) {
          context.showLoadingDialog();
        } else if (state is PersonAddedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.of(context).pop();
        } else if (state is PersonUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar("تمت العملية بنجاح");
          Navigator.of(context).pop();
        } else if (state is PersonAddedFailure) {
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
              context.read<PersonCubit>().person == null
                  ? 'إضافة شخص جديد'
                  : 'تعديل بيانات الشخص',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SmallText(text: 'الاسم الاول'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الاسم الاول مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'الاسم الثاني'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: secondNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الاسم الثاني مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'الاسم الثالث'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: thirdNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الاسم الثالث مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'الاسم الربع'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الاسم الرابع مطلوب';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      _buildGenderSelector(cubit),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'رقم التواصل'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      Row(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: const Icon(
                              Icons.phone_callback,
                              color: AppColor.primaryColor,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: CustomTextFormField(
                              controller: phoneNumberController,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    !RegExp(r'^[0-9]{8,}$').hasMatch(value)) {
                                  return 'رقم التواصل غير صحيح';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'تاريخ الميلاد'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: birthDateController,
                        suffixIcon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () => cubit.pickDate(context),
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'فصيلة الدم'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<PersonCubit, PersonState>(
                        builder: (context, state) {
                          return CustomDropdown(
                            items: BloodType.values
                                .map((e) => e.arabicName)
                                .toList(),
                            selectedValue: cubit.selectedBloodType?.arabicName,
                            onChanged: (String? newValue) {
                              cubit.changeSelectedBloodType(
                                BloodType.values.firstWhere(
                                  (e) => e.arabicName == newValue,
                                ),
                              );
                            },
                            text: 'اختبار فصيلة الدم',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى اختيار فصيلة الدم';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SmallText(text: 'الحالة الاجتماعية'),
                                const SizedBox(
                                  height: AppSize.spasingBetweenInputsAndLabale,
                                ),
                                BlocBuilder<PersonCubit, PersonState>(
                                  buildWhen: (previous, current) =>
                                      current is ChangeSelectedMaritalStatus,
                                  builder: (context, state) {
                                    return CustomDropdown(
                                      items: MaritalStatus.values
                                          .map((e) => e.arabicName)
                                          .toList(),
                                      selectedValue: cubit
                                          .selectedMaritalStatus
                                          ?.arabicName,
                                      onChanged: (newValue) {
                                        cubit.changeSelectedMaritalStatus(
                                          MaritalStatus.values.firstWhere(
                                            (e) => e.arabicName == newValue,
                                          ),
                                        );
                                      },
                                      text: 'اختيار الحالة الاجتماعية',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'يرجى اختيار الحالة الاجتماعية';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: AppSize.spasingBetweenInputBloc,
                                ),
                                const SmallText(text: 'الحالة المهنية'),
                                const SizedBox(
                                  height: AppSize.spasingBetweenInputsAndLabale,
                                ),
                                BlocBuilder<PersonCubit, PersonState>(
                                  buildWhen: (previous, current) =>
                                      current is ChangeSelectedOccupationStatus,
                                  builder: (context, state) {
                                    return CustomDropdown(
                                      items: OccupationStatus.values
                                          .map((e) => e.arabicName)
                                          .toList(),
                                      selectedValue: context
                                          .read<PersonCubit>()
                                          .selectedOccupationStatus
                                          ?.arabicName,
                                      onChanged: (newValue) {
                                        cubit.changeSelectedOccupationStatus(
                                          OccupationStatus.values.firstWhere(
                                            (e) => e.arabicName == newValue,
                                          ),
                                        );
                                      },
                                      text: 'اختيار الحالة المهنية',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'يرجى اختيار الحالة المهنية';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      _buildImagePicker(context, cubit),
                    ],
                  ),
                ),
                const SizedBox(height: AppSize.spasingBetweenInputBloc),
                _buildSubmitButtons(context, cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, PersonCubit cubit) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(color: AppColor.primaryColor, width: 2),
            ),
            child: GestureDetector(
              onTap: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  cubit.uplodePorfilePicture(picked);
                }
              },
              child: BlocBuilder<PersonCubit, PersonState>(
                buildWhen: (previous, current) =>
                    current is UplodePeofilePicture,
                builder: (context, state) {
                  if (cubit.profilePicture != null) {
                    return CircleAvatar(
                      backgroundImage: FileImage(
                        File(cubit.profilePicture!.path),
                      ),
                      radius: 48,
                    );
                  } else if (widget.person?.image != null &&
                      widget.person!.image!.isNotEmpty) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(widget.person!.image!),
                      radius: 48,
                    );
                  } else {
                    return CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector(PersonCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallText(text: 'الجنس'),
        const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
        BlocBuilder<PersonCubit, PersonState>(
          buildWhen: (previous, current) => current is ChangeSelctedGender,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: Gender.Male.name,
                      groupValue: cubit.selectedGender,
                      onChanged: (value) {
                        cubit.changeSelctedGender(value!);
                      },
                    ),
                    const SmallText(text: 'ذكر'),
                  ],
                ),
                const SizedBox(width: 30),
                Row(
                  children: [
                    Radio<String>(
                      value: Gender.Female.name,
                      groupValue: cubit.selectedGender,
                      onChanged: (value) {
                        cubit.changeSelctedGender(value!);
                      },
                    ),
                    const SmallText(text: 'انثى'),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButtons(BuildContext context, PersonCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SmallButton(
          text: widget.person == null ? 'إضافة' : 'تعديل',
          onPressed: () {
            if (cubit.selectedGender == null) {
              context.showErrorSnackBar("يرجى اختيار الجنس.");
              return;
            }
            if (_formKey.currentState!.validate()) {
              if (widget.person == null) {
                cubit.addNewPerson(
                  firstName: firstNameController.text,
                  secondName: secondNameController.text,
                  thirdName: thirdNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneNumberController.text,
                );
              } else {
                cubit.updatePerson(
                  id: widget.person!.id,
                  firstName: firstNameController.text,
                  secondName: secondNameController.text,
                  thirdName: thirdNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneNumberController.text,
                );
              }
            }
          },
        ),
        const SizedBox(width: 10),
        SmallButton(
          text: 'إلغاء',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
