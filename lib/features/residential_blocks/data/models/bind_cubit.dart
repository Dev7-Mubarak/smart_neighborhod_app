import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/residential_blocks/cubits/BlockDetailCubit/block_detail_cubit.dart';

class BindCubit {
  final FamilyCubit familyCubit;
  final BlockDetailCubit blockDetailCubit;
  BindCubit({required this.familyCubit, required this.blockDetailCubit});
}
