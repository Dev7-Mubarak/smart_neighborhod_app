import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/constants/app_color.dart';
part 'main_home_state.dart';

class MainHomeCubit extends Cubit<MainHomeState> {
  MainHomeCubit() : super(MainHomeInitial());

  static MainHomeCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 1;

  void changeSelectedIndex(int num) {
    selectedIndex = num;
    emit(MainHomeIndexChanged(selectedIndex));
  }

  Color changebackgroundcolor(int num) {
    return selectedIndex == num ? AppColor.primaryColor : AppColor.gray;
  }

  Color changeFontcolor(int num) {
    return selectedIndex == num ? AppColor.white : Colors.black;
  }
}
