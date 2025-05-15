import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/familyCategory/family_category_cubit.dart';
import 'package:smart_neighborhod_app/cubits/familyType/family_type_cubit.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_state.dart';
import 'package:smart_neighborhod_app/models/family.dart';
import 'package:smart_neighborhod_app/views/addNewFamily.dart';
import '../components/NavigationBar.dart';
import '../components/constants/app_color.dart';
import '../components/constants/app_image.dart';
import '../components/searcharea.dart';
import '../components/table.dart'; // يحتوي على CustomTableWidget
import '../core/API/dio_consumer.dart';
import '../models/Block.dart';

class ResiddentialBlocksDetail extends StatefulWidget {
  final Block block;

  const ResiddentialBlocksDetail({super.key, required this.block});

  @override
  State<ResiddentialBlocksDetail> createState() =>
      _ResiddentialBlocksDetailState();
}

class _ResiddentialBlocksDetailState extends State<ResiddentialBlocksDetail> {
  List<Family> FamilysListSearch = [];
  List<Family> FamilysList = [];
  final ScrollController _scrollController = ScrollController();
  void updateSearchResults(List<Family> filteredList) {
    setState(() {
      FamilysListSearch = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();

    final familyCubit = BlocProvider.of<FamilyCubit>(context);
    familyCubit.getBlockFamiliesByBlockId(widget.block.id);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          familyCubit.state is! FamilyLoading) {
        familyCubit.getBlockFamiliesByBlockId(widget.block.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<FamilyCubit, FamilyState>(
      builder: (context, state) {
        if (state is FamilyLoaded) {
          FamilysList = state.families;
          FamilysListSearch = FamilysList; // عرض القائمة الأصلية
          return buildLoadedListFamilys();
        } else if (state is FamilyLoading) {
          return showLoadingIndicator();
        } else if (state is FamilyFailure) {
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
      columnTitles: const ['رقم التواصل', 'التصنيف', 'رب الأسرة', 'رقم'],
      columnFlexes: const [3, 2, 3, 1],
      rowData: FamilysList.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [family.name, family.name, family.familyNotes, '${index + 1}'];
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
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: Text(
                widget.block.name,
                style: const TextStyle(
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
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity, // أضف عرضًا ثابتًا
                  height: 205, // أضف ارتفاعًا ثابتًا
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage(AppImage.residentailimage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.block.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مدير المربع:  ${widget.block.managerName}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'عدد الأسر: 200',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'عدد الأرامل: 50',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 3),
                    const Text(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (_) => FamilyCategoryCubit(
                                        api: DioConsumer(dio: Dio()))
                                      ..getFamilyCategories()),
                                BlocProvider(
                                    create: (_) => FamilyTypeCubit(
                                        api: DioConsumer(dio: Dio()))
                                      ..getFamilyTypes()),
                              ],
                              child: AddNewFamily(block: widget.block),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        minimumSize: const Size(40, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "إضافة أسرة",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SearchWidget<Family>(
                      originalList: FamilysList,
                      onSearch: updateSearchResults,
                      searchCriteria: (Family) => Family.name,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                buildBlocWidget(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const navigationBar());
  }
}
