import '../../data/models/BlockDetails.dart';

abstract class BlockDetailState {}

class BlockDetailInitial extends BlockDetailState {}

class BlockDetailLoading extends BlockDetailState {}

class BlockDetailLoaded extends BlockDetailState {
  final BlockDetails blockDetails;
  BlockDetailLoaded(this.blockDetails);
}

class BlockDetailFailure extends BlockDetailState {
  final String errorMessage;
  BlockDetailFailure({required this.errorMessage});
}
