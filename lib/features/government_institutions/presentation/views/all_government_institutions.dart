import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/common/widgets/on_failure_widget.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_route.dart';
import '../../../../core/common/widgets/searcable_text_input_filed.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../cubits/government_institution/government_institution_cubit.dart';
import '../../cubits/government_institution/government_institution_state.dart';
import '../../cubits/government_institution_contact/government_institution_contact_cubit.dart';
import '../../cubits/government_institution_contact/government_institution_contact_state.dart';
import '../../data/models/government_institution.dart';
import '../../data/models/government_institution_contact.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/common/widgets/table.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../auth/data/models/login_model.dart';

class AllGovernmentInstitutions extends StatefulWidget {
  const AllGovernmentInstitutions({super.key});

  @override
  State<AllGovernmentInstitutions> createState() =>
      _AllGovernmentInstitutionsState();
}

class _AllGovernmentInstitutionsState extends State<AllGovernmentInstitutions> {
  List<GovernmentInstitution> _institutionsListDisplay = [];
  late GovernmentInstitutionCubit _institutionCubit;
  late GovernmentInstitutionContactCubit _contactCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  late final ProfileModel _profile;

  @override
  void initState() {
    super.initState();
    _institutionCubit = context.read<GovernmentInstitutionCubit>()
      ..getAllGovernmentInstitutions();
    _contactCubit = context.read<GovernmentInstitutionContactCubit>();
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
        BlocListener<GovernmentInstitutionCubit, GovernmentInstitutionState>(
          listener: (context, state) {
            if (state is GovernmentInstitutionDeletedSuccessfully) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSuccessSnackBar(state.message);
            } else if (state is DeleteGovernmentInstitutionFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showErrorSnackBar(state.errorMessage);
            } else if (state is WaitDeleteGovernmentInstitution) {
              context.showLoadingDialog();
            }
          },
        ),
        BlocListener<
          GovernmentInstitutionContactCubit,
          GovernmentInstitutionContactState
        >(
          listener: (context, state) {
            if (state is GovernmentInstitutionContactDeletedSuccessfully) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSuccessSnackBar("تم حذف جهة الاتصال بنجاح");
              _institutionCubit.getAllGovernmentInstitutions();
            } else if (state is DeleteGovernmentInstitutionContactFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showErrorSnackBar(state.errorMessage);
            } else if (state is WaitDeleteGovernmentInstitutionContact) {
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
            'الجهات الحكومية',
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
              Expanded(
                child:
                    BlocBuilder<
                      GovernmentInstitutionCubit,
                      GovernmentInstitutionState
                    >(
                      buildWhen: (previousState, currentState) {
                        return currentState is GovernmentInstitutionLoading ||
                            currentState is GovernmentInstitutionLoaded ||
                            currentState is GovernmentInstitutionFailure;
                      },
                      builder: (context, state) {
                        if (state is GovernmentInstitutionLoaded) {
                          _institutionsListDisplay =
                              state.filteredGovernmentInstitutions;
                          if (_institutionsListDisplay.isEmpty) {
                            return NoResultWidget();
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: _institutionsListDisplay.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              var institution = _institutionsListDisplay[index];
                              var contacts =
                                  institution.governmentInstitutionContacts;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onLongPress: () {
                                      if (_profile.role!.toLowerCase() ==
                                          AppRoles.admin.name.toLowerCase()) {
                                        _showInstitutionOptions(
                                          context,
                                          institution,
                                        );
                                      }
                                    },
                                    child: Text(
                                      "الجهة: ${institution.name}",
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
                                      'الاسم',
                                      'الوظيفة',
                                      'الهاتف',
                                    ],
                                    columnFlexes: [1, 3, 2, 2],
                                    rowData: contacts.asMap().entries.map((
                                      entry,
                                    ) {
                                      int index = entry.key;
                                      var contact = entry.value;
                                      return [
                                        '${index + 1}',
                                        contact.name,
                                        contact.job,
                                        contact.phone,
                                      ];
                                    }).toList(),
                                    originalObjects: contacts,
                                    onRowLongPress: (rowIndex, rowObject) {
                                      if (_profile.role!.toLowerCase() ==
                                          AppRoles.admin.name.toLowerCase()) {
                                        _showContactOptions(
                                          context,
                                          rowObject
                                              as GovernmentInstitutionContact,
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
                                        text: 'إضافة جهة اتصال',
                                        onPressed: () {
                                          _contactCubit.resetInputs();
                                          _contactCubit
                                              .setGovernmentInstitutionId(
                                                institution.id,
                                              );
                                          Navigator.pushNamed(
                                            context,
                                            AppRoute
                                                .addUpdateGovernmentInstitutionContact,
                                            arguments:
                                                BlocProvider.of<
                                                  GovernmentInstitutionContactCubit
                                                >(context),
                                          ).then((_) {
                                            _institutionCubit
                                                .getAllGovernmentInstitutions(
                                                  search: _searchingController
                                                      .text
                                                      .trim(),
                                                );
                                          });
                                        },
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          );
                        } else if (state is GovernmentInstitutionLoading) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('جاري تحميل الجهات...'),
                              ],
                            ),
                          );
                        } else if (state is GovernmentInstitutionFailure) {
                          return OnFailureWidget(
                            onRetry: () => _institutionCubit
                                .getAllGovernmentInstitutions(),
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
            text: 'إضافة جهة',
            onPressed: () {
              _institutionCubit.resetInputs();
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateGovernmentInstitution,
                arguments: BlocProvider.of<GovernmentInstitutionCubit>(context),
              ).then((_) {
                _institutionCubit.getAllGovernmentInstitutions(
                  search: _searchingController.text.trim(),
                );
              });
            },
          ),
        const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
        Expanded(
          child: SearchableTextFormField(
            controller: _searchingController,
            hintText: 'ابحث عن اسم الجهة',
            bachgroundColor: AppColor.gray2,
            suffixIcon: IconButton(
              onPressed: () {
                _searchingController.clear();
                _institutionCubit.filterGovernmentInstitutions('');
              },
              icon: const Icon(Icons.close),
            ),
            prefixIcon: Icons.search,
            onChanged: (String query) {
              _delay?.cancel();
              _delay = Timer(const Duration(milliseconds: 300), () {
                _institutionCubit.filterGovernmentInstitutions(query.trim());
              });
            },
          ),
        ),
      ],
    );
  }

  void _showInstitutionOptions(
    BuildContext passContext,
    GovernmentInstitution institution,
  ) {
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
                final cubit = BlocProvider.of<GovernmentInstitutionCubit>(
                  passContext,
                );
                cubit.setInstitutionForUpdate(institution);
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdateGovernmentInstitution,
                  arguments: cubit,
                ).then((_) {
                  _institutionCubit.getAllGovernmentInstitutions(
                    search: _searchingController.text.trim(),
                  );
                  cubit.resetInputs();
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
                    content: const Text('هل أنت متأكد أنك تريد حذف هذه الجهة؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _institutionCubit.deleteGovernmentInstitution(
                            institution.id,
                          );
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

  void _showContactOptions(
    BuildContext passContext,
    GovernmentInstitutionContact contact,
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
                _contactCubit.setContactForUpdate(contact);
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdateGovernmentInstitutionContact,
                  arguments: BlocProvider.of<GovernmentInstitutionContactCubit>(
                    passContext,
                  ),
                ).then((_) {
                  _institutionCubit.getAllGovernmentInstitutions(
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
                      'هل أنت متأكد أنك تريد حذف جهة الاتصال هذه؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _contactCubit
                              .deleteGovernmentInstitutionContact(contact.id);
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
