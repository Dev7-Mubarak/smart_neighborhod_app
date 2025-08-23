import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/features/annoucements/cubits/assistances/assistances_cubit.dart';
import 'package:smart_negborhood_app/features/annoucements/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/features/people/cubits/project_category/project_category_cubit.dart';
import 'package:smart_negborhood_app/features/people/cubits/project_category/project_category_state.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project_catgory.dart';

import '../../../../core/common/widgets/CustomDropdown.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';
import '../../../../core/common/enums/project_priority.dart';
import '../../../../core/common/enums/project_status.dart';
// import '../../services/DateHelper.dart';

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
    // final startdate = assistanceCubit.selectedStartDate ??
    //     DateTime(2000, 1, 1);
    // startDateController =
    //     TextEditingController(text: DateFormat('yyyy-MM-dd').format(startdate));
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PopScope(
              canPop: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is AssistancAddedSuccessfully ||
            state is AssistanceUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message = (state is AssistancAddedSuccessfully)
              ? state.message
              : (state as AssistanceUpdatedSuccessfully).message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );
          // }
          //   else if (state is AssistancAddedSuccessfully) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.message),
          //       backgroundColor: Colors.green,
          //     ),
          //   );
          //   Navigator.pop(context);
          // } else if (state is AssistanceUpdatedSuccessfully) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.message),
          //       backgroundColor: Colors.green,
          //     ),
          //   );
          //   Navigator.pop(context);
        } else if (state is AssistancesFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
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
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.white,
          elevation: 0,
          // iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              assistanceCubit.project == null
                  ? 'إضافة مشروع توزيع مساعدات جديد'
                  : 'تعديل مشروع توزيع المساعدات',
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
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),
                        const SmallText(text: 'أسم المشروع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: assistanceNameController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'أسم المشروع';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: 'وصف المشروع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: assistanceDescribtionController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          maxLines: null,
                          minLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'وصف المشروع';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: 'تصنيف المشروع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        BlocBuilder<ProjectCategoryCubit, ProjectCategoryState>(
                          // buildWhen: (previous, current) =>
                          //     current is ProjectCategoryLoaded,
                          builder: (context, state) {
                            if (state is ProjectCategoryLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is ProjectCategoryLoaded) {
                              if (state.projectCategories.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد تصنيفات متاحة'),
                                );
                              }
                              _selectedProjectCategory = state.projectCategories
                                  .firstWhere(
                                    (element) => element.name == "مساعدات",
                                  );
                              if (assistanceCubit.selectedProjectCategory ==
                                      null &&
                                  _selectedProjectCategory != null) {
                                assistanceCubit.changeSelectedProjectCategory(
                                  _selectedProjectCategory,
                                );
                              }
                              // _selectedProjectCategory = widget
                              //         .assistancProject?.projectCategory ??
                              //     state.projectCategories.firstWhere(
                              //         (element) => element.name == "مساعدات",
                              //         orElse: () => state
                              //             .projectCategories.first); // fallback
                              return DropdownSearch<ProjectCategory>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "ابحث عن تصنيف...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // textDirection: TextDirection.rtl,
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder:
                                      (context, projectCategory, isSelected) {
                                        return ListTile(
                                          title: Text(projectCategory.name),
                                          selected: isSelected,
                                        );
                                      },
                                  fit: FlexFit.loose,
                                ),
                                items: state.projectCategories,
                                itemAsString: (ProjectCategory? u) =>
                                    u?.name ?? '',
                                onChanged: null,
                                //  (ProjectCategory? data) {
                                //   assistanceCubit
                                //       .changeSelectedProjectCategory(data);
                                // },
                                selectedItem: _selectedProjectCategory,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر تصنيف",
                                    hintText: "اختر تصنيف",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                validator: (ProjectCategory? item) {
                                  if (item == null) {
                                    return "الرجاء اختيار تصنيف المشروع";
                                  }
                                  return null;
                                },
                                enabled: false,
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: 'اسم المدير'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
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
                                initialSelectedPerson = state.people.firstWhere(
                                  (person) => person.id == _selectedPerson,
                                );
                              }
                              // if (_selectedPerson == null &&
                              //     state.people.isNotEmpty) {
                              //   _selectedPerson = state.people.first;
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
                                    // textDirection: TextDirection.rtl,
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (context, person, isSelected) {
                                    return ListTile(
                                      title: Text(
                                        person.fullName,
                                        // textDirection: TextDirection.rtl,
                                      ),
                                      selected: isSelected,
                                    );
                                  },
                                  fit: FlexFit.loose,
                                ),
                                items: state.people,
                                itemAsString: (Person? u) => u?.fullName ?? '',
                                // onChanged: (Person? data) {
                                //   assistanceCubit.changeSelectedManager(data);
                                // },
                                onChanged: (Person? data) {
                                  assistanceCubit.changeSelectedManager(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedPerson,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر المدير",
                                    hintText: "اختر مدير",
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
                        const SizedBox(height: 30),
                        const SmallText(text: 'تاريخ بداية التوزيع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () async {
                        //         await DateTimeHelper.selectDate(
                        //             context, startDateController);
                        //       },
                        //       child: const Icon(
                        //         Icons.calendar_month,
                        //         color: AppColor.primaryColor,
                        //         size: 30,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10),
                        //     Expanded(
                        //       child: CustomTextFormField(
                        //         controller: startDateController,
                        //         keyboardType: TextInputType.none,
                        //         suffixIcon: null,
                        //         readOnly: true,
                        //         onTap: () async {
                        //           await DateTimeHelper.selectDate(
                        //               context, startDateController);
                        //         },
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return 'تاريخ  بداية التوزيع';
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // BlocBuilder<AssistancesCubit, AssistancesState>(
                        //   buildWhen: (previous, current) =>
                        //       current is ChangeSelectedStartDate,
                        //   builder: (context, state) {
                        //     startDateController.text =
                        //         assistanceCubit.selectedStartDate != null
                        //             ? DateFormat('yyyy-MM-dd').format(
                        //                 assistanceCubit.selectedStartDate!)
                        //             : '';

                        //     return CustomTextFormField(
                        //       controller: startDateController,
                        //       suffixIcon: Icons.calendar_today,
                        //       readOnly: true,
                        //       onTap: () =>
                        //           assistanceCubit.pickStartDate(context),
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'تاريخ بداية التوزيع';
                        //         }
                        //         return null;
                        //       },
                        //     );
                        //   },
                        // ),
                        CustomTextFormField(
                          controller: startDateController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => assistanceCubit.pickStartDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تاريخ بداية التوزيع';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: 'تاريخ نهاية التوزيع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),

                        CustomTextFormField(
                          controller: endDateController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => assistanceCubit.pickEndDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تاريخ نهايةالتوزيع';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: ' حالة المشروع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
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
                        const SizedBox(height: 30),
                        const SmallText(text: ' أولوية المشروع'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
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
                        const SizedBox(height: 20),
                        const SmallText(text: 'الميزانية'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: budgetController,
                          keyboardType: TextInputType.number,
                          suffixIcon: null,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الميزانية مطلوبة';
                            }
                            // التحقق مما إذا كانت القيمة تحتوي على أرقام فقط
                            if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                              return 'الرجاء إدخال أرقام فقط في حقل الميزانية';
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
                      BlocBuilder<AssistancesCubit, AssistancesState>(
                        builder: (context, state) {
                          return SmallButton(
                            text: 'إلغاء',
                            onPressed: () {
                              assistanceCubit.resetInputs();
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
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}
