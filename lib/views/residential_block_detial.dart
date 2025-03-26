import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/models/Block.dart';
import 'package:smart_neighborhod_app/models/family.dart';
import '../components/NavigationBar.dart';
import '../components/constants/app_color.dart';
import '../components/constants/app_image.dart';
import '../components/searcharea.dart';
import '../components/table.dart'; // يحتوي على CustomTableWidget
import '../cubits/ResiddentialBlocksDetail_cubit/residdential_blocksdential_cubit.dart';
import '../cubits/ResiddentialBlocks_cubit/cubit/residdential_blocks_cubit.dart';

class ResiddentialBlocksDetail extends StatefulWidget {
  const ResiddentialBlocksDetail({super.key});

  @override
  State<ResiddentialBlocksDetail> createState() =>
      _ResiddentialBlocksDetailState();
}

class _ResiddentialBlocksDetailState extends State<ResiddentialBlocksDetail> {
  List<Family> FamilysListSearch = [];
  List<Family> FamilysList = [];

  void updateSearchResults(List<Family> filteredList) {
    setState(() {
      FamilysListSearch = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    // استدعاء الـ API مرة واحدة فقط في initState
    BlocProvider.of<ResiddentialBlockDetailCubit>(context)
        .get_AllBlockFamilys(2);
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ResiddentialBlockDetailCubit,
        ResiddentialBlockDetailState>(
      // إعادة البناء تحدث فقط عند تغيير نوع الحالة
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        if (state is get_AllBlockFamilys_Success) {
          FamilysList = state.AllBlockFamilys;
          FamilysListSearch = FamilysList; // عرض القائمة الأصلية
          return buildLoadedListFamilys();
        } else if (state is get_AllBlockFamilys_Loading) {
          return showLoadingIndicator();
        } else if (state is get_AllBlockFamilys_Failure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
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
    // استخدام const لتقليل عمليات إعادة البناء
    return const Center(child: CircularProgressIndicator());
  }


  Widget buildLoadedListFamilys() {
    return CustomTableWidget(
      columnTitles: ['رقم التواصل', 'التصنيف', 'رب الأسرة', 'رقم'],
      columnFlexes: [3, 2, 3, 1],
      rowData: FamilysListSearch.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [
          family.phoneNumber,
          family.familyCategory,
          family.Familyfather,
          '${index + 1}'
        ];
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0, // إزالة الخط السفلي
        bottomOpacity: 0,
        iconTheme: const IconThemeData(
            color: Colors.black), // تغيير لون سهم الرجوع إلى الأسود
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Center(
            child: Text(
            'المربع السكني 1',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: double.infinity, // أضف عرضًا ثابتًا
                 height: 205, // أضف ارتفاعًا ثابتًا
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(AppImage.residentailimage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'المربع السكني 1',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'مدير المربع: خالد أحمد',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'عدد الأسر: 200',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'عدد الأرامل: 50',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'عدد الأيتام: 110',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                  color: Color.fromARGB(255, 44, 44, 44), thickness: 1.5),
              const SizedBox(height: 10),
              const Text(
                'الأسر في المربع السكني',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // زر إضافة أسرة وبحث
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      minimumSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "إضافة أسرة",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SearchWidget<Family>(
                    originalList: FamilysList,
                    onSearch: updateSearchResults,
                    searchCriteria: (Family) => Family.Familyfather,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              buildBlocWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: navigationBar()
    );
  }
}