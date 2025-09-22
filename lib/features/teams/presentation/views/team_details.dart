// import 'package:collection/collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_image.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/common/widgets/table.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/core/common/enums/project_status.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/small_text.dart';

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
        centerTitle: true,
        title: Text(
          'تفاصيل الفريق',
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
                    Row(
                      children: [
                        Expanded(
                          child: SmallText(
                            text: "إسم الفريق: ${widget.team.name}",
                            textAlign: TextAlign.start,
                          ),
                        ),
                         SizedBox(width: 10),
                        //  SvgPicture.asset(
                        //   AppImage.teamgroupName,
                        //   width: 40,
                        //   height: 40,
                        //   fit: BoxFit.contain,
                        //     colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
                        // ),
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
                            text: "إسم قائد الفريق: $teamLeaderName",
                            textAlign: TextAlign.start,
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
                                "عدد أعضاء الفريق: "
                                '${widget.team.teamMembers.length}',
                            textAlign: TextAlign.start,
                          ),
                        ),
                         SizedBox(width: 10),
                        // SvgPicture.asset(
                        //   AppImage.teamgroupNumBer,
                        //   width: 40,
                        //   height: 40,
                        //   fit: BoxFit.contain,
                        //     colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
                        // ),
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
                'أعضاء الفريق:',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              CustomTableWidget(
                columnTitles: ['رقم', 'اسم العضو ', 'تاريخ انضمامه ', 'وظيفته'],
                columnFlexes: [1, 3, 2, 2],
                rowData: widget.team.teamMembers.asMap().entries.map((entry) {
                  int index = entry.key;
                  var teamMember = entry.value;
                  return [
                    '${index + 1}',
                    (teamMember.personName),
                    DateFormat('yyyy-MM-dd').format(teamMember.dateOfJoin!),
                    teamMember.teamRoleName,
                  ];
                }).toList(),
                originalObjects: widget.team.teamMembers,
                onRowLongPress: (rowIndex, rowObject) {},
              ),
              SizedBox(height: AppSize.spasingBetweenInputBloc),
              Divider(),
              Text(
                'المشاريع الذي يعمل فيها الفريق:',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<TeamCubit, TeamState>(
                builder: (context, state) {
                  if (state is TeamFailure) {
                    return OnFailureWidget(
                      onRetry: () =>
                          teamCubit.getProjectsByTeamId(widget.team.id),
                    );
                  }
                  if (state is ProjectsOfTeamLoaded) {
                    final _projects = state.allProjects;
                    if (_projects.isEmpty) {
                      return NoResultWidget();
                    }
                    return CustomTableWidget(
                      columnTitles: [
                        'رقم',
                        'اسم المشروع',
                        'تصنيف المشروع',
                        'حالته',
                      ],
                      columnFlexes: [2, 2, 3, 1],
                      rowData: state.allProjects.asMap().entries.map((entry) {
                        int index = entry.key;
                        var project = entry.value;
                        return [
                          '${index + 1}',
                          project.name,
                          project.projectCategory.name,
                          project.projectStatus.displayName,
                        ];
                      }).toList(),
                      originalObjects: null,
                      onRowLongPress: (rowIndex, rowObject) {},
                    );
                  } else if (state is TeamLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('جاري تحميل المشاريع...'),
                        ],
                      ),
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
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
