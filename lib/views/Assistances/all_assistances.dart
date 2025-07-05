import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/models/enums/project_priority.dart';
import 'package:smart_negborhood_app/models/project.dart';
import '../../components/constants/app_size.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/smallButton.dart';
import '../../components/table.dart';
import '../../cubits/assistances/assistances_cubit.dart';

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

  @override
  void initState() {
    super.initState();
    _assistancesCubit = context.read<AssistancesCubit>()..getAssistances();
    _searchingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AssistancesCubit, AssistancesState>(
      builder: (context, state) {
        if (state is AssistancesLoaded) {
          _projectsListSearch = state.filteredProjects;
          return buildLoadedListWidgets();
        } else if (state is AssistancesLoading) {
          return showLoadingIndicator();
        } else if (state is AssistancesFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else {
          return const Center(child: Text("لا توجد بيانات للعرض حاليًا."));
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListWidgets() {
    return CustomTableWidget(
      columnTitles: ['الأولوية', 'إسم المشروع', 'رقم'],
      columnFlexes: [2, 3, 1],
      rowData: _projectsListSearch.asMap().entries.map((entry) {
        int index = entry.key;
        var project = entry.value;
        return [
          project.projectPriority.displayName,
          project.name,
          '${index + 1}',
        ];
      }).toList(),
      originalObjects: _projectsListSearch,
      onRowLongPress: (rowIndex, rowObject) {
        _showOptions(context, rowObject as Project);
      },
      onRowTap: (rowIndex) {
        final project = _projectsListSearch[rowIndex];
        Navigator.pushNamed(
          context,
          AppRoute.assistanceDetiles,
          arguments: BlocProvider.of<AssistancesCubit>(context)
            ..setAssistanceForDetiles(project),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          ' المساعدات',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'مشاريع توزيع المساعدات',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildToBar(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: buildBlocWidget(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildToBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SmallButton(
            text: 'أضافة',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateAssistanc,
                arguments: BlocProvider.of<AssistancesCubit>(context),
              );
              // .then((_) {
              //     _assistancesCubit.filterProjects(
              //        _searchingController.text.trim(),
              //     );
              //   });
            },
          ),
          const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: 'ابحث عن مشروع مساعدات',
              bachgroundColor: AppColor.gray2,
              prefixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _assistancesCubit.filterProjects('');
                },
                icon: const Icon(Icons.close),
              ),
              suffixIcon: Icons.search,
              onChanged: (value) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 400), () {
                  _assistancesCubit.filterProjects(value.trim());
                });
              },
            ),
          ),
        ],
      ),
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
                );
                // .then((_) {
                //   _assistancesCubit.getAssistances(
                //     search: _searchingController.text.trim(),
                //   );
                // });
              },
            ),
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
