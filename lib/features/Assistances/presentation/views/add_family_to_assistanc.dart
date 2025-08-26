import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_cubit.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';

import 'package:smart_negborhood_app/features/families/data/models/family.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';

class AddFamilyToAssistance extends StatefulWidget {
  const AddFamilyToAssistance({super.key});
  @override
  State<AddFamilyToAssistance> createState() => AddFamilyToAssistanceState();
}

class AddFamilyToAssistanceState extends State<AddFamilyToAssistance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late FamilyCubit _familyCubit;
  late AssistancesCubit _assistanceCubit;

  @override
  void initState() {
    super.initState();
    _familyCubit = context.read<FamilyCubit>()..getFamiliesByBlockId();
    _assistanceCubit = context.read<AssistancesCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssistancesCubit, AssistancesState>(
      listener: (context, state) {
        if (state is WiateAssignFamilyToAssistance) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PopScope(
              canPop: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is FamilyAssignedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AssistancesFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              'إضافة أسرة  لتوزيع المساعدات لها',
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
                        const SmallText(text: 'إختر اسرة'),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        BlocBuilder<FamilyCubit, FamilyState>(
                          builder: (context, state) {
                            if (state is FamilyLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is FamilyFailure) {
                              return Center(
                                child: Text(
                                  state.errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            if (state is FamilyLoaded) {
                              if (state.families.isEmpty) {
                                return const Center(child: Text('لا يوجد أسر'));
                              }
                              return DropdownSearch<Family>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: "ابحث عن أسرة...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // textDirection: TextDirection.rtl,
                                  ),
                                  menuProps: MenuProps(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  itemBuilder: (context, family, isSelected) {
                                    return ListTile(
                                      title: Text(
                                        family.name,
                                        // textDirection: TextDirection.rtl,
                                      ),
                                      selected: isSelected,
                                    );
                                  },
                                  fit: FlexFit.loose,
                                ),
                                items: state.families,
                                itemAsString: (Family? u) => u?.name ?? '',
                                onChanged: (Family? data) {
                                  _assistanceCubit.changeSelectedFamily(
                                    data!.id,
                                  );
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "اختر أسرة",
                                    hintText: "اختر أسرة",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                validator: (Family? item) {
                                  if (item == null) {
                                    return "الرجاء اختيار أسرة ";
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
                              'إذا كنت تريد إنشاء أسرة جديدة إنتقل الى قسم المربعات السكنية من هنا',
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        SmallButton(
                          text: 'إنشاء أسرة  جديد',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.addUpdateFamily,
                              arguments: BlocProvider.of<FamilyCubit>(context),
                            ).then((_) {
                              _familyCubit.getFamiliesByBlockId();
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
                            _assistanceCubit.assignFamilyToAssistance();
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
