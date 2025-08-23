import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_email_state.dart';

class CheckEmailCubit extends Cubit<CheckEmailState> {
  CheckEmailCubit() : super(CheckEmailInitial());
}
