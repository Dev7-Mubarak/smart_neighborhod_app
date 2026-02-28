import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_cubit.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/common/enums/project_status.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/common/widgets/table.dart';

class AllAssistances extends StatefulWidget {
  const AllAssistances({super.key});

  @override
  State<AllAssistances> createState() => _AllAssistancesState();
}

class _AllAssistancesState extends State<AllAssistances> {
  List<Project> _projectsListSearch = [];
  late AssistancesCubit _assistancesCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  late final ProfileModel _profile;

  @override
  void initState() {
    super.initState();
    _assistancesCubit = context.read<AssistancesCubit>()..getAssistances();
    _searchingController = TextEditingController();
    _profile = SharedPreferencesService.getProfile()!;
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AssistancesCubit, AssistancesState>(
      buildWhen: (previousState, currentState) {
        return currentState is AssistancesLoaded ||
            currentState is AssistancesLoading ||
            currentState is AssistancesFailure;
      },
      builder: (context, state) {
        if (state is AssistancesLoaded) {
          _projectsListSearch = state.filteredProjects;
          if (_projectsListSearch.isEmpty) {
            return NoResultWidget();
          }
          return buildLoadedListWidgets();
        } else if (state is AssistancesLoading) {
          return showLoadingIndicator();
        } else if (state is AssistancesFailure) {
          return OnFailureWidget(
            onRetry: () => _assistancesCubit.getAssistances(),
          );
        } else {
          return Center(child: Text("حدث خطأ غير معروف"));
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل المساعدات...'),
        ],
      ),
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: CustomTableWidget(
        columnTitles: ['رقم', 'إسم المشروع', 'حالة المشروع'],
        columnFlexes: [1, 3, 2],
        rowData: _projectsListSearch.asMap().entries.map((entry) {
          int index = entry.key;
          var project = entry.value;
          return [
            '${index + 1}',
            project.name,
            project.projectStatus.displayName,
          ];
        }).toList(),
        originalObjects: _projectsListSearch,
        onRowLongPress: (rowIndex, rowObject) {
          if (_profile.role!.toLowerCase() ==
              AppRoles.admin.name.toLowerCase()) {
            _showOptions(context, rowObject as Project);
          }
        },
        onRowTap: (rowIndex) {
          Navigator.pushNamed(
            context,
            AppRoute.assistanceDetiles,
            arguments: BlocProvider.of<AssistancesCubit>(context)
              ..setAssistanceForDetiles(_projectsListSearch[rowIndex]),
          ).then((_) {
            _assistancesCubit.getAssistances(
              search: _searchingController.text.trim(),
            );
            _assistancesCubit.resetInputs();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssistancesCubit, AssistancesState>(
      listener: (context, state) {
        if (state is AssistancDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is DeleteAssistancesFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is WiatedeleteAssistance) {
          context.showLoadingDialog();
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
            'مشاريع توزيع المساعدات',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildToBar(context),
              const SizedBox(height: 20),
              Expanded(child: buildBlocWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_profile.role!.toLowerCase() == AppRoles.admin.name.toLowerCase())
          SmallButton(
            text: 'إضافة',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateAssistanc,
                arguments: BlocProvider.of<AssistancesCubit>(context),
              ).then((_) {
                _assistancesCubit.resetInputs();
                _assistancesCubit.getAssistances(
                  search: _searchingController.text.trim(),
                );
              });
            },
          ),
        const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
        Expanded(
          child: SearchableTextFormField(
            controller: _searchingController,
            hintText: 'ابحث عن مشروع مساعدات',
            bachgroundColor: AppColor.gray2,
            suffixIcon: IconButton(
              onPressed: () {
                _searchingController.clear();
                _assistancesCubit.filterProjects('');
              },
              icon: const Icon(Icons.close),
            ),
            prefixIcon: Icons.search,
            onChanged: (value) {
              _delay?.cancel();
              _delay = Timer(const Duration(milliseconds: 400), () {
                _assistancesCubit.filterProjects(value.trim());
              });
            },
          ),
        ),
      ],
    );
  }

  void _showOptions(BuildContext passContext, Project project) {
    showModalBottomSheet(
      context: passContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('تعديل'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdateAssistanc,
                  arguments: BlocProvider.of<AssistancesCubit>(passContext)
                    ..setAssistanceForUpdate(project),
                ).then((_) {
                  _assistancesCubit.resetInputs();
                  _assistancesCubit.getAssistances(
                    search: _searchingController.text.trim(),
                  );
                });
              },
            ),
            if (project.projectStatus != ProjectStatus.Completed)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('حذف'),
                onTap: () async {
                  Navigator.pop(context);
                  await showDialog<bool>(
                    context: passContext,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد الحذف'),
                      content: const Text(
                        'هل أنت متأكد أنك تريد حذف مشروع المساعدات هذا؟',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _assistancesCubit.deleteAssistance(project.id);
                          },
                          child: const Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
