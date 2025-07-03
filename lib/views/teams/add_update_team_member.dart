import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/cubits/team_member/team_member_cubit.dart';
import 'package:smart_negborhood_app/cubits/team_member/team_member_state.dart';
import 'package:smart_negborhood_app/cubits/team_role/team_role_cubit.dart';
import 'package:smart_negborhood_app/cubits/team_role/team_role_state.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_member.dart';
import 'package:smart_negborhood_app/models/team_role.dart';

import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_size.dart';
import '../../components/constants/small_text.dart';
import '../../components/custom_text_input_filed.dart';
import '../../models/Person.dart';

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

    DateTime? joineddate = null;
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
        if (state is TeamMemberAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is TeamMemberUpdatedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is TeamMemberFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
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
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.white,
          elevation: 0,
          // iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              'فريق',
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
                  Center(
                    child: Text(
                      widget.teamMember == null
                          ? 'إضافة عضو جديد'
                          : 'تعديل عضو ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
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
                        const SmallText(text: 'اسم العضو '),
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
                              return DropdownSearch<Person>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "ابحث عن قائد...",
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
                                onChanged: (Person? data) {
                                  teamMemberCubit.changeSelectedPerson(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedPerson,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر عضو",
                                    hintText: "اختر عضو",
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
                                    return "الرجاء اختيار إسم العضو ";
                                  }
                                  return null;
                                },
                                enabled:widget.teamMember==null?true:false,
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: 'تاريخ انضمامه'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        CustomTextFormField(
                          controller: JoiedDateController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => teamMemberCubit.pickDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء قم بإدخال تاريخ إنضمام  العضو';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const SmallText(text: 'وظيفة العضو'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        BlocBuilder<TeamRoleCubit, TeamRoleState>(
                          builder: (context, state) {
                            if (state is TeamRoleLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is TeamRoleLoaded) {
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
                              return DropdownSearch<TeamRole>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "ابحث عن وظيفة...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // textDirection: TextDirection.rtl,
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (context, teamrole, isSelected) {
                                    return ListTile(
                                      title: Text(
                                        teamrole.name,
                                        // textDirection: TextDirection.rtl,
                                      ),
                                      selected: isSelected,
                                    );
                                  },
                                  fit: FlexFit.loose,
                                ),
                                items: state.allTeamRoles,
                                itemAsString: (TeamRole? u) => u?.name ?? '',
                                onChanged: (TeamRole? data) {
                                  teamMemberCubit.changeSelectedTeamRole(
                                    data!.id,
                                  );
                                },
                                selectedItem: initialSelectedRole,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر دور",
                                    hintText: "اختر دور",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                validator: (TeamRole? item) {
                                  if (item == null) {
                                    return "الرجاء اختيار دور العضو ";
                                  }
                                  return null;
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<TeamMemberCubit, TeamMemberState>(
                        builder: (context, state) {
                          return SmallButton(
                            text: 'إلغاء',
                            onPressed: () {
                              Navigator.pop(context);
                              teamMemberCubit.resetInputs();
                            },
                          );
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
                              // Navigator.pop(context);
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
