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
import 'package:smart_negborhood_app/features/confilct/data/models/conflict_type.dart';
import 'package:smart_negborhood_app/features/people/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../people/data/models/Person.dart';

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
    DateTime? joineddate;
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
        if (state is WiateAddedUpdatedTeam) {
          context.showLoadingDialog();
        } else if (state is TeamAddedSuccessfully ||
            state is TeamUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message = (state is TeamAddedSuccessfully)
              ? state.message
              : (state as TeamUpdatedSuccessfully).message;
          context.showSuccessSnackBar(message);
        } else if (state is TeamFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is ChangeSelectedJoiedDate) {
          JoiedDateController.text = teamCubit.selectedJoiedDate != null
              ? DateFormat('yyyy-MM-dd').format(teamCubit.selectedJoiedDate!)
              : '';
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(color: Colors.black),
                            centerTitle: true,
          title: Text(
            widget.team == null ? 'إضافة فريق جديد' : 'تعديل فريق ',
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
                        // const SizedBox(height: 20),
                        const SmallText(text: 'أسم الفريق'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          bachgroundColor: AppColor.white,
                          controller: teamNameController,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          validator: AppValidator.validateEmptyField,
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const SmallText(text: 'إختر قائد الفريق '),
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
                              if (_selectedPerson != null) {
                                initialSelectedPerson = state.people.firstWhere(
                                  (person) => person.id == _selectedPerson,
                                );
                              }
                              return
                               CustomDropdownSearchWidget<Person>(
                                items: state.people,
                                itemAsString: (Person? u) => u?.fullName ?? '',
                                onChanged: (Person? data) {
                                  teamCubit.changeSelectedManager(data?.id);
                                },
                                selectedItem: initialSelectedPerson,
                                labelText: "اختر قائد",
                                hintText: "اختر قائد",
                                searchHintText: "ابحث عن قائد...",
                                validator: (Person? item) =>
                                    AppValidator.validateDropdown(item),
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
                          onTap: () => teamCubit.pickDate(context),
                          validator: AppValidator.validateEmptyField,
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
