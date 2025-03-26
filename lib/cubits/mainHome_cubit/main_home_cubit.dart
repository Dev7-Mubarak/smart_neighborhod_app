import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../components/constants/app_color.dart';

part 'main_home_state.dart';

class MainHomeCubitCubit extends Cubit<MainHomeState> {
  MainHomeCubitCubit() : super(MainHomeInitial());

  static MainHomeCubitCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 1;

  void changeselectedIndex(int num) {
    selectedIndex = num;
    emit(MainHomeIndexChanged(selectedIndex)); // تحديث الحالة وإعادة البناء
  }

  Color changebackgroundcolor(int num) {
    return selectedIndex == num
        ? AppColor.primaryColor
        : AppColor.gray; // تغيير لون الخلفية بناءً على الزر النشط
  }

  Color changeFontcolor(int num) {
    return selectedIndex == num ? AppColor.white : Colors.black;
  }
}