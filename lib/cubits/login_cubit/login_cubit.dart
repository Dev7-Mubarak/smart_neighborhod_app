import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/api_link.dart';
import 'package:smart_neighborhod_app/models/login_model.dart';
import 'package:smart_neighborhod_app/views/login.dart';
import '../../core/API/APIConsumer.dart';
import '../../core/errors/exception.dart';
import '../../services/cache_helper.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.api}) : super(LoginIntial());

  static LoginCubit get(context) => BlocProvider.of(context);

  late LoginModel loginModel;

  ApiConsumer api;

  signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        ApiLink.login,
        data: {
          'username': email,
          'password': password,
        },
      );
      loginModel = LoginModel.fromJson(response);
      CacheHelper().saveData(key: 'id', value: loginModel.data!=null?loginModel.data!.id:null);
      emit(LoginSuccess(loginModel));
    } on Serverexception catch (e) {
      emit(LoginFailure(errorMessage: e.errModel.errorMessage));
    }
  }

  IconData prefixIcon = Icons.visibility;
  bool isPassword = true;

  void changePasswordVisibilty() {
    isPassword = !isPassword;
    prefixIcon = isPassword ? Icons.visibility : Icons.visibility_off;

    emit(ChangePasswordVisibility());
  }
}
