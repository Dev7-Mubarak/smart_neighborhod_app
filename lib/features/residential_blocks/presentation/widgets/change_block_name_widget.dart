import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';

import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/app_validator.dart';
import '../../cubits/residential_blocks_cubit/residential_blocks_cubit.dart';

class ChangeBlockNameWidget extends StatefulWidget {
  const ChangeBlockNameWidget({super.key});
  @override
  State<ChangeBlockNameWidget> createState() => _ChangeBlockNameWidgetState();
}

class _ChangeBlockNameWidgetState extends State<ChangeBlockNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _blockNameController;
  late final ResidentialBlocksCubit _blocksCubit;

  @override
  void initState() {
    super.initState();
    _blocksCubit = context.read<ResidentialBlocksCubit>();
    _blockNameController = TextEditingController(
      text: _blocksCubit.selectedBlock?.name ?? '',
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
    return Form(
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
            validator: AppValidator.validateEmptyField,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final id = _blocksCubit.selectedBlock?.id;
                      if (id != null) {
                        _blocksCubit.updateBlock(
                          id: id,
                          name: _blockNameController.text,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: AppColor.white,
                  ),
                  child: Text(locale.confirm),
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
    );
  }
}
