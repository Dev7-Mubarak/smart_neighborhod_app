import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/views/residdentailBlocks/residdential_blocks.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../cubits/mainHome_cubit/main_home_cubit.dart';
import 'home.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  MmainHomeState createState() => MmainHomeState();
}

class MmainHomeState extends State<MainHome> {
  static final List<Widget> _widgetOptions = [
    const ResidentialBlock(),
    const Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        bottomOpacity: 0,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Center(
            child: Text(
              'الحارة الذكية',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MainHomeCubit, MainHomeState>(
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.gray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              MainHomeCubit.get(context).changeSelectedIndex(0);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MainHomeCubit.get(
                                  context,
                                ).changeSelectedBackgroundColor(0),
                              ),
                              child: Center(
                                child: Text(
                                  'المربعات السكنية',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: MainHomeCubit.get(
                                      context,
                                    ).changeSelectedFontColor(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              MainHomeCubit.get(context).changeSelectedIndex(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MainHomeCubit.get(
                                  context,
                                ).changeSelectedBackgroundColor(1),
                              ),
                              child: Center(
                                child: Text(
                                  'الرئيسية',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: MainHomeCubit.get(
                                      context,
                                    ).changeSelectedFontColor(1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _widgetOptions.elementAt(
                    MainHomeCubit.get(context).selectedIndex,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
