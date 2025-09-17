import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/DropdownSearch.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_member/team_member_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_member/team_member_state.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_role/team_role_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team_role/team_role_state.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_role.dart';

import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';

class AddUpdateTeamMember extends StatefulWidget {
  const AddUpdateTeamMember({super.key, this.teamMember});
  final TeamMember? teamMember;
  @override
  State<AddUpdateTeamMember> createState() => AddUpdateTeamMemberState();
}

class AddUpdateTeamMemberState extends State<AddUpdateTeamMember> {
  late final TextEditingController JoiedDateController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPerson;
  int? _selectedTeamRole;
  late PersonCubit personCubit;
  // late TeamCubit teamCubit;
  late TeamMemberCubit teamMemberCubit;
  late TeamRoleCubit teamRoleCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    // teamCubit = context.read<TeamCubit>();
    teamMemberCubit = context.read<TeamMemberCubit>();
    teamRoleCubit = context.read<TeamRoleCubit>()..getAllTeamRoles();

    DateTime? joineddate;
    if (widget.teamMember != null) {
      _selectedPerson = teamMemberCubit.selectedPersonId;
      _selectedTeamRole = teamMemberCubit.selectedTeamRoleId;
      joineddate = teamMemberCubit.selectedJoiedDate;
    }
    JoiedDateController = TextEditingController(
      text: joineddate != null
          ? DateFormat('yyyy-MM-dd').format(joineddate)
          : '',
    );
  }

  @override
  void dispose() {
    JoiedDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamMemberCubit, TeamMemberState>(
      listener: (context, state) {
        if (state is WiateAddedUpdatedTeamMember) {
          context.showLoadingDialog();
        } else if (state is TeamMemberAddedSuccessfully ||
            state is TeamMemberUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message = (state is TeamMemberAddedSuccessfully)
              ? state.message
              : (state as TeamMemberUpdatedSuccessfully).message;
          context.showSuccessSnackBar(message);
        } else if (state is TeamMemberFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is ChangeSelectedMemberJoiedDate) {
          JoiedDateController.text = teamMemberCubit.selectedJoiedDate != null
              ? DateFormat(
                  'yyyy-MM-dd',
                ).format(teamMemberCubit.selectedJoiedDate!)
              : '';
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              widget.teamMember == null ? 'إضافة عضو جديد' : 'تعديل عضو ',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
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
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmallText(text: 'اسم العضو '),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<PersonCubit, PersonState>(
                          builder: (context, state) {
                            if (state is PersonLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is PersonLoaded) {
                              if (state.people.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد أشخاص متاحين'),
                                );
                              }
                              Person? initialSelectedPerson;
                              if (_selectedPerson != null &&
                                  widget.teamMember != null) {
                                initialSelectedPerson = state.people.firstWhere(
                                  (person) => person.id == _selectedPerson,
                                );
                              }
                              return CustomDropdownSearchWidget<Person>(
                                 enabled: widget.teamMember == null
                                    ? true
                                    : false,
                                items: state.people,
                                itemAsString: (Person? u) => u?.fullName ?? '',
                                onChanged: (Person? data) {
                                  teamMemberCubit.changeSelectedPerson(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedPerson,
                                labelText: "اختر عضو",
                                hintText: "اختر عضو",
                                searchHintText: "ابحث عن عضو...",
                                validator: (Person? item) =>
                                    AppValidator.validateDropdown(item)
                              );
                            } else if (state is PersonFailure) {
                              return OnFailureWidget(
                                onRetry: () => personCubit.getPeople(),
                              );
                            } else {
                              return Center(child: Text("حدث خطأ غير معروف"));
                            }
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'تاريخ انضمامه'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          controller: JoiedDateController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => teamMemberCubit.pickDate(context),
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'وظيفة العضو'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<TeamRoleCubit, TeamRoleState>(
                          builder: (context, state) {
                            if (state is TeamRoleLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is TeamRoleLoaded) {
                              if (state.allTeamRoles.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد أدوار متاحه '),
                                );
                              }
                              TeamRole? initialSelectedRole;
                              if (_selectedTeamRole != null &&
                                  widget.teamMember != null) {
                                initialSelectedRole = state.allTeamRoles
                                    .firstWhere(
                                      (teamRole) =>
                                          teamRole.id == _selectedTeamRole,
                                    );
                              }
                              return
                              CustomDropdownSearchWidget<TeamRole>(
                                items: state.allTeamRoles,
                                itemAsString:  (TeamRole? u) => u?.name ?? '',
                                onChanged: (TeamRole? data) {
                                  teamMemberCubit.changeSelectedTeamRole(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedRole,
                                labelText: "اختر دور",
                                hintText: "اختر دور",
                                searchHintText: "ابحث عن وظيفة...",
                                validator: (TeamRole? item) =>
                                    AppValidator.validateDropdown(item),
                              );
                              
                            } else if (state is TeamRoleFailure) {
                              return OnFailureWidget(
                                onRetry: () => teamRoleCubit.getAllTeamRoles(),
                              );
                            } else {
                              return Center(child: Text("حدث خطأ غير معروف"));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallButton(
                        text: 'إلغاء',
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      const SizedBox(width: 10),
                      SmallButton(
                        text: widget.teamMember == null ? 'إضافة' : 'تعديل',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.teamMember == null) {
                              teamMemberCubit.addNewTeamMember();
                            } else {
                              teamMemberCubit.updateTeamMember(
                                id: widget.teamMember!.teamMemberId,
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
