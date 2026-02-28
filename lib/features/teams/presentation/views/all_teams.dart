import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_member/team_member_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_member/team_member_state.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/common/widgets/table.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../auth/data/models/login_model.dart';

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
  late final ProfileModel _profile;

  @override
  void initState() {
    super.initState();
    _teamsCubit = context.read<TeamCubit>()..getAllTeams();
    _teamsMemberCubit = context.read<TeamMemberCubit>();
    _searchingController = TextEditingController();
    _profile = SharedPreferencesService.getProfile()!;
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TeamCubit, TeamState>(
          listener: (context, state) {
            if (state is TeamDeletedSuccessfully) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSuccessSnackBar(state.message);
            } else if (state is DeleteTeamFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showErrorSnackBar(state.errorMessage);
            } else if (state is WiatedeleteTeam) {
              context.showLoadingDialog();
            }
          },
        ),
        BlocListener<TeamMemberCubit, TeamMemberState>(
          listener: (context, state) {
            if (state is TeamMemberDeletedSuccessfully) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSuccessSnackBar("تم حذف العضو بنجاح ");
            } else if (state is DeleteTeamMemberFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showErrorSnackBar(state.errorMessage);
            } else if (state is WiatedeleteTeamMember) {
              context.showLoadingDialog();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.white,
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
        body: Padding(
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildToBar(context),
              const SizedBox(height: 20),
              // Make the list take all remaining space and be scrollable
              Expanded(
                child: BlocBuilder<TeamCubit, TeamState>(
                  buildWhen: (previousState, currentState) {
                    return currentState is TeamLoading ||
                        currentState is TeamLoaded ||
                        currentState is TeamFailure;
                  },
                  builder: (context, state) {
                    if (state is TeamLoaded) {
                      _teamsListDisplay = state.filteredTeams;
                      if (_teamsListDisplay.isEmpty) {
                        return NoResultWidget();
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: _teamsListDisplay.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          var team = _teamsListDisplay[index];
                          var teamMembers = team.teamMembers;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onLongPress: () {
                                  final profile =
                                      SharedPreferencesService.getProfile();
                                  if (profile!.role!.toLowerCase() ==
                                      AppRoles.admin.name.toLowerCase()) {
                                    _showTeamOptions(context, team);
                                  }
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
                                  "إسم الفريق: ${team.name}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                onRowLongPress: (rowIndex, rowObject) {
                                  if (_profile.role!.toLowerCase() ==
                                      AppRoles.admin.name.toLowerCase()) {
                                    _showTeamMemberOptions(
                                      context,
                                      rowObject as TeamMember,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              if (_profile.role!.toLowerCase() ==
                                  AppRoles.admin.name.toLowerCase())
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SmallButton(
                                    text: 'إضافة عضو',
                                    onPressed: () {
                                      _teamsMemberCubit.setTeamId(team.id);
                                      Navigator.pushNamed(
                                        context,
                                        AppRoute.addUpdateTeamMember,
                                        arguments:
                                            BlocProvider.of<TeamMemberCubit>(
                                              context,
                                            ),
                                      ).then((_) {
                                        _teamsCubit.getAllTeams(
                                          search: _searchingController.text
                                              .trim(),
                                        );
                                        _teamsMemberCubit.resetInputs();
                                      });
                                    },
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    } else if (state is TeamLoading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('جاري تحميل الفرق...'),
                          ],
                        ),
                      );
                    } else if (state is TeamFailure) {
                      return OnFailureWidget(
                        onRetry: () => _teamsCubit.getAllTeams(),
                      );
                    } else {
                      return const Center(child: Text("حدث خطأ غير معروف"));
                    }
                  },
                ),
              ),
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
            text: 'إضافة فريق',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateTeam,
                arguments: BlocProvider.of<TeamCubit>(context),
              ).then((_) {
                _teamsCubit.getAllTeams(
                  search: _searchingController.text.trim(),
                );
                _teamsCubit.resetInputs();
              });
            },
          ),
        const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
        Expanded(
          child: SearchableTextFormField(
            controller: _searchingController,
            hintText: 'ابحث عن اسم الفريق',
            bachgroundColor: AppColor.gray2,
            suffixIcon: IconButton(
              onPressed: () {
                _searchingController.clear();
                _teamsCubit.filterTeams('');
              },
              icon: const Icon(Icons.close),
            ),
            prefixIcon: Icons.search,
            onChanged: (String query) {
              _delay?.cancel();
              _delay = Timer(const Duration(milliseconds: 300), () {
                _teamsCubit.filterTeams(query.trim());
              });
            },
          ),
        ),
      ],
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
                  _teamsCubit.resetInputs();
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

  void _showTeamMemberOptions(
    BuildContext passContext,
    TeamMember teamMember,
  ) async {
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
                  _teamsMemberCubit.resetInputs();
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
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _teamsMemberCubit.deleteTeamMember(
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
