import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/models/Person.dart';

import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../components/searcharea.dart';
import '../../components/smallButton.dart';
import '../../components/table.dart';
import '../../models/Assist.dart';
import '../../models/family_detiles_model.dart';

class FamilyDetiles extends StatefulWidget {
  const FamilyDetiles({super.key, required this.familyId});

  final int familyId;
  @override
  State<FamilyDetiles> createState() => _FamilyDetilesState();
}

class _FamilyDetilesState extends State<FamilyDetiles> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyCubit>().getFamilyDetilesById(widget.familyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'معلومات الأسرة',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: BlocBuilder<FamilyCubit, FamilyState>(
        builder: (context, state) {
          if (state is FamilyFailure) {
            Center(child: Text(state.errorMessage));
          }
          if (state is FamilyDetilesLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FamilyDetilesCard(familyDetiles: state.familyDetiles),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [SmallButton(text: 'تعديل', onPressed: () {})],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'أفراد الأسرة',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FamilyMembersSection(
                    familyMembers: state.familyDetiles.familyMembers,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SmallButton(text: 'إضافة فرد جديد', onPressed: () {}),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Divider(
                      color: Color.fromARGB(255, 44, 44, 44),
                      thickness: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AssistanceTable(),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

class FamilyDetilesCard extends StatelessWidget {
  final FamilyDetilesModel familyDetiles;
  const FamilyDetilesCard({super.key, required this.familyDetiles});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Card(
        color: AppColor.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'أسم الأسرة: ${familyDetiles.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'المربع السكني: ${familyDetiles.blockId}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'الموقع: ${familyDetiles.location}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'نوع السكن: ${familyDetiles.housingType}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'تصنيف الأسرة: ${familyDetiles.familyCatgoryName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'رب الأسرة: ${familyDetiles.headOfTheFamilyName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'رقم الجوال: 777888666',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'الأيميل: mohammed@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamilyMembersSection extends StatelessWidget {
  final List<Person> familyMembers;

  const FamilyMembersSection({super.key, required this.familyMembers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...familyMembers.map((e) => MemberCard(familyMember: e))],
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final Person familyMember;

  const MemberCard({super.key, required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Card(
        color: AppColor.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 25, child: Icon(Icons.person)),
              const SizedBox(height: 8),
              Text(
                familyMember.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'رقم الهوية: ${familyMember.identityNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'نوع الهوية: ${familyMember.secondName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'رقم الجوال: ${familyMember.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'الأيميل: ${familyMember.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'الجنس: ${familyMember.gender}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'تاريخ الميلاد: ${familyMember.secondName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'فصيلة الدم: ${familyMember.bloodType}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'الحالة: ${familyMember.secondName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'دور الفرد: ${familyMember.fullName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssistanceTable extends StatefulWidget {
  const AssistanceTable({super.key});

  @override
  State<AssistanceTable> createState() => _AssistanceTableState();
}

class _AssistanceTableState extends State<AssistanceTable> {
  List<Assist> assistsList = [];
  List<Assist> assistsListSearch = [];

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<FamilyCubit>(context).get_Assists(2);
  }

  Widget buildBlocWidget() {
    return BlocBuilder<FamilyCubit, FamilyState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        if (state is FamilyLoaded) {
          // assistsList = state.families;
          assistsListSearch = assistsList;
          return buildLoadedListFamilys();
        } else if (state is FamilyLoaded) {
          return showLoadingIndicator();
        } else if (state is FamilyLoaded) {
          return const Center(
            // child: Text(
            //   state.errorMessage,
            //   style: const TextStyle(color: Colors.red, fontSize: 18),
            // ),
          );
        } else {
          return const Center(child: Text("لا توجد بيانات للعرض حاليًا."));
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListFamilys() {
    return CustomTableWidget(
      columnTitles: ['ملاحظات', 'تاريخ الإستلام', 'نوع المساعدات', 'رقم'],
      columnFlexes: [3, 2, 3, 1],
      rowData: assistsListSearch.asMap().entries.map((entry) {
        int index = entry.key;
        var assists = entry.value;
        return [
          assists.Notes,
          assists.deliverDate,
          assists.AssistType,
          '${index + 1}',
        ];
      }).toList(),
    );
  }

  void updateSearchResults(List<Assist> filteredList) {
    setState(() {
      assistsListSearch = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'المساعدات التي استلمتها',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SearchWidget<Assist>(
          originalList: assistsList,
          onSearch: updateSearchResults,
          searchCriteria: (Assist) => Assist.AssistType,
        ),
        const SizedBox(height: 10),
        SizedBox(height: 300, child: buildBlocWidget()),
      ],
    );
  }
}
