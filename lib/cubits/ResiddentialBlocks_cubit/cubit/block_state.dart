import 'package:flutter/material.dart';
import '../../../models/Block.dart';

@immutable
abstract class BlockState {}

class BlockInitial extends BlockState {}

class BlocksLoaded extends BlockState {
  final List<Block> allBlocks;

  BlocksLoaded(
    this.allBlocks,
  );
}

class BlocksLoading extends BlockState {}

class BlocksFailure extends BlockState {
  final String errorMessage;
  BlocksFailure({
    required this.errorMessage,
  });
}

class BlockAddedSuccessfully extends BlockState {
  final String message;
  BlockAddedSuccessfully({required this.message});
}
