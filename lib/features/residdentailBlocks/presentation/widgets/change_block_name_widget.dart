import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/cubits/blockCubit/block_cubit.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/cubits/blockCubit/block_state.dart';

import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../../core/utils/validataion.dart';

class ChangeBlockNameWidget extends StatefulWidget {
  const ChangeBlockNameWidget({super.key});
  @override
  State<ChangeBlockNameWidget> createState() => _ChangeBlockNameWidgetState();
}

class _ChangeBlockNameWidgetState extends State<ChangeBlockNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _blockNameController;
  late final BlockCubit _blockCubit;

  @override
  void initState() {
    super.initState();
    _blockCubit = context.read<BlockCubit>();
    _blockNameController = TextEditingController(
      text: _blockCubit.block?.name ?? '',
    );
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _blockNameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _blockNameController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _blockNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return BlocListener<BlockCubit, BlockState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddBlock) {
          context.showLoadingDialog();
        }
        if (state is BlockUpdatedSuccessfully) {
          context.showSuccessSnackBar(state.message);
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
        } else if (state is BlocksFailure) {
          context.showErrorSnackBar(state.errorMessage);
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text(locale.changeBlockName),
            const SizedBox(height: 15),
            CustomTextFormField(
              focusNode: _focusNode,
              controller: _blockNameController,
              hintText: locale.changeBlockName,
              validator: Validataion.validateName,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _blockCubit.updateBlock(
                          id: _blockCubit.block!.id,
                          name: _blockNameController.text,
                        );
                      }
                    },
                    child: Text(locale.confirm),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(locale.cancel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
