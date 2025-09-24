import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/constants/home_tab_enum.dart';
import '../../cubits/blockCubit/block_cubit.dart';
import '../../cubits/blockCubit/block_state.dart';
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
  HomeTabEnum _selectedTab = HomeTabEnum.residentialBlocks;

  void _onNavBarTap(int index) {
    final tappedTab = HomeTabEnum.values[index];

    if (tappedTab == HomeTabEnum.home) {
      Navigator.pushReplacementNamed(context, AppRoute.mainHome);
    } else if (tappedTab == HomeTabEnum.settings) {
      Navigator.pushReplacementNamed(context, AppRoute.settings);
    } else {
      setState(() {
        _selectedTab = tappedTab;
      });
    }
  }

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
          onTapCallback: (ctx, block) {
            Navigator.pushNamed(
              context,
              AppRoute.residentialBlockDetial,
              arguments: block.id,
            );
          },
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
    return BlocListener<BlockCubit, BlockState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddBlock) {
          context.showLoadingDialog();
        } else if (state is BlockAddedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is BlockDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is BlocksFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Column(
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
                        Navigator.pushNamed(
                          context,
                          AppRoute.addBlock,
                          arguments: _blockCubit,
                        );
                      },
                    ),
                    const SizedBox(
                      width: AppSize.spasingBetweenInputsAndLabale,
                    ),
                    Expanded(
                      child: SearchableTextFormField(
                        hintText: locale.searchResidentialBlock,
                        bachgroundColor: AppColor.gray2,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close),
                        ),
                        prefixIcon: Icons.search,
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
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _selectedTab.index,
          onTap: _onNavBarTap,
        ),
      ),
    );
  }

  void _showOptions(Block block) {
    final locale = context.locale;

    context.showBottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'خيارات المربعات السكنية',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: Text(locale.changeBlockName),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.white,
                foregroundColor: AppColor.primaryColor,
              ),
              onPressed: () {
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
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: Text(locale.changeManager),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.white,
                foregroundColor: AppColor.primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoute.changeBlockManager,
                  arguments: context.read<BlockCubit>()..setBlock(block),
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: Text(locale.delete),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: AppColor.white,
              ),
              onPressed: () async {
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
      ),
    );
  }
}
