import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_state.dart';
import '../components/NavigationBar.dart';
import '../components/constants/app_color.dart';
import '../components/searcharea.dart';
import '../components/smallButton.dart';
import '../components/table.dart';
import '../models/Assist.dart';

class FamilyInfo extends StatefulWidget {
  const FamilyInfo({super.key});

  @override
  State<FamilyInfo> createState() => _FamilyInfoState();
}

class _FamilyInfoState extends State<FamilyInfo> {
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
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FamilyInfoCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SmallButton(
                    text: 'تعديل',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'أفراد الأسرة',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            const SizedBox(height: 16),
            FamilyMembersSection(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SmallButton(
                    text: 'إضافة فرد جديد',
                    onPressed: () {},
                  ),
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
      ),
      bottomNavigationBar: const navigationBar(),
    );
  }
}

class FamilyInfoCard extends StatelessWidget {
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
            children: const [
              Text('أسم الأسرة: باوزير',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                'المربع السكني: المربع السكني 1',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'الموقع: الديس',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'نوع السكن: ملك',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'تصنيف الأسرة: A',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'الدخل الكلي للأسرة: 200,000',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'رب الأسرة: محمد أحمد',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                ' رقم الهوية: 233442',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'رقم الجوال: 777888666',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text(
                'الأيميل: mohammed@gmail.com',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamilyMembersSection extends StatelessWidget {
  final List<Map<String, String>> members = [
    {
      'name': 'فاطمة علي',
      'id': '245322',
      'typeId': 'بطاقة شخصيه',
      'phonnum': '777555444',
      'emal': 'atima@gmail.com',
      'gender': 'أنثى',
      'barthDay': '2\\5\\1975',
      'blod': '+O',
      'stat': 'موظفة',
      'role': 'أم'
    },
    {
      'name': 'سالم علي',
      'id': '245322',
      'typeId': 'بطاقة شخصيه',
      'phonnum': '777555444',
      'emal': 'atima@gmail.com',
      'gender': 'أنثى',
      'barthDay': '2\\5\\1975',
      'blod': '+O',
      'stat': 'موظفة',
      'role': 'أب'
    },
    {
      'name': 'محمد علي',
      'id': '245322',
      'typeId': 'بطاقة شخصيه',
      'phonnum': '777555444',
      'emal': 'atima@gmail.com',
      'gender': 'أنثى',
      'barthDay': '2\\5\\1975',
      'blod': '+O',
      'stat': 'موظفة',
      'role': 'أبن'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: members.map((e) => MemberCard(e)).toList(),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final Map<String, String> member;

  const MemberCard(this.member, {super.key});

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
              const CircleAvatar(
                radius: 25,
                child: Icon(
                  Icons.person,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                member['name']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
              const SizedBox(height: 6),
              Text(
                'رقم الهوية: ${member['id']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'نوع الهوية: ${member['typeId']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'رقم الجوال: ${member['phonnum']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'الأيميل: ${member['emal']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'الجنس: ${member['gender']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'تاريخ الميلاد: ${member['barthDay']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'فصيلة الدم: ${member['blod']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'الحالة: ${member['stat']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'دور الفرد: ${member['role']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssistanceTable extends StatefulWidget {
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
        if (state is FamilysLoaded) {
          // assistsList = state.families;
          assistsListSearch = assistsList;
          return buildLoadedListFamilys();
        } else if (state is FamilysLoaded) {
          return showLoadingIndicator();
        } else if (state is FamilysLoaded) {
          return const Center(
              // child: Text(
              //   state.errorMessage,
              //   style: const TextStyle(color: Colors.red, fontSize: 18),
              // ),
              );
        } else {
          return const Center(
            child: Text("لا توجد بيانات للعرض حاليًا."),
          );
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
          '${index + 1}'
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
        SizedBox(
          height: 300,
          child: buildBlocWidget(),
        )
      ],
    );
  }
}
