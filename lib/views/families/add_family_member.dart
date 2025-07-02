import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_state.dart';
import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/views/people/add_update_person.dart';
import '../../components/CustomDropdown.dart';
import '../../components/custom_navigation_bar.dart';

class AddFamilyMember extends StatefulWidget {
  final int familyId;
  
  const AddFamilyMember({super.key, required this.familyId});

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  Person? selectedPerson;
  late PersonCubit personCubit;
  late FamilyCubit familyCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>();
    familyCubit = context.read<FamilyCubit>();
    
    // Load all people for selection
    personCubit.getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FamilyCubit, FamilyState>(
          listener: (context, state) {
            if (state is FamilyAddedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
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
        BlocListener<PersonCubit, PersonState>(
          listener: (context, state) {
            if (state is PersonAddedSuccessfully) {
              // After adding a new person, refresh the people list
              personCubit.getPeople();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم إضافة الشخص بنجاح. يمكنك الآن إضافته كعضو في الأسرة."),
                  backgroundColor: Colors.green,
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
        body: BlocBuilder<PersonCubit, PersonState>(
          builder: (context, state) {
            if (state is PersonLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is PersonLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppColor.gray,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'اختر شخصاً موجوداً أو أضف شخصاً جديداً',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          
                          if (state.people.isNotEmpty) ...[
                            const Text(
                              'اختيار من الأشخاص الموجودين:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            CustomDropdown(
                              items: state.people.map((person) => "${person.fullName} (ID: ${person.id})").toList(),
                              selectedValue: selectedPerson != null 
                                  ? "${selectedPerson!.fullName} (ID: ${selectedPerson!.id})" 
                                  : null,
                              onChanged: (String? value) {
                                if (value != null) {
                                  // Extract ID from the display string
                                  final idMatch = RegExp(r'\(ID: (\d+)\)').firstMatch(value);
                                  if (idMatch != null) {
                                    final personId = int.parse(idMatch.group(1)!);
                                    setState(() {
                                      selectedPerson = state.people.firstWhere(
                                        (person) => person.id == personId,
                                      );
                                    });
                                  }
                                }
                              },
                              text: 'اختر شخصاً',
                              validator: null,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            const Text(
                              'أو',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 20),
                          ] else ...[
                            const Text(
                              'لا توجد أشخاص في النظام. يمكنك إضافة شخص جديد:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          SmallButton(
                            text: 'إضافة شخص جديد',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddUpdatePerson(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmallButton(
                          text: 'إلغاء',
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        SmallButton(
                          text: 'إضافة كعضو',
                          onPressed: selectedPerson != null
                              ? () {
                                  familyCubit.addFamilyMember(
                                    widget.familyId,
                                    selectedPerson!.id,
                                  );
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('يرجى اختيار شخص أولاً'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            
            if (state is PersonFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'حدث خطأ في تحميل البيانات: ${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    SmallButton(
                      text: 'إعادة المحاولة',
                      onPressed: () => personCubit.getPeople(),
                    ),
                  ],
                ),
              );
            }
            
            return const Center(
              child: Text('حدث خطأ في تحميل البيانات'),
            );
          },
        ),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}