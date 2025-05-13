import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/api_link.dart';
import 'package:smart_neighborhod_app/models/login_model.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/exception.dart';
import '../../services/cache_helper.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.api}) : super(LoginIntial());

  static LoginCubit get(context) => BlocProvider.of(context);

  late UserData userData;
  final DioConsumer api;

  signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final response = await api.post(
        ApiLink.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      userData = UserData.fromJson(response["data"]);
      CacheHelper().saveData(key: 'id', value: userData.id);
      emit(LoginSuccess(userData));
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
