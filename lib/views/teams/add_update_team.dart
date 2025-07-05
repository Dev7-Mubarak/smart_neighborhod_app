import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_member.dart';

import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_size.dart';
import '../../components/constants/small_text.dart';
import '../../components/custom_text_input_filed.dart';
import '../../models/Person.dart';

class AddUpdateTeam extends StatefulWidget {
  const AddUpdateTeam({super.key, this.team});
  final Team? team;
  @override
  State<AddUpdateTeam> createState() => AddUpdateTeamState();
}

class AddUpdateTeamState extends State<AddUpdateTeam> {
  late final TextEditingController teamNameController;
  late final TextEditingController JoiedDateController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // int? _selectedPerson;
  int? _selectedPerson;

  late PersonCubit personCubit;
  late TeamCubit teamCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    teamCubit = context.read<TeamCubit>();
    DateTime? joineddate = null;
    if (widget.team != null) {
      _selectedPerson = teamCubit.selectedPersonId;

      joineddate = teamCubit.selectedJoiedDate;
    }
    teamNameController = TextEditingController(text: widget.team?.name ?? '');
    JoiedDateController = TextEditingController(
      text: joineddate != null
          ? DateFormat('yyyy-MM-dd').format(joineddate)
          : '',
    );
  }

  @override
  void dispose() {
    teamNameController.dispose();
    JoiedDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamCubit, TeamState>(
      listener: (context, state) {
        if (state is TeamAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is TeamUpdatedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is TeamFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ChangeSelectedJoiedDate) {
          JoiedDateController.text = teamCubit.selectedJoiedDate != null
              ? DateFormat('yyyy-MM-dd').format(teamCubit.selectedJoiedDate!)
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
                      widget.team == null ? 'إضافة فريق جديد' : 'تعديل فريق ',
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
                        const SmallText(text: 'أسم الفريق'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: teamNameController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'أسم الفريق';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(text: 'إختر قائد الفريق '),
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
                              if (_selectedPerson != null) {
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
                                  teamCubit.changeSelectedManager(data?.id);
                                },
                                selectedItem: initialSelectedPerson,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر قائد",
                                    hintText: "اختر قائد",
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
                                    return "الرجاء اختيار قائد الفريق";
                                  }
                                  return null;
                                },
                                enabled: widget.team == null
                                    ? true
                                    : false,
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
                          onTap: () => teamCubit.pickDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء قم بإدخال تاريخ إنضمام قائد الفريق';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<TeamCubit, TeamState>(
                        builder: (context, state) {
                          return SmallButton(
                            text: 'إلغاء',
                            onPressed: () {
                              Navigator.pop(context);
                              teamCubit.resetInputs();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      SmallButton(
                        text: widget.team == null ? 'إضافة' : 'تعديل',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.team == null) {
                              teamCubit.addNewTeam(teamNameController.text);
                            } else {
                              teamCubit.updateTeams(
                                id: widget.team!.id,
                                name: teamNameController.text,
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
