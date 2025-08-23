import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/models/enums/blood_type.dart';
import 'package:smart_negborhood_app/models/enums/gender.dart';
import 'package:smart_negborhood_app/models/enums/marital_status.dart';
import 'package:smart_negborhood_app/models/enums/occupation_status.dart';
import 'package:smart_negborhood_app/generated/l10n.dart';
import '../../components/CustomDropdown.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_size.dart';
import '../../components/constants/small_text.dart';
import '../../components/custom_text_input_filed.dart';
import '../../models/Person.dart';
import '../../models/enums/identity_type.dart';

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
  late final TextEditingController identityNumberController;
  late final TextEditingController birthDateController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
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
    identityNumberController = TextEditingController(
      text: widget.person?.identityNumber ?? '',
    );
    final date =
        cubit.selectedDate ??
        widget.person?.dateOfBirth ??
        DateTime(2000, 1, 1);
    birthDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(date),
    );
    phoneNumberController = TextEditingController(
      text: widget.person?.phoneNumber ?? '',
    );
    emailController = TextEditingController(text: widget.person?.email ?? '');
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    thirdNameController.dispose();
    lastNameController.dispose();
    identityNumberController.dispose();
    birthDateController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonCubit>();
    return BlocListener<PersonCubit, PersonState>(
      listener: (context, state) {
        if (state is PersonAddedSuccessfully) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context);
        } else if (state is PersonFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
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
                  ? S.of(context).addNewPerson
                  : S.of(context).editPersonData,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SmallText(text: S.of(context).firstName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).firstNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).secondName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: secondNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).secondNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).thirdName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: thirdNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).thirdNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).fourthName),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).fourthNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).identityNumber),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: identityNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).identityNumberRequired;
                          }
                          if (value.length < 6) {
                            return S.of(context).identityNumberMinLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).identityType),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<PersonCubit, PersonState>(
                        buildWhen: (previous, current) =>
                            current is ChangeSelectedIdentityType,
                        builder: (context, state) {
                          return CustomDropdown(
                            items: IdentityType.values
                                .map((e) => e.arabicName)
                                .toList(),
                            selectedValue: context
                                .read<PersonCubit>()
                                .selectedIdentityType
                                ?.arabicName,
                            onChanged: (String? newValue) {
                              context
                                  .read<PersonCubit>()
                                  .changeSelectedIdentityType(
                                    IdentityType.values.firstWhere(
                                      (e) => e.arabicName == newValue,
                                    ),
                                  );
                            },
                            text: S.of(context).chooseIdentityType,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseChooseIdentityType;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      _buildGenderSelector(cubit),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).contactNumber),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: phoneNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'رقم التواصل مطلوب';
                                }
                                if (!RegExp(r'^[0-9]{8,}$').hasMatch(value)) {
                                  return 'رقم التواصل غير صحيح';
                                }
                                return null;
                              },
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
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'طريقة الإتصال'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<PersonCubit, PersonState>(
                        buildWhen: (previous, current) =>
                            current is ChangeContactType,
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const SmallText(text: 'اتصال'),
                                  Checkbox(
                                    value: cubit.isCall,
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (bool? value) {
                                      context
                                          .read<PersonCubit>()
                                          .toggleContactType(
                                            isCall: value,
                                            isWhatsapp: context
                                                .read<PersonCubit>()
                                                .isWhatsapp,
                                          );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: AppSize.spasingBetweenInputBloc,
                              ),
                              Row(
                                children: [
                                  const SmallText(text: 'واتس اب'),
                                  Checkbox(
                                    value: context
                                        .read<PersonCubit>()
                                        .isWhatsapp,
                                    activeColor: AppColor.primaryColor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        context
                                            .read<PersonCubit>()
                                            .toggleContactType(
                                              isWhatsapp: value,
                                              isCall: context
                                                  .read<PersonCubit>()
                                                  .isCall,
                                            );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      const SmallText(text: 'الإيميل'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: emailController,
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          const Icon(
                            Icons.email,
                            color: AppColor.primaryColor,
                            size: 30,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'تاريخ الميلاد مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),
                      SmallText(text: S.of(context).bloodType),
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
                            text: S.of(context).chooseBloodType,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseChooseBloodType;
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
                              crossAxisAlignment: CrossAxisAlignment.end,
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
        bottomNavigationBar: const CustomNavigationBar(),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SmallText(text: S.of(context).gender),
        const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
        BlocBuilder<PersonCubit, PersonState>(
          buildWhen: (previous, current) => current is ChangeSelctedGender,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: Gender.male.arabicName,
                      groupValue: cubit.selectedGender,
                      onChanged: (value) {
                        cubit.changeSelctedGender(value!);
                      },
                    ),
                    SmallText(text: S.of(context).male),
                  ],
                ),
                const SizedBox(width: 30),
                Row(
                  children: [
                    Radio<String>(
                      value: Gender.female.arabicName,
                      groupValue: cubit.selectedGender,
                      onChanged: (value) {
                        cubit.changeSelctedGender(value!);
                      },
                    ),
                    SmallText(text: S.of(context).female),
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
          text: 'إلغاء',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 10),
        SmallButton(
          text: widget.person == null ? 'إضافة' : 'تعديل',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.person == null) {
                cubit.addNewPerson(
                  firstName: firstNameController.text,
                  secondName: secondNameController.text,
                  thirdName: thirdNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneNumberController.text,
                  identityNumber: identityNumberController.text,
                  email: emailController.text,
                );
              } else {
                cubit.updatePerson(
                  id: widget.person!.id,
                  firstName: firstNameController.text,
                  secondName: secondNameController.text,
                  thirdName: thirdNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneNumberController.text,
                  identityNumber: identityNumberController.text,
                  email: emailController.text,
                );
                Navigator.pop(context);
              }
            }
          },
        ),
      ],
    );
  }
}
