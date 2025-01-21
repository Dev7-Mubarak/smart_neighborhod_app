import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'residdential_blocks_state.dart';

class ResiddentialBlocksCubit extends Cubit<ResiddentialBlocksState> {
  ResiddentialBlocksCubit() : super(ResiddentialBlocksInitial());
}
