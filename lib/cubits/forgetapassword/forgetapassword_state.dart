part of 'forgetapassword_cubit.dart';

@immutable
abstract class ForgetapasswordState {}

 class SendEmailInitial extends ForgetapasswordState {}

 class  SendEmailSuccess extends ForgetapasswordState {

  SendEmailSuccess();
}

class  SendEmailLoading extends ForgetapasswordState {}


class  SendEmailFailure extends ForgetapasswordState {
  String errorMessage;
  SendEmailFailure({required this.errorMessage});
}
