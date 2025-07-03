import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/models/project.dart';

import '../../components/constants/app_image.dart';
import '../../components/constants/app_size.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/smallButton.dart';
import '../../components/table.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../cubits/assistances/assistances_cubit.dart';

class AssistanceDetiles extends StatefulWidget {
  const AssistanceDetiles({super.key, required this.project});
  final Project project;

  @override
  State<AssistanceDetiles> createState() => _AssistanceDetilesState();
}

class _AssistanceDetilesState extends State<AssistanceDetiles> {
  late AssistancesCubit _assistancesCubit;

  @override
  void initState() {
    super.initState();
    _assistancesCubit = context.read<AssistancesCubit>()..getAssistances();
  }

  // Widget buildBlocWidget() {
  //   return BlocBuilder<AssistancesCubit, AssistancesState>(
  //     builder: (context, state) {
  //       if (state is AssistancesLoaded) {
  //         _projectsList = state.allProjects;
  //         _projectsListSearch = _projectsList;
  //         return buildLoadedListWidgets();
  //       } else if (state is AssistancesLoading) {
  //         return showLoadingIndicator();
  //       } else if (state is AssistancesFailure) {
  //         return Center(
  //           child: Text(
  //             state.errorMessage,
  //             style: const TextStyle(color: Colors.red, fontSize: 18),
  //           ),
  //         );
  //       } else {
  //         return const Center(
  //           child: Text("لا توجد بيانات للعرض حاليًا."),
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget showLoadingIndicator() {
  //   return const Center(child: CircularProgressIndicator());
  // }

  // Widget buildLoadedListWidgets() {
  //   return CustomTableWidget(
  //     columnTitles: ['الأولوية', 'إسم المشروع', 'رقم'],
  //     columnFlexes: [2, 3, 1],
  //     rowData: _projectsListSearch.asMap().entries.map((entry) {
  //       int index = entry.key;
  //       var project = entry.value;
  //       return [project.projectPriority, project.name, '${index + 1}'];
  //     }).toList(),
  //     originalObjects: _projectsListSearch,
  //     onRowLongPress: (rowIndex, rowObject) {
  //       _showOptions(context, rowObject as Project);
  //     },
  //   );
  // }

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
          Center(
            child: Text(
              widget.project.name,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          const SizedBox(height: 20),
          ProjectDetilesCard(projectDetiles:widget.project),
           SmallButton(
            text: 'تعديل',
            onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoute.addUpdateAssistanc,
                    arguments: BlocProvider.of<AssistancesCubit>(context)
                      ..setAssistanceForUpdate(widget.project));
            },
          ),
          Center(
            child: Text(
              "فرق التوزيع",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          


          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15),
          //     child: buildBlocWidget(),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(),
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

                Navigator.pushNamed(context, AppRoute.addUpdateAssistanc,
                    arguments: BlocProvider.of<AssistancesCubit>(passContext)
                      ..setAssistanceForUpdate(project));
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
                        'هل أنت متأكد أنك تريد حذف مشروع المساعدات هذا؟'),
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
                        child: const Text('حذف',
                            style: TextStyle(color: Colors.red)),
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

class ProjectDetilesCard extends StatelessWidget {
  final Project projectDetiles;
  const ProjectDetilesCard({super.key, required this.projectDetiles});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Card(
        color: AppColor.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('وصف: ${projectDetiles.description}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                'تصنيف المشروع: ${projectDetiles.projectCategory.name}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'مدير المشروع:  ${projectDetiles.manager.fullName}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'تريخ بداية التوزيع: ${projectDetiles.startDate}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'تريخ نهاية التوزيع: ${projectDetiles.endDate}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'حالة المشروع:  ${projectDetiles.projectStatus}',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
               Text(
                'الميزانية: ${projectDetiles.budget}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
               Text(
                'الأولوية: ${projectDetiles.projectPriority}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
