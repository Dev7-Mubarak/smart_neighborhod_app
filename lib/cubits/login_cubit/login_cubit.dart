import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/api_link.dart';
import 'package:smart_neighborhod_app/models/login_model.dart';
import '../../core/API/api_consumer.dart';
import '../../core/errors/exception.dart';
import '../../services/cache_helper.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.api}) : super(LoginIntial());

  static LoginCubit get(context) => BlocProvider.of(context);

  // late LoginModel loginModel;
  late UserData userData;

  ApiConsumer api;

  signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final response = await
      Dio().post("https://smartnieborhoodapi.runasp.net/api/Auth/Login", data: {
    "email":email,
    "password":password
  },
  );

    //    api.post(
    //     ApiLink.login,
    //     data: {
    //       'email': email,
    //       'password': password,
    //     },
    //   );
    //   loginModel = LoginModel.fromJson(response);
    //   CacheHelper().saveData(
    //       key: 'id',
    //       value: loginModel.data != null ? loginModel.data!.id : null
    //       );
    //   emit(LoginSuccess(loginModel));
    // } on Serverexception catch (e) {
    //   emit(LoginFailure(errorMessage: e.errModel.errorMessage));
    // }
      //    api.post(
      //   ApiLink.login,
      //   data: {
      //     'email': email,
      //     'password': password,
      //   },
      // );

    userData = UserData.fromJson(response.data["data"]); // تحويل البيانات بشكل صحيح
      CacheHelper().saveData(
          key: 'id',
          value: userData.id!= null ? userData.id : null
          );
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
