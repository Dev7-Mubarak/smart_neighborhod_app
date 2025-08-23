import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../cubits/cubit/block_cubit.dart';
import '../../cubits/cubit/block_state.dart';
import '../../data/models/Block.dart';
import 'widgets/residential_block_card_widget.dart';
// Add this import at the top

class ResidentialBlock extends StatefulWidget {
  const ResidentialBlock({super.key});

  @override
  State<ResidentialBlock> createState() => _ResidentialBlockState();
}

class _ResidentialBlockState extends State<ResidentialBlock> {
  List<Block> residentialListSearch = [];
  List<Block> residentialList = [];
  late BlockCubit _blockCubit;

  @override
  void initState() {
    super.initState();
    _blockCubit = context.read<BlockCubit>()..getBlocks();
  }

  void updateSearchResults(List<Block> filteredList) {
    setState(() {
      residentialListSearch = filteredList;
    });
  }

  Widget buildBlocWidget() {
    return BlocBuilder<BlockCubit, BlockState>(
      builder: (context, state) {
        if (state is BlocksLoaded) {
          residentialList = state.allBlocks;
          residentialListSearch = residentialList;
          return buildLoadedListWidgets();
        } else if (state is BlocksLoading) {
          return showLoadingIndicator();
        } else if (state is BlocksFailure) {
          return OnFailureWidget(onRetry: () => _blockCubit.getBlocks());
        } else {
          return const Center(child: Text("لا توجد بيانات للعرض حاليًا."));
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListWidgets() {
    return ListView.builder(
      itemCount: residentialListSearch.length,
      itemBuilder: (context, index) {
        return ResidentialBlockCardWidget(
          block: residentialListSearch[index],
          onLongPressCallback: (ctx, block) {
            _showOptions(ctx, block);
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
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                  ),
                  suffixIcon: Icons.search,
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

  void _showOptions(BuildContext passContext, Block bloc) {
    final locale = passContext.locale;

    showModalBottomSheet(
      context: passContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text(locale.edit),
              onTap: () {
                BlocProvider.of<BlockCubit>(passContext).setBlock(bloc);
                Navigator.pushNamed(context, AppRoute.addUpdateBlock);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: Text(locale.changeManager),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: passContext,
                  builder: (context) => AlertDialog(
                    title: Text(locale.changeManager),
                    content: Text(locale.changeManagerLogic),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(locale.close),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(locale.delete),
              onTap: () async {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: passContext,
                  builder: (context) => AlertDialog(
                    title: Text(locale.confirmDelete),
                    content: Text(locale.confirmDeleteBlock),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(locale.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _blockCubit.deleteBlock(bloc.id);
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
        );
      },
    );
  }
}
