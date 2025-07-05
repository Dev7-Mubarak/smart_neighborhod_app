import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_image.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import 'package:smart_negborhood_app/components/table.dart';
import 'package:smart_negborhood_app/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/models/enums/project_status.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_member.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/small_text.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({super.key, required this.team});
  final Team team;
  @override
  State<TeamDetails> createState() => TeamDetailsState();
}

class TeamDetailsState extends State<TeamDetails> {
  late TeamCubit teamCubit;

  @override
  void initState() {
    super.initState();
    teamCubit = context.read<TeamCubit>()..getProjectsByTeamId(widget.team.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TeamMember? teamLeader = widget.team.teamMembers.firstWhereOrNull(
      (member) => member.teamRoleId == 1,
    );
    final teamLeaderName = teamLeader == null
        ? 'لا يوجد قائد'
        : teamLeader.personName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        title: Center(
          child: Text(
            'تفاصيل الفريق',
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
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text: "إسم الفريق: " + widget.team.name,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          AppImage.teamgroupName,
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text: "إسم قائد الفريق: " + teamLeaderName,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(
                          Icons.person,
                          color: AppColor.primaryColor,
                          size: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text:
                                "عدد أعضاء الفريق: " +
                                '${widget.team.teamMembers.length}',
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          AppImage.teamgroupNumBer,
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.spasingBetweenInputBloc),
              Text(
                ': أعضاء الفريق',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              CustomTableWidget(
                columnTitles: ['وظيفته', 'تاريخ انضمامه ', 'اسم العضو ', 'رقم'],
                columnFlexes: [2, 2, 3, 1],
                rowData: widget.team.teamMembers.asMap().entries.map((entry) {
                  int index = entry.key;
                  var teamMember = entry.value;
                  return [
                    teamMember.teamRoleName,
                    DateFormat('yyyy-MM-dd').format(teamMember.dateOfJoin!),
                    '${teamMember.personName}',
                    '${index + 1}',
                  ];
                }).toList(),
                originalObjects: widget.team.teamMembers,
                onRowLongPress: (rowIndex, rowObject) {},
              ),
                           SizedBox(height: AppSize.spasingBetweenInputBloc),

              Divider(),
              BlocBuilder<TeamCubit, TeamState>(
                builder: (context, state) {
                  if (state is TeamFailure) {
                    Center(child: Text(state.errorMessage));
                  }
                  if (state is ProjectsOfTeamLoaded) {
                    return Column(
                      children: [
                        Text(
                          ': المشاريع الذي يعمل فيها الفريق',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          // textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 10),
                        CustomTableWidget(
                          columnTitles: [
                            'حالته',
                            'تصنيف المشروع',
                            'اسم المشروع',
                            'رقم',
                          ],
                          columnFlexes: [2, 2, 3, 1],
                          rowData: state.allProjects.asMap().entries.map((
                            entry,
                          ) {
                            int index = entry.key;
                            var project = entry.value;
                            return [
                              project.projectStatus.displayName,
                              project.projectCategory.name,
                              project.name,
                              '${index + 1}',
                            ];
                          }).toList(),
                          originalObjects: null,
                          onRowLongPress: (rowIndex, rowObject) {},
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
