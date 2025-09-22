import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/common/widgets/DropdownSearch.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';

import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_cubit.dart';
import 'package:smart_negborhood_app/features/Assistances/cubits/assistances/assistances_state.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';

import 'package:smart_negborhood_app/features/families/data/models/family.dart';
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
          context.showLoadingDialog();
        } else if (state is FamilyAssignedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is AssistancesFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: AppColor.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            'إضافة أسرة  لتوزيع المساعدات لها',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSize.defaultPadding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColor.gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmallText(text: 'إختر اسرة'),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<FamilyCubit, FamilyState>(
                          builder: (context, state) {
                            if (state is FamilyLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is FamilyFailure) {
                              return OnFailureWidget(
                                onRetry: _familyCubit.getFamiliesByBlockId,
                              );
                            }
                            if (state is FamilyLoaded) {
                              if (state.families.isEmpty) {
                                return const Center(
                                  child: Text('لا يوجد أُسر'),
                                );
                              }
                              return CustomDropdownSearchWidget<Family>(
                                items: state.families,
                                itemAsString: (Family? u) => u?.name ?? '',
                                onChanged: (Family? data) {
                                  _assistanceCubit.changeSelectedFamily(
                                    data!.id,
                                  );
                                },
                                labelText: "اختر أسرة",
                                hintText: "اختر أسرة",
                                searchHintText: "ابحث عن أسرة...",
                                validator: (Family? item) =>
                                    AppValidator.validateDropdown(item),
                              );
                            }
                            return Center(child: Text("حدث خطأ غير معروف"));
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
      ),
    );
  }
}
