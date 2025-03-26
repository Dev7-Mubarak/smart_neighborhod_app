import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'new_password_state.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit() : super(NewPasswordInitial());

  static NewPasswordCubit get(context) => BlocProvider.of(context);

  IconData FirstprefixIcon = Icons.visibility;
  bool FirstisPassword = true;
  IconData SecondprefixIcon = Icons.visibility;
  bool SecondisPassword = true;

  void changeFirstPasswordVisibilty() {
    FirstisPassword = !FirstisPassword;
    FirstprefixIcon = FirstisPassword ? Icons.visibility : Icons.visibility_off;
    emit(ChangeFirstPasswordVisibility());
  }
   void changeSecondPasswordVisibilty() {
    SecondisPassword = !SecondisPassword;
    SecondprefixIcon = SecondisPassword ? Icons.visibility : Icons.visibility_off;
    emit(ChangeSecondPasswordVisibility());
  }
}
