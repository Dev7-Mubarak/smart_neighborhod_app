import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';

import '../../../../core/common/widgets/custom_text_input_filed.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/app_validator.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';

class ChangeNeighborhoodNameWidget extends StatefulWidget {
  const ChangeNeighborhoodNameWidget({super.key});
  @override
  State<ChangeNeighborhoodNameWidget> createState() =>
      _ChangeNeighborhoodNameWidgetState();
}

class _ChangeNeighborhoodNameWidgetState
    extends State<ChangeNeighborhoodNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _neighborhoodNameController;
  late final ResidentialNeighborhoodsCubit _neighborhoodCubit;

  @override
  void initState() {
    super.initState();
    _neighborhoodCubit = context.read<ResidentialNeighborhoodsCubit>();
    _neighborhoodNameController = TextEditingController(
      text: _neighborhoodCubit.residentialNeighborhood?.neighborhoodName ?? '',
    );
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _neighborhoodNameController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _neighborhoodNameController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _neighborhoodNameController.dispose();
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
            controller: _neighborhoodNameController,
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
                      _neighborhoodCubit.updateNeighborhood(
                        name: _neighborhoodNameController.text,
                      );
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
