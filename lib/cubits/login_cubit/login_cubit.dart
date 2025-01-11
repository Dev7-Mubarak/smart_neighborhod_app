import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/api_link.dart';
import 'package:smart_neighborhod_app/models/login_model.dart';
import 'package:smart_neighborhod_app/services/dio_helper.dart';
import '../../repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginIntial());

  static LoginCubit get(context) => BlocProvider.of(context);

  late LoginModel loginModel;

  Future<void> userLogin(
      {required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final response = await DioHelper.postData(url: ApiLink.login, data: {
        'email': email,
        'password': password,
      });
      loginModel = LoginModel.fromJson(response.data);
      emit(LoginSuccess(loginModel));
    } on DioException catch (error) {
      print(error.response?.data['message']);
      emit(LoginFailure(errorMessage: error.response?.data['message']));
    }
  }

  IconData prefixIcon = Icons.visibility;
  bool isPassword = true;

  void changePasswordVisibilty() {
    isPassword = !isPassword;
    prefixIcon = isPassword ? Icons.visibility : Icons.visibility_off;

    emit(ChangePasswordVisibility());
  }
//Future<void> login(String email, String password) async {
//    emit(LoginLoading());
  //  try {
  //  emit(LoginSuccess());
  //} //catch (error) {
  // emit(LoginFailure(errorMessage: error.toString()));
  //}
  //}
}
