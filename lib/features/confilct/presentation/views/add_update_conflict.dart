import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/DropdownSearch.dart';

import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_state.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflictType/conflict_type_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflictType/conflict_type_state.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_member/family_member_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_member/family_member_state.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict_type.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member2.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';

class AddUpdateConflict extends StatefulWidget {
  const AddUpdateConflict({super.key, this.conflict});
  final Conflict? conflict;
  @override
  State<AddUpdateConflict> createState() => AddUpdateConflictState();
}

class AddUpdateConflictState extends State<AddUpdateConflict> {
  late final TextEditingController conflictTitleController;
  late final TextEditingController conflictNoteController;
  late final TextEditingController conflictDateController;
  late ConflictCubit conflictCubit;
  late ConflictTypeCubit conflictTypeCubit;
  late FamilyMemberCubit familyMemberCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedFirstPart;
  int? _selectedSecondPart;
  int? _selectedConflictType;
  @override
  void initState() {
    super.initState();
    conflictCubit = context.read<ConflictCubit>();
    familyMemberCubit = context.read<FamilyMemberCubit>()..getFamilyMembers();
    conflictTypeCubit = context.read<ConflictTypeCubit>()
      ..getConflictTypeCubit();

    conflictTitleController = TextEditingController(
      text: widget.conflict?.title ?? '',
    );
    conflictNoteController = TextEditingController(
      text: widget.conflict?.notes ?? '',
    );
    final conflictdate =
        conflictCubit.sessionDate ?? widget.conflict?.sessionDate;
    conflictDateController = TextEditingController(
      text: conflictdate != null
          ? DateFormat('yyyy-MM-dd').format(conflictdate)
          : '',
    );

    if (widget.conflict != null) {
      _selectedFirstPart = conflictCubit.selectedfirstPartId;
      _selectedSecondPart = conflictCubit.selectedSecondPartId;
      _selectedConflictType = conflictCubit.selectedConflictTypeId;
    }
  }

