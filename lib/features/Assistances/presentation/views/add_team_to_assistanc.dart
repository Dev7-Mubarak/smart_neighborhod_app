import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/annoucements/cubits/assistances/assistances_cubit.dart';
import 'package:smart_negborhood_app/features/annoucements/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_cubit.dart';
import 'package:smart_negborhood_app/features/teams/cubits/team/team_state.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';

class AddTeamsToAssistance extends StatefulWidget {
  const AddTeamsToAssistance({super.key});
  @override
  State<AddTeamsToAssistance> createState() => AddTeamsToAssistanceState();
}

class AddTeamsToAssistanceState extends State<AddTeamsToAssistance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TeamCubit _teamsCubit;
  late AssistancesCubit _assistanceCubit;

  @override
  void initState() {
    super.initState();
    _teamsCubit = context.read<TeamCubit>()..getAllTeams();
    _assistanceCubit = context.read<AssistancesCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssistancesCubit, AssistancesState>(
      listener: (context, state) {
        if (state is WiateAssignTeamToAssistance) {
          context.showLoadingDialog();
        } else if (state is TeamAssignedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is AssistancesFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
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
              'إضافة فريق  لتوزيع المساعدات',
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
                        const SmallText(text: 'إختر فريق'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        BlocBuilder<TeamCubit, TeamState>(
                          builder: (context, state) {
                            if (state is TeamLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is TeamLoaded) {
                              if (state.allTeams.isEmpty) {
                                return const Center(child: Text('لا يوجد فرق'));
                              }
                              return DropdownSearch<Team>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "ابحث عن فريق...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // textDirection: TextDirection.rtl,
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (context, team, isSelected) {
                                    return ListTile(
                                      title: Text(
                                        team.name,
                                        // textDirection: TextDirection.rtl,
                                      ),
                                      selected: isSelected,
                                    );
                                  },
                                  fit: FlexFit.loose,
                                ),
                                items: state.allTeams,
                                itemAsString: (Team? u) => u?.name ?? '',
                                onChanged: (Team? data) {
                                  _assistanceCubit.changeSelectedTeam(data!.id);
                                },
                                // selectedItem: ,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر فريق",
                                    hintText: "اختر فريق",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                validator: (Team? item) {
                                  if (item == null) {
                                    return "الرجاء اختيار فريق ";
                                  }
                                  return null;
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 30),
                        const SmallText(
                          textAlign: TextAlign.right,
                          text:
                              'إذا كنت تريد إنشاء فريق جديد إنتقل إللى قسم الفرق من هنا',
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        SmallButton(
                          text: 'إضافة فريق جديد',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.addUpdateTeam,
                              arguments: BlocProvider.of<TeamCubit>(context),
                            ).then((_) {
                              _teamsCubit.getAllTeams();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<AssistancesCubit, AssistancesState>(
                        builder: (context, state) {
                          return SmallButton(
                            text: 'إلغاء',
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      SmallButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _assistanceCubit.assignTeamToAssistance();
                          }
                        },
                        text: 'إضافة',
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
