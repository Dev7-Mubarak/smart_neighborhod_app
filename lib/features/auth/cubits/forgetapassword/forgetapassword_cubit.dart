import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgetapassword_state.dart';

class ForgetapasswordCubit extends Cubit<ForgetapasswordState> {
  ForgetapasswordCubit() : super(SendEmailInitial());

  
}
