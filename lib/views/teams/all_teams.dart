import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/cubits/team_member/team_member_cubit.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_member.dart';
import '../../components/constants/app_size.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/smallButton.dart';
import '../../components/table.dart';

class AllTeams extends StatefulWidget {
  const AllTeams({super.key});

  @override
  State<AllTeams> createState() => _AllTeamsState();
}

class _AllTeamsState extends State<AllTeams> {
  List<Team> _teamsListDisplay = [];
  late TeamCubit _teamsCubit;
  late TeamMemberCubit _teamsMemberCubit;
  late TextEditingController _searchingController;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _teamsCubit = context.read<TeamCubit>()..getAllTeams();
    _teamsMemberCubit = context.read<TeamMemberCubit>();
    _searchingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
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
          'الفرق',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildToBar(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: BlocBuilder<TeamCubit, TeamState>(
                builder: (context, state) {
                  if (state is TeamLoaded) {
                    _teamsListDisplay = state.filteredTeams;
                    if (_teamsListDisplay.isEmpty) {
                      return const Center(
                        child: Text("لا توجد فرق لعرضها حاليًا."),
                      );
                    }
                    return ListView.separated(
                      itemCount: _teamsListDisplay.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        var team = _teamsListDisplay[index];
                        var teamMembers = team.teamMembers;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onLongPress: () {
                                _showTeamOptions(context, team);
                              },
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.teamDetails,
                                  arguments: team,
                                ).then((_) {
                                  _teamsCubit.getAllTeams(
                                    search: _searchingController.text.trim(),
                                  );
                                });
                              },
                              child: Text(
                                "إسم الفريق: " + team.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                // textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomTableWidget(
                              columnTitles: [
                                'وظيفته',
                                'تاريخ انضمامه ',
                                'اسم العضو ',
                                'رقم',
                              ],
                              columnFlexes: [2, 2, 3, 1],
                              rowData: teamMembers.asMap().entries.map((entry) {
                                int index = entry.key;
                                var teamMember = entry.value;
                                return [
                                  teamMember.teamRoleName,
                                  DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(teamMember.dateOfJoin!),
                                  '${teamMember.personName}',
                                  '${index + 1}',
                                ];
                              }).toList(),
                              originalObjects: teamMembers,
                              onRowLongPress: (rowIndex, rowObject) {
                                _showTeamMemberOptions(
                                  context,
                                  rowObject as TeamMember,
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SmallButton(
                                text: '+',
                                onPressed: () {
                                  _teamsMemberCubit.setTeamId(team.id);
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.addUpdateTeamMember,
                                    arguments: BlocProvider.of<TeamMemberCubit>(
                                      context,
                                    ),
                                  ).then((_) {
                                    _teamsCubit.getAllTeams(
                                      search: _searchingController.text.trim(),
                                    );
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  } else if (state is TeamLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TeamFailure) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("لا توجد بيانات للعرض حاليًا."),
                    );
                  }
                },
              ),
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
                AppRoute.addUpdateTeam,
                arguments: BlocProvider.of<TeamCubit>(context),
              ).then((_) {
                _teamsCubit.getAllTeams(
                  search: _searchingController.text.trim(),
                );
              });
            },
          ),
          const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: 'ابحث عن اسم الفريق',
              bachgroundColor: AppColor.gray2,
              prefixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _teamsCubit.filterTeams('');
                },
                icon: const Icon(Icons.close),
              ),
              suffixIcon: Icons.search,
              onChanged: (String query) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 300), () {
                  _teamsCubit.filterTeams(query.trim());
                });
              },
            ),
          ),
        ],
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
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('تعديل'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdateTeam,
                  arguments: BlocProvider.of<TeamCubit>(passContext)
                    ..setTeamForUpdate(team),
                ).then((_) {
                  _teamsCubit.getAllTeams(
                    search: _searchingController.text.trim(),
                  );
                });
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
                          _teamsCubit.deleteTeam(team.id);
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

  void _showTeamMemberOptions(BuildContext passContext, TeamMember teamMember) {
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
                  AppRoute.addUpdateTeamMember,
                  arguments: BlocProvider.of<TeamMemberCubit>(passContext)
                    ..setTeamMemberForUpdate(teamMember),
                ).then((_) {
                  _teamsCubit.getAllTeams(
                    search: _searchingController.text.trim(),
                  );
                });
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
                    content: const Text('هل أنت متأكد أنك تريد حذف هذا العضو'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _teamsMemberCubit.deleteTeamMember(
                            teamMember.teamMemberId,
                          );
                          _teamsCubit.getAllTeams();
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
