import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/BlockDetails.dart';

import '../../../models/Block.dart';

@immutable
abstract class BlockState {}

class BlockInitial extends BlockState {}

class BlocksLoaded extends BlockState {
  final List<Block> allBlocks;

  BlocksLoaded(this.allBlocks);
}

class BlocksDetailesLoaded extends BlockState {
  final BlockDetails blockDetailes;

  BlocksDetailesLoaded(this.blockDetailes);
}

class BlocksLoading extends BlockState {}

class BlocksFailure extends BlockState {
  final String errorMessage;
  BlocksFailure({required this.errorMessage});
}

class BlockAddedSuccessfully extends BlockState {
  final String message;
  BlockAddedSuccessfully({required this.message});
}

class BlockDeletedSuccessfully extends BlockState {
  final String message;
  BlockDeletedSuccessfully({required this.message});
}

class BlockUpdatedSuccessfully extends BlockState {
  final String message;
  BlockUpdatedSuccessfully({required this.message});
}

class ChangeSelectedManager extends BlockState {}
