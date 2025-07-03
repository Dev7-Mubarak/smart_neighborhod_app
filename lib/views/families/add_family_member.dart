import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/CustomDropdown.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import 'package:smart_negborhood_app/components/constants/small_text.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/cubits/member_family_role_cubit/member_family_role_cubit.dart';
import 'package:smart_negborhood_app/cubits/member_family_role_cubit/member_family_role_state.dart';
import 'package:smart_negborhood_app/models/member_family_role.dart';

class AddFamilyMember extends StatefulWidget {
  final int familyId;
  const AddFamilyMember({super.key, required this.familyId});

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final _formKey = GlobalKey<FormState>();

  late FamilyCubit familyCubit;
  late PersonCubit personCubit;

  Person? selectedPerson;
  String? selectedPersonName;
  MemberFamilyRole? selectedRole;

  bool _peopleLoaded = false;
  bool _rolesLoaded = false;

  @override
  void initState() {
    super.initState();
    familyCubit = context.read<FamilyCubit>();
    personCubit = context.read<PersonCubit>();
    _fetchPeopleOnce();
    _fetchRolesOnce();
  }

  void _fetchPeopleOnce() {
    if (!_peopleLoaded) {
      personCubit.getPeople();
      _peopleLoaded = true;
    }
  }

  void _fetchRolesOnce() {
    if (!_rolesLoaded) {
      context.read<MemberFamilyRoleCubit>().fetchRoles();
      _rolesLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FamilyCubit, FamilyState>(
          listener: (context, state) {
            if (state is FamilyMemberAddedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is FamilyFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Center(
            child: Text(
              'إضافة فرد للأسرة',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColor.gray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.gray),
                  ),
                  child: const Text(
                    'اختر شخص من القائمة وحدد دوره في الأسرة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // People Dropdown
                const SmallText(text: 'اختيار الشخص'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                BlocBuilder<PersonCubit, PersonState>(
                  builder: (context, state) {
                    if (state is PersonLoading && personCubit.people.isEmpty) {
                      return Container(
                        height: 56,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 12),
                            const Text('جاري تحميل الأشخاص...'),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: 'إعادة المحاولة',
                              onPressed: () {
                                setState(() {
                                  _peopleLoaded = false;
                                  _fetchPeopleOnce();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is PersonFailure) {
                      return Container(
                        height: 56,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'خطأ في تحميل الأشخاص: ${state.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: 'إعادة المحاولة',
                              onPressed: () {
                                setState(() {
                                  _peopleLoaded = false;
                                  _fetchPeopleOnce();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    final people = personCubit.people;
                    if (people.isEmpty) {
                      return Container(
                        height: 56,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'لا توجد أشخاص متاحة. يرجى إضافة أشخاص أولاً.',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: 'إعادة المحاولة',
                              onPressed: () {
                                setState(() {
                                  _peopleLoaded = false;
                                  _fetchPeopleOnce();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return DropdownSearch<Person>(
                      items: people,
                      selectedItem: selectedPerson,
                      itemAsString: (person) => person.fullName,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'اختر شخص من القائمة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? 'يرجى اختيار شخص' : null,
                      onChanged: (person) {
                        setState(() {
                          selectedPerson = person;
                          selectedPersonName = person?.fullName;
                        });
                      },
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(labelText: 'بحث'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Family Member Role Dropdown
                const SmallText(text: 'دور الفرد في الأسرة'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                BlocBuilder<MemberFamilyRoleCubit, MemberFamilyRoleState>(
                  builder: (context, roleState) {
                    if (roleState is MemberFamilyRoleLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Expanded(child: LinearProgressIndicator()),
                            const SizedBox(width: 12),
                            const Text('جاري تحميل الأدوار...'),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: 'إعادة المحاولة',
                              onPressed: () {
                                setState(() {
                                  _rolesLoaded = false;
                                  _fetchRolesOnce();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    if (roleState is MemberFamilyRoleFailure) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              'خطأ في تحميل الأدوار: ${roleState.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            tooltip: 'إعادة المحاولة',
                            onPressed: () {
                              setState(() {
                                _rolesLoaded = false;
                                _fetchRolesOnce();
                              });
                            },
                          ),
                        ],
                      );
                    }
                    if (roleState is MemberFamilyRoleLoaded) {
                      final roles = roleState.roles;
                      return CustomDropdown(
                        items: roles.map((r) => r.roleName).toList(),
                        selectedValue: selectedRole?.roleName,
                        onChanged: (roleName) {
                          setState(() {
                            selectedRole = roles.firstWhere(
                              (r) => r.roleName == roleName,
                            );
                          });
                        },
                        validator: (value) =>
                            value == null ? 'يرجى اختيار دور الفرد' : null,
                        text: 'اختر دور الفرد في الأسرة',
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 30),

                // Selected Person Info Card
                if (selectedPerson != null) ...[
                  const SmallText(text: 'معلومات الشخص المختار'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColor.gray,
                              child: Icon(
                                selectedPerson!.gender == "Female"
                                    ? Icons.female
                                    : Icons.male,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedPerson!.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'رقم الجوال: ${selectedPerson!.phoneNumber}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallButton(
                      text: 'إلغاء',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    SmallButton(
                      text: 'إضافة للأسرة',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          familyCubit.addExistingPersonToFamily(
                            familyId: widget.familyId,
                            personId: selectedPerson!.id,
                            roleId: selectedRole!.id,
                          );
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
    );
  }
}
