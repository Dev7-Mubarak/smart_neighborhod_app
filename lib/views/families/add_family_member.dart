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
import 'package:smart_negborhood_app/cubits/person_cubit/person_state.dart';
import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/models/enums/family_member_role.dart';

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
  
  // Form state variables
  Person? selectedPerson;
  String? selectedPersonName;
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    familyCubit = context.read<FamilyCubit>();
    personCubit = context.read<PersonCubit>();
    
    // Load people when the page loads
    personCubit.getPeople();
    
    // Set default role
    selectedRole = FamilyMemberRoleExtension.getDisplayNames().first;
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
              Navigator.pop(context, true); // Return true to indicate success
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
                        child: const Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('جاري تحميل الأشخاص...'),
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
                        child: Text(
                          'خطأ في تحميل الأشخاص: ${state.errorMessage}',
                          style: const TextStyle(color: Colors.red),
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
                        child: const Text(
                          'لا توجد أشخاص متاحة. يرجى إضافة أشخاص أولاً.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      );
                    }

                    final peopleNames = people.map((person) => person.fullName).toList();

                    return CustomDropdown<String>(
                      items: peopleNames,
                      selectedValue: selectedPersonName,
                      onChanged: (personName) {
                        setState(() {
                          selectedPersonName = personName;
                          selectedPerson = people.firstWhere(
                            (person) => person.fullName == personName,
                          );
                        });
                      },
                      validator: (value) => value == null ? 'يرجى اختيار شخص' : null,
                      text: 'اختر شخص من القائمة',
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Family Member Role Dropdown
                const SmallText(text: 'دور الفرد في الأسرة'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomDropdown<String>(
                  items: FamilyMemberRoleExtension.getDisplayNames(),
                  selectedValue: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value),
                  validator: (value) => value == null ? 'يرجى اختيار دور الفرد' : null,
                  text: 'اختر دور الفرد في الأسرة',
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
                                selectedPerson!.gender == "Female" ? Icons.female : Icons.male,
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
                          final roleEnum = FamilyMemberRoleExtension.fromDisplayName(selectedRole!);
                          familyCubit.addExistingPersonToFamily(
                            familyId: widget.familyId,
                            personId: selectedPerson!.id,
                            role: roleEnum.toString().split('.').last,
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