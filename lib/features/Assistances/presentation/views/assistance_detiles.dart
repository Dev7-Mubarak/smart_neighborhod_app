import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/ProjectBlockFamilies.dart';
import 'package:smart_negborhood_app/core/common/enums/project_priority.dart';
import 'package:smart_negborhood_app/core/common/enums/project_status.dart';
import 'package:smart_negborhood_app/features/families/data/models/family.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/common/widgets/table.dart';
import '../../cubits/assistances/assistances_cubit.dart';

class AssistanceDetiles extends StatefulWidget {
  const AssistanceDetiles({super.key, required this.project});
  final Project project;

  @override
  State<AssistanceDetiles> createState() => _AssistanceDetilesState();
}

class _AssistanceDetilesState extends State<AssistanceDetiles> {
  late AssistancesCubit _assistancesCubit;
  List<Team> _teamsList = [];
  List<ProjectBlockFamilies> _blockFamiliesList = [];

  @override
  void initState() {
    super.initState();
    _assistancesCubit = context.read<AssistancesCubit>()
      ..getProjectTeams(id: widget.project.id)
      ..getProjectBlockFamilies(id: widget.project.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssistancesCubit, AssistancesState>(
      listener: (context, state) {
        if (state is FamilyDeletedSuccessfully ||
            state is TeamDeletedSuccessfully) {
          Navigator.of(context).pop();
          context.showSuccessSnackBar(
            (state is FamilyDeletedSuccessfully)
                ? state.message
                : (state as TeamDeletedSuccessfully).message,
          );
        } else if (state is DeleteFamilyFailure || state is DeleteTeamFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(
            (state is DeleteFamilyFailure)
                ? state.errorMessage
                : (state as DeleteTeamFailure).errorMessage,
          );
        } else if (state is WiateDeleteTeam || state is WiateDeleteFamily) {
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
          title: const Text(
            ' المساعدات',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    widget.project.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ProjectDetilesCard(projectDetiles: widget.project),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Divider(),
                ),
                Center(
                  child: Text(
                    "فرق التوزيع",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                BlocBuilder<AssistancesCubit, AssistancesState>(
                  buildWhen: (previous, current) {
                    return current is TeamsLoaded ||
                        current is ProjectTeamsLoading ||
                        current is ProjectTeamsFailure;
                  },
                  builder: (context, state) {
                    if (state is TeamsLoaded) {
                      _teamsList = state.teams;
                      if (_teamsList.isEmpty) {
                        return NoResultWidget();
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _teamsList.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          var team = _teamsList[index];
                          var teamMembers = team.teamMembers;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onLongPress: () {
                                  _showTeamOptions(context, team);
                                },
                                onTap: () {},
                                child: Text(
                                  "إسم الفريق: ${team.name}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              CustomTableWidget(
                                columnTitles: [
                                  'رقم',
                                  'اسم العضو ',
                                  'تاريخ انضمامه ',
                                  'وظيفته',
                                ],
                                columnFlexes: [1, 3, 2, 2],
                                rowData: teamMembers.asMap().entries.map((
                                  entry,
                                ) {
                                  int index = entry.key;
                                  var teamMember = entry.value;
                                  return [
                                    '${index + 1}',
                                    (teamMember.personName),
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(teamMember.dateOfJoin!),
                                    teamMember.teamRoleName,
                                  ];
                                }).toList(),
                                originalObjects: teamMembers,
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    } else if (state is ProjectTeamsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProjectTeamsFailure) {
                      return OnFailureWidget(
                        onRetry: () => _assistancesCubit.getProjectTeams(
                          id: widget.project.id,
                        ),
                      );
                    } else {
                      return Center(child: Text("حدث خطأ غير معروف"));
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SmallButton(
                      text: 'إضافة فريق',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.addTeamsToAssistance,
                          arguments: BlocProvider.of<AssistancesCubit>(context),
                          // ).then((_) {
                          //   _assistancesCubit.getProjectTeams(
                          //     id: widget.project.id,
                          //   );
                          // }
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Divider(),
                ),
                Center(
                  child: Text(
                    "المربعات السكنية و الأسر التي تم التوزيع لها",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                BlocBuilder<AssistancesCubit, AssistancesState>(
                  buildWhen: (previous, current) {
                    return current is BlockFamiliesLoaded ||
                        current is BlockFamiliesFailure ||
                        current is BlockFamiliesLoading;
                  },
                  builder: (context, state) {
                    if (state is BlockFamiliesLoaded) {
                      _blockFamiliesList = state.BlockFamilies;
                      if (_blockFamiliesList.isEmpty) {
                        return NoResultWidget();
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _blockFamiliesList.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          var block = _blockFamiliesList[index];
                          var families = block.families;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Text(
                                  "إسم المربع السكني: ${block.blockName}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              families.isNotEmpty
                                  ? CustomTableWidget(
                                      columnTitles: [
                                        'رقم',
                                        'اسم الأسرة ',
                                        'إسم رب الأسرة',
                                        'رقم الهوية',
                                      ],
                                      onRowLongPress: (rowIndex, rowObject) {
                                        _showFamilyOptions(
                                          context,
                                          rowObject as Family,
                                        );
                                      },
                                      columnFlexes: [1, 3, 2, 2],
                                      rowData: families.asMap().entries.map((
                                        entry,
                                      ) {
                                        int index = entry.key;
                                        var family = entry.value;
                                        return [
                                          '${index + 1}',
                                          family.name,
                                          family.familyHeadName,
                                          family.familyHeadPhoneNumber,
                                        ];
                                      }).toList(),
                                      originalObjects: families,
                                    )
                                  : Center(
                                      child: Text(
                                        "لا يوجد أُسر تم التوزيع لها في هذا المربع",
                                      ),
                                    ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SmallButton(
                                    text: 'إضافة أسرة',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoute.addFamilyToAssistance,
                                        arguments:
                                            BlocProvider.of<AssistancesCubit>(
                                              context,
                                            )..setBlockIdForAddFamily(
                                              block.blockId,
                                            ),
                                        // ).then((_) {
                                        //   _assistancesCubit.getProjectBlockFamilies(
                                        //     id: widget.project.id,
                                        //   );
                                        // }
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (state is BlockFamiliesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BlockFamiliesFailure) {
                      return OnFailureWidget(
                        onRetry: () => _assistancesCubit
                            .getProjectBlockFamilies(id: widget.project.id),
                      );
                    } else {
                      return Center(child: Text("حدث خطأ غير معروف"));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTeamOptions(BuildContext passContext, Team team) {
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
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف'),
              onTap: () async {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: passContext,
                  builder: (context) => AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content: const Text(
                      'هل أنت متأكد أنك تريد حذف هذا الفريق؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _assistancesCubit.deleteTeamFromeProject(team.id);
                          // _assistancesCubit.getProjectTeams(
                          //   id: widget.project.id,
                          // );
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

  void _showFamilyOptions(BuildContext passContext, Family family) {
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
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف'),
              onTap: () async {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: passContext,
                  builder: (context) => AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content: const Text('هل أنت متأكد أنك تريد حذف هذه الأسرة'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _assistancesCubit.deleteFamilyFromeProject(family.id);
                          // _assistancesCubit.getProjectBlockFamilies(
                          //   id: widget.project.id,
                          // );
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
              Text(
                'وصف: ${projectDetiles.description}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'تصنيف المشروع: ${projectDetiles.projectCategory.name}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'مدير المشروع:  ${projectDetiles.manager.fullName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'تريخ بداية التوزيع: ${DateFormat('yyyy-MM-dd').format(projectDetiles.startDate!)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'تريخ نهاية التوزيع: ${DateFormat('yyyy-MM-dd').format(projectDetiles.endDate!)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'حالة المشروع:  ${projectDetiles.projectStatus.displayName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'الميزانية: ${projectDetiles.budget}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'الأولوية: ${projectDetiles.projectPriority.displayName}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