  @override
  void dispose() {
    conflictTitleController.dispose();
    conflictDateController.dispose();
    conflictNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConflictCubit, ConflictState>(
      listener: (context, state) {
        if (state is WiateAddedUpdatedConflict) {
          context.showLoadingDialog();
        } else if (state is ConflictAddedSuccessfully ||
            state is ConflictUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message = (state is ConflictAddedSuccessfully)
              ? state.message
              : (state as ConflictUpdatedSuccessfully).message;
          context.showSuccessSnackBar(message);
        } else if (state is ConflictFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is ChangeSelectedSessionDate) {
          conflictDateController.text = conflictCubit.sessionDate != null
              ? DateFormat('yyyy-MM-dd').format(conflictCubit.sessionDate!)
              : '';
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            conflictCubit.conflict == null ? 'إضافة إتفاقية' : 'تعديل إتفاقية',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SmallText(text: 'عنوان الإتفاقية'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: conflictTitleController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'نوع الخلاف'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<ConflictTypeCubit, ConflictTypeState>(
                          builder: (context, state) {
                            if (state is ConflictTypeLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is ConflictTypeLoaded) {
                              if (state.conflictTypes.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد أنواع'),
                                );
                              }
                              ConflictType? initialSelectedConflictType;
                              if (_selectedConflictType != null) {
                                initialSelectedConflictType = state
                                    .conflictTypes
                                    .firstWhere(
                                      (conflictType) =>
                                          conflictType.id ==
                                          _selectedConflictType,
                                    );
                              }
                              return CustomDropdownSearchWidget<ConflictType>(
                                items: state.conflictTypes,
                                itemAsString: (ConflictType? u) =>
                                    u?.name ?? '',
                                onChanged: (ConflictType? data) {
                                  conflictCubit.changeSelectedConflictType(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedConflictType,
                                labelText: "اختر نوع الخلاف",
                                hintText: "اختر نوع الخلاف",
                                searchHintText: "ابحث عن نوع الخلاف...",
                                validator: (ConflictType? item) =>
                                    AppValidator.validateDropdown(item),
                              );
                            }
                            if (state is ConflictTypeFailure) {
                              return OnFailureWidget(
                                onRetry: () =>
                                    conflictTypeCubit.getConflictTypeCubit(),
                                errorMessage: state.errorMessage,
                              );
                            }
                            return Center(child: Text("حدث خطأ غير معروف"));
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'الملاحظات'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: conflictNoteController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          maxLines: null,
                          minLines: 3,
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'تاريخ الإتفاقية'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          controller: conflictDateController,
                          suffixIcon: Icons.calendar_today,
                          onsuffixIconPressed: () =>
                              conflictCubit.pickDate(context),
                          readOnly: true,
                          onTap: () => conflictCubit.pickDate(context),
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'الطرف الأول'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
                          builder: (context, state) {
                            if (state is FamilyMemberLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is FamilyMemberLoaded) {
                              if (state.familyMembers.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد أفراد متاحين'),
                                );
                              }
                              FamilyMember2? initialSelectedPerson;
                              if (_selectedFirstPart != null) {
                                initialSelectedPerson = state.familyMembers
                                    .firstWhere(
                                      (familyMember) =>
                                          familyMember.familyMemberId ==
                                          _selectedFirstPart,
                                    );
                              }
                              return CustomDropdownSearchWidget<FamilyMember2>(
                                items: state.familyMembers,
                                itemAsString: (FamilyMember2? u) =>
                                    u?.person.fullNameOneString ?? '',
                                onChanged: (FamilyMember2? data) {
                                  conflictCubit.changeSelectedFirstParty(
                                    data!.familyMemberId,
                                  );
                                },
                                labelText: "اختر الطرف الأول",
                                hintText: "اختر الطرف الأول",
                                searchHintText: "ابحث عن الطرف الأول...",
                                validator: (FamilyMember2? item) =>
                                    AppValidator.validateDropdown(item),
                                selectedItem: initialSelectedPerson,
                              );
                            }
                            if (state is FamilyMemberFailure) {
                              return OnFailureWidget(
                                onRetry: () =>
                                    conflictTypeCubit.getConflictTypeCubit(),
                                errorMessage: state.errorMessage,
                              );
                            }
                            return Center(child: Text("حدث خطأ غير معروف"));
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'الطرف الثاني'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
                          builder: (context, state) {
                            if (state is FamilyMemberLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is FamilyMemberFailure) {
                              Center(
                                child: Text(
                                  state.errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            if (state is FamilyMemberLoaded) {
                              if (state.familyMembers.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد أفراد متاحين'),
                                );
                              }
                              FamilyMember2? initialSelectedPerson2;
                              if (_selectedSecondPart != null) {
                                initialSelectedPerson2 = state.familyMembers
                                    .firstWhere(
                                      (familyMember) =>
                                          familyMember.familyMemberId ==
                                          _selectedSecondPart,
                                    );
                              }
                              return CustomDropdownSearchWidget<FamilyMember2>(
                                items: state.familyMembers,
                                itemAsString: (FamilyMember2? u) =>
                                    u?.person.fullNameOneString ?? '',
                                onChanged: (FamilyMember2? data) {
                                  conflictCubit.changeSelectedSecondParty(
                                    data!.familyMemberId,
                                  );
                                },
                                labelText: "اختر الطرف الثاني",
                                hintText: "اختر الطرف الثاني",
                                searchHintText: "ابحث عن الطرف الثاني...",
                                validator: (FamilyMember2? item) =>
                                    AppValidator.validateDropdown(item),
                                selectedItem: initialSelectedPerson2,
                              );
                            }
                            if (state is FamilyMemberFailure) {
                              return OnFailureWidget(
                                onRetry: () =>
                                    conflictTypeCubit.getConflictTypeCubit(),
                                errorMessage: state.errorMessage,
                              );
                            }
                            return Center(child: Text("حدث خطأ غير معروف"));
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        BlocBuilder<ConflictCubit, ConflictState>(
                          buildWhen: (previous, current) =>
                              current is ChangeIsResolved,
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SmallText(text: 'تم إنهاء الخلاف'),
                                Checkbox(
                                  value: conflictCubit.isResolved ?? false,
                                  activeColor: AppColor.primaryColor,
                                  onChanged: (bool? value) {
                                    conflictCubit.changeIsResolved(value);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        _buildImagePicker(context, conflictCubit),
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
                          // conflictCubit.resetInputs();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 10),
                      SmallButton(
                        text: conflictCubit.conflict == null
                            ? 'إضافة'
                            : 'تعديل',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (conflictCubit.conflict == null) {
                              conflictCubit.addConflict(
                                conflictNoteController.text,
                                conflictTitleController.text,
                              );
                            } else {
                              conflictCubit.updateConflict(
                                id: widget.conflict!.id,
                                title: conflictTitleController.text,
                                notes: conflictNoteController.text,
                              );
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
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context, ConflictCubit cubit) {
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
                  cubit.uplodeConflictPicture(picked);
                }
              },
              child: BlocBuilder<ConflictCubit, ConflictState>(
                buildWhen: (previous, current) =>
                    current is UplodeConflictPicture,
                builder: (context, state) {
                  if (cubit.conflictPicture != null) {
                    return CircleAvatar(
                      backgroundImage: FileImage(
                        File(cubit.conflictPicture!.path),
                      ),
                      radius: 48,
                    );
                  } else if (widget.conflict?.imageUrl != null &&
                      widget.conflict!.imageUrl.isNotEmpty) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(widget.conflict!.imageUrl),
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
}
