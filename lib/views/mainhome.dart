import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/ResiddentialBlocks_cubit/cubit/residdential_blocks_cubit.dart';

import '../components/constants/app_color.dart';
import '../core/API/dio_consumer.dart';
import '../cubits/mainHome_cubit/main_home_cubit.dart';
import 'residdential_blocks.dart';
import 'home.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  MmainHomeState createState() => MmainHomeState();
}

class MmainHomeState extends State<MainHome> {
  static final List<Widget> _widgetOptions = [
     BlocProvider(
            create: (BuildContext contxt) => ResiddentialBlocksCubit(api: DioConsumer(dio: Dio())),
            child:ResidentialBlock(),
          ),
    const  Home()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainHomeCubitCubit(),
      child: BlocConsumer< MainHomeCubitCubit,MainHomeState>(
        listener: (context, state) {
        },
        builder: (context, state) {
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
            body: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    decoration: BoxDecoration(
                        color: AppColor.gray,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              MainHomeCubitCubit.get(context)
                                  .changeselectedIndex(0);
                              // setState(() {
                              //   _selectedIndex = 0;
                              // });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: MainHomeCubitCubit.get(context)
                                      .changebackgroundcolor(
                                          0) // تغيير لون الخلفية بناءً على الزر النشط
                                  ),
                              child: Center(
                                child: Text(
                                  'المربعات السكنية',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: MainHomeCubitCubit.get(context)
                                          .changeFontcolor(0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              MainHomeCubitCubit.get(context)
                                  .changeselectedIndex(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MainHomeCubitCubit.get(context)
                                    .changebackgroundcolor(1),
                              ),
                              child: Center(
                                child: Text(
                                  'الرئيسية',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: MainHomeCubitCubit.get(context)
                                          .changeFontcolor(1)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: _widgetOptions.elementAt(
                      MainHomeCubitCubit.get(context).selectedIndex,
                    ),
                  ),
                ],
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
        },
      ),
    );
  }
}
