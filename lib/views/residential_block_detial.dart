import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/models/Block.dart';
import 'package:smart_neighborhod_app/models/family.dart';
import '../components/constants/app_color.dart';
import '../components/constants/app_image.dart';
import '../components/searcharea.dart';
import '../cubits/ResiddentialBlocksDetail_cubit/residdential_blocksdential_cubit.dart';
import '../cubits/ResiddentialBlocks_cubit/cubit/residdential_blocks_cubit.dart';

class ResiddentialBlocksDetail extends StatefulWidget {
  // final Block block;
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
    BlocProvider.of<ResiddentialBlockDetailCubit>(context).get_AllBlockFamilys(
        // block.id
        2);
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ResiddentialBlockDetailCubit,
        ResiddentialBlockDetailState>(
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
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListFamilys() {
    return // جدول البيانات
        Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: {
        0: FlexColumnWidth(3), // العمود الأول (رقم التواصل)
        1: FlexColumnWidth(2), // العمود الثاني (التصنيف)
        2: FlexColumnWidth(3), // العمود الثالث (رب الأسرة)
        3: FlexColumnWidth(1), // العمود الرابع (رقم)
      },
      children: [
        // الصف العلوي (رأس الجدول)
        TableRow(
          decoration: BoxDecoration(color: AppColor.primaryColor),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'رقم التواصل',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'التصنيف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'رب الأسرة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'رقم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        // الصفوف الديناميكية
        ...FamilysListSearch.asMap().entries.map((entry) {
          int index = entry.key; // رقم الفهرس (0, 1, 2, ...)
          var family = entry.value; // العنصر في القائمة
          return TableRow(
            decoration: BoxDecoration(
              color: index % 2 == 0
                  ? Colors.grey[200]
                  : Colors.white, // تلوين الصفوف بالتناوب
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  family.phoneNumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  family.familyCategory,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  family.Familyfather,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '${index + 1}', // رقم الصف
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0, // إزالة الخط السفلي
        bottomOpacity: 0,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Center(
            child: Text(
              'الحارة الذكية',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // صورة المربع السكني
              // كود ننفده عند ربط الصفحة بالApi
              //  block.image.isNotEmpty
              //   ? FadeInImage.assetNetwork(
              //       height: MediaQuery.of(context).size.width *
              //           0.5, // ارتفاع الصورة ديناميكي
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //       placeholder: AppImage.loadingimage,
              //       image: block.image,
              //     )
              //   : Image.asset(AppImage.residentailimage),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    15), // تحديد نصف القطر للحواف الدائرية
                child: Image.asset(
                  AppImage.residentailimage,
                  fit: BoxFit.cover, // تحديد كيف سيتم عرض الصورة داخل الحاوية
                ),
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // block.name
                    'المربع السكني 1',
                    style: TextStyle(
                      fontSize: 22, // حجم أكبر
                      fontWeight: FontWeight.bold, // خط عريض
                      color: Colors.black, // لون أغمق
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // block.manger
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
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'عدد الأرامل: 50',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'عدد الأيتام: 110',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Color.fromARGB(255, 44, 44, 44), // لون أقل حدة
                thickness: 1.5, // تحديد سماكة الخط
              ),

              // عنوان القسم الثاني
              SizedBox(height: 10),
              Text(
                'الأسر في المربع السكني',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
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
                    searchCriteria: (Family) =>
                        Family.Familyfather, // البحث بالاسم
                  ),
                ],
              ),
              SizedBox(height: 8),
              buildBlocWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: const Color(0xFF565E6C),
        iconSize: 30, // زيادة حجم الأيقونات
        selectedLabelStyle: const TextStyle(
          fontSize: 16, // تكبير حجم النص للعناصر المحددة
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14, // تكبير حجم النص للعناصر غير المحددة
        ),
        currentIndex: 0,
        onTap: (int j) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'بحث',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'أكثر',
          ),
        ],
      ),
    );
  }
}
