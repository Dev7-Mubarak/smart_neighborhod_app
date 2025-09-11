import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../cubits/cubit/block_cubit.dart';
import '../../cubits/cubit/block_state.dart';
import '../../data/models/Block.dart';
import '../widgets/change_block_name_widget.dart';
import '../widgets/residential_block_card_widget.dart';

class ResidentialBlock extends StatefulWidget {
  const ResidentialBlock({super.key});

  @override
  State<ResidentialBlock> createState() => _ResidentialBlockState();
}

class _ResidentialBlockState extends State<ResidentialBlock> {
  List<Block> residentialList = [];
  late final BlockCubit _blockCubit;

  @override
  void initState() {
    super.initState();
    _blockCubit = context.read<BlockCubit>()..getBlocks();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<BlockCubit, BlockState>(
      builder: (context, state) {
        if (state is BlocksLoaded) {
          return buildLoadedListWidgets(state.allBlocks);
        } else if (state is BlocksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BlocksFailure) {
          return OnFailureWidget(onRetry: () => _blockCubit.getBlocks());
        } else {
          return const Center(child: Text("لا توجد بيانات للعرض حاليًا."));
        }
      },
    );
  }

  Widget buildLoadedListWidgets(List<Block> blocks) {
    if (blocks.isEmpty) {
      return Center(child: NoResultWidget());
    }
    return ListView.builder(
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        return ResidentialBlockCardWidget(
          block: blocks[index],
          onLongPressCallback: (ctx, block) {
            _showOptions(block);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SmallButton(
                text: locale.add,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.addUpdateBlock).then((
                    _,
                  ) {
                    _blockCubit.getBlocks();
                  });
                },
              ),
              const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
              Expanded(
                child: SearchableTextFormField(
                  hintText: locale.searchResidentialBlock,
                  bachgroundColor: AppColor.gray2,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                  ),
                  prefixIcon : Icons.search,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: buildBlocWidget(),
          ),
        ),
      ],
    );
  }

  void _showOptions(Block block) {
    final locale = context.locale;

    context.showBottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: Text(locale.changeBlockName),
            onTap: () {
              Navigator.pop(context);
              _blockCubit.setBlock(block);
              context.showBottomSheet(
                BlocProvider.value(
                  value: _blockCubit,
                  child: ChangeBlockNameWidget(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: Text(locale.changeManager),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoute.changeBlockManager,
                arguments: context.read<BlockCubit>()..setBlock(block),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(locale.delete),
            onTap: () async {
              Navigator.pop(context);
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(locale.confirmDelete),
                  content: Text(locale.deleteNotAllowed),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(locale.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _blockCubit.deleteBlock(block.id);
                      },
                      child: Text(
                        locale.delete,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
