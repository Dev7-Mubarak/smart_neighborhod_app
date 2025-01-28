part of 'residdential_blocks_cubit.dart';

@immutable
abstract class ResiddentialBlocksState {}

class ResiddentialBlocksInitial extends ResiddentialBlocksState {}

class get_ResiddentialBlocks_Success extends ResiddentialBlocksState {
  final List<Block> AllResiddentialBlocks;

  get_ResiddentialBlocks_Success({required this.AllResiddentialBlocks});
}
class get_ResiddentialBlocks_Loading extends ResiddentialBlocksState {}

class get_ResiddentialBlocks_Failure extends ResiddentialBlocksState {
    String errorMessage;
  get_ResiddentialBlocks_Failure({required this.errorMessage});
}
