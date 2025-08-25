import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/api_link.dart';
import 'package:smart_negborhood_app/core/services/API/dio_consumer.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/core/services/errors/exception.dart';


part 'forgetapassword_state.dart';

class ForgetapasswordCubit extends Cubit<ForgetapasswordState> {
  ForgetapasswordCubit({required this.api}) : super(SendEmailInitial());
  static ForgetapasswordCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  IconData FirstprefixIcon = Icons.visibility;
  bool FirstisPassword = true;
  IconData SecondprefixIcon = Icons.visibility;
  bool SecondisPassword = true;
  late String email;

  Future<void> sendEmail(String emailAddress) async {
    emit(SendEmailLoading());
    try {
      email = emailAddress;
      final response = await api.post(
        ApiLink.sendEmail,
        data: {'email': emailAddress},
      );
      if (response["isSuccess"]) {
        emit(
          SendEmailSuccess(
            response["data"] ??
                "تم إرسال الإيميل بنجاح, سيتم إرسال رمز التأكيد إلى بريدك الإلكتروني ",
          ),
        );
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(SendEmailFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(SendEmailFailure(errorMessage: e.toString()));
    }
  }

  Future<void> sendConfirmationCode(String confirmationCode) async {
    emit(SendConfirmationCodeLoading());
    try {
      final response = await api.post(
        ApiLink.sendConfirmationCode,
        data: {'code': confirmationCode, "email": email},
      );
      if (response["isSuccess"]) {
        emit(
          SendConfirmationCodeSuccess(
            response["data"] ?? "تم التأكد من البريد الإلكتروني  ",
          ),
        );
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(SendConfirmationCodeFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(SendConfirmationCodeFailure(errorMessage: e.toString()));
    }
  }

  Future<void> sendNewPassword(String newPassword,String confirmPassword) async {
    emit(SendNewPasswordLoading());
    try {
      final response = await api.post(
        ApiLink.sendNewPassword,
        data:{
          "email": email,
          "newPassword": newPassword,
          "confirmPassword":confirmPassword,
        },
      );
      if (response["isSuccess"]) {
        emit(
          SendNewPasswordSuccess(
            response["data"] ?? "تم تعديل كلمة المرور بنجاح",
          ),
        );
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(SendNewPasswordFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(SendNewPasswordFailure(errorMessage: e.toString()));
    }
  }

  void changeFirstPasswordVisibilty() {
    FirstisPassword = !FirstisPassword;
    FirstprefixIcon = FirstisPassword ? Icons.visibility : Icons.visibility_off;
    emit(ChangeFirstPasswordVisibility());
  }

  void changeSecondPasswordVisibilty() {
    SecondisPassword = !SecondisPassword;
    SecondprefixIcon = SecondisPassword
        ? Icons.visibility
        : Icons.visibility_off;
    emit(ChangeSecondPasswordVisibility());
  }
}
