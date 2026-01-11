import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';

import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/app_validator.dart';
import '../../cubits/residential_units_cubit/residential_units_cubit.dart';

class ChangeUnitNameWidget extends StatefulWidget {
  const ChangeUnitNameWidget({super.key});
  @override
  State<ChangeUnitNameWidget> createState() => _ChangeUnitNameWidgetState();
}

class _ChangeUnitNameWidgetState extends State<ChangeUnitNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _unitNameController;
  late final ResidentialUnitsCubit _unitsCubit;

  @override
  void initState() {
    super.initState();
    _unitsCubit = context.read<ResidentialUnitsCubit>();
    _unitNameController = TextEditingController(
      text: _unitsCubit.selectedUnit?.unitName ?? '',
    );
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _unitNameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _unitNameController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _unitNameController.dispose();
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
            controller: _unitNameController,
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
                      _unitsCubit.updateUnit(name: _unitNameController.text);
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
