import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/api_link.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';

import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import '../../../../core/services/shared_preferences_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.api}) : super(LoginIntial());

  static LoginCubit get(context) => BlocProvider.of(context);

  late ProfileModel profileModel;
  final DioConsumer api;
  IconData prefixIcon = Icons.visibility;
  bool isPassword = true;

  signIn({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await api.post(
        ApiLink.login,
        data: {'email': email, 'password': password},
      );

      if (response['isSuccess']) {
        profileModel = ProfileModel.fromJson(response["data"]);
        SharedPreferencesService.setProfile(profileModel);
        emit(
          LoginSuccess(userdata: profileModel, message: response['message']),
        );
      }
    } on Serverexception catch (e) {
      emit(LoginFailure(errorMessage: e.errModel.errorMessage));
    }
  }

  void changePasswordVisibilty() {
    isPassword = !isPassword;
    prefixIcon = isPassword ? Icons.visibility : Icons.visibility_off;

    emit(ChangePasswordVisibility());
  }
}
