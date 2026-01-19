import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/DropdownSearch.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_cubit.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/features/people/cubits/project_category/project_category_cubit.dart';
import 'package:smart_negborhood_app/features/people/cubits/project_category/project_category_state.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project_catgory.dart';

import '../../../../core/common/widgets/CustomDropdown.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';
import '../../../../core/common/enums/project_priority.dart';
import '../../../../core/common/enums/project_status.dart';

class AddUpdateAssistanc extends StatefulWidget {
  const AddUpdateAssistanc({super.key, this.assistancProject});
  final Project? assistancProject;
  @override
  State<AddUpdateAssistanc> createState() => AddUpdateAssistancState();
}

class AddUpdateAssistancState extends State<AddUpdateAssistanc> {
  late final TextEditingController assistanceNameController;
  late final TextEditingController assistanceDescribtionController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  late final TextEditingController budgetController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Person? _selectedPerson;
  int? _selectedPerson;

  ProjectCategory? _selectedProjectCategory;
  late PersonCubit personCubit;
  late AssistancesCubit assistanceCubit;
  late ProjectCategoryCubit projectCategory;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    assistanceCubit = context.read<AssistancesCubit>();
    projectCategory = context.read<ProjectCategoryCubit>()
      ..getProjectCategories();
    assistanceNameController = TextEditingController(
      text: widget.assistancProject?.name ?? '',
    );
    assistanceDescribtionController = TextEditingController(
      text: widget.assistancProject?.description ?? '',
    );
    budgetController = TextEditingController(
      text: (widget.assistancProject?.budget ?? 0).toString(),
    );
    final startdate =
        assistanceCubit.selectedStartDate ?? widget.assistancProject?.startDate;
    startDateController = TextEditingController(
      text: startdate != null ? DateFormat('yyyy-MM-dd').format(startdate) : '',
    );
    final endtdate =
        assistanceCubit.selectedEndDate ?? widget.assistancProject?.endDate;
    endDateController = TextEditingController(
      text: endtdate != null ? DateFormat('yyyy-MM-dd').format(endtdate) : '',
    );
    if (widget.assistancProject != null) {
      _selectedPerson = assistanceCubit.selectedManagerId;
      _selectedProjectCategory = assistanceCubit.selectedProjectCategory;
    } else {
      _selectedPerson = null;
    }
  }

  @override
  void dispose() {
    assistanceNameController.dispose();
    assistanceDescribtionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssistancesCubit, AssistancesState>(
      listener: (context, state) {
        if (state is WiateAddedUpdatedassistance) {
          context.showLoadingDialog();
        } else if (state is AssistancAddedSuccessfully ||
            state is AssistanceUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message = (state is AssistancAddedSuccessfully)
              ? state.message
              : (state as AssistanceUpdatedSuccessfully).message;
          context.showSuccessSnackBar(message);
        } else if (state is AssistancesFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is ChangeSelectedStartDate) {
          startDateController.text = startDateController.text =
              assistanceCubit.selectedStartDate != null
              ? DateFormat(
                  'yyyy-MM-dd',
                ).format(assistanceCubit.selectedStartDate!)
              : '';
        } else if (state is ChangeSelectedEndDate) {
          endDateController.text = endDateController.text =
              assistanceCubit.selectedEndDate != null
              ? DateFormat(
                  'yyyy-MM-dd',
                ).format(assistanceCubit.selectedEndDate!)
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
            assistanceCubit.project == null
                ? 'إضافة مشروع توزيع مساعدات '
                : 'تعديل مشروع توزيع المساعدات',
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
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmallText(text: 'أسم المشروع'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: assistanceNameController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'وصف المشروع'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: assistanceDescribtionController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          maxLines: null,
                          minLines: 3,
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<ProjectCategoryCubit, ProjectCategoryState>(
                          builder: (context, state) {
                            if (state is ProjectCategoryLoaded) {
                              final matches = state.projectCategories
                                  .where((e) => e.name == "مساعدات")
                                  .toList();
                              if (matches.isNotEmpty) {
                                _selectedProjectCategory = matches.first;
                                if (assistanceCubit.selectedProjectCategory ==
                                    null) {
                                  assistanceCubit.changeSelectedProjectCategory(
                                    _selectedProjectCategory,
                                  );
                                }
                              } else {
                                _selectedProjectCategory = null;
                              }
                              return SizedBox();
                            }
                            return SizedBox();
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'اسم المدير'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
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
                              if (_selectedPerson != null) {
                                final matches = state.people
                                    .where(
                                      (person) => person.id == _selectedPerson,
                                    )
                                    .toList();
                                if (matches.isNotEmpty) {
                                  initialSelectedPerson = matches.first;
                                }
                              }
                              return CustomDropdownSearchWidget<Person>(
                                items: state.people,
                                itemAsString: (Person? u) => u?.fullName ?? '',
                                onChanged: (Person? data) {
                                  assistanceCubit.changeSelectedManager(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedPerson,
                                labelText: "اختر مدير",
                                hintText: "اختر مدير",
                                searchHintText: "ابحث عن مدير...",
                                validator: (Person? item) =>
                                    AppValidator.validateDropdown(item),
                              );
                            }
                            if (state is PersonFailure) {
                              return OnFailureWidget(
                                onRetry: personCubit.getPeople,
                              );
                            }
                            return Center(child: Text("حدث خطأ غير معروف"));
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'تاريخ بداية التوزيع'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          controller: startDateController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => assistanceCubit.pickStartDate(context),
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'تاريخ نهاية التوزيع'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          controller: endDateController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => assistanceCubit.pickEndDate(context),
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: ' حالة المشروع'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<AssistancesCubit, AssistancesState>(
                          buildWhen: (previous, current) =>
                              current is ChangeSelectedProjectStatus,
                          builder: (context, state) {
                            return CustomDropdown(
                              items: ProjectStatus.values
                                  .map((e) => e.displayName)
                                  .toList(),
                              selectedValue: assistanceCubit
                                  .selectedProjectStatus
                                  ?.displayName,
                              onChanged: (String? newValue) {
                                assistanceCubit.changeSelectedProjectStatus(
                                  ProjectStatus.values.firstWhere(
                                    (e) => e.displayName == newValue,
                                  ),
                                );
                              },
                              text: 'اختيار حالة المشروع',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى اختيار حالة المشروع';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: ' أولوية المشروع'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<AssistancesCubit, AssistancesState>(
                          buildWhen: (previous, current) =>
                              current is ChangeSelectedProjectPriority,
                          builder: (context, state) {
                            return CustomDropdown(
                              items: ProjectPriority.values
                                  .map((e) => e.displayName)
                                  .toList(),
                              selectedValue: assistanceCubit
                                  .selectedProjectPriority
                                  ?.displayName,
                              onChanged: (String? newValue) {
                                assistanceCubit.changeSelectedProjectPriority(
                                  ProjectPriority.values.firstWhere(
                                    (e) => e.displayName == newValue,
                                  ),
                                );
                              },
                              text: 'اختيارأولوية المشروع',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى اختيار أولوية المشروع ';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'الميزانية'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: budgetController,
                          keyboardType: TextInputType.number,
                          suffixIcon: null,
                          validator: AppValidator.validatebudget,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<AssistancesCubit, AssistancesState>(
                        builder: (context, state) {
                          return SmallButton(
                            text: 'إلغاء',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      SmallButton(
                        text: assistanceCubit.project == null
                            ? 'إضافة'
                            : 'تعديل',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (assistanceCubit.project == null) {
                              assistanceCubit.addNewAssistances(
                                assistanceNameController.text,
                                assistanceDescribtionController.text,
                                int.parse(budgetController.text),
                              );
                            } else {
                              assistanceCubit.updateAssistances(
                                id: widget.assistancProject!.id,
                                name: assistanceNameController.text,
                                description:
                                    assistanceDescribtionController.text,
                                budget: int.parse(budgetController.text),
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
}
