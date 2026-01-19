import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/utils/app_validator.dart';
import '../../cubits/government_institution/government_institution_cubit.dart';
import '../../cubits/government_institution/government_institution_state.dart';
import '../../data/models/government_institution.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';

class AddUpdateGovernmentInstitution extends StatefulWidget {
  const AddUpdateGovernmentInstitution({super.key, this.institution});
  final GovernmentInstitution? institution;
  @override
  State<AddUpdateGovernmentInstitution> createState() =>
      AddUpdateGovernmentInstitutionState();
}

class AddUpdateGovernmentInstitutionState
    extends State<AddUpdateGovernmentInstitution> {
  late final TextEditingController nameController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GovernmentInstitutionCubit institutionCubit;

  @override
  void initState() {
    super.initState();
    institutionCubit = context.read<GovernmentInstitutionCubit>();
    nameController = TextEditingController(
      text: widget.institution?.name ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GovernmentInstitutionCubit, GovernmentInstitutionState>(
      listener: (context, state) {
        if (state is WaitAddedUpdatedGovernmentInstitution) {
          context.showLoadingDialog();
        } else if (state is GovernmentInstitutionAddedSuccessfully ||
            state is GovernmentInstitutionUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message = (state is GovernmentInstitutionAddedSuccessfully)
              ? state.message
              : (state as GovernmentInstitutionUpdatedSuccessfully).message;
          context.showSuccessSnackBar(message);
        } else if (state is GovernmentInstitutionFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            widget.institution == null
                ? 'إضافة جهة حكومية'
                : 'تعديل جهة حكومية',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const SmallText(text: 'اسم الجهة'),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: nameController,
                  hintText: 'ادخل اسم الجهة',
                  validator: (value) => AppValidator.validateEmptyField(value),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SmallButton(
                    text: widget.institution == null ? 'إضافة' : 'تعديل',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.institution == null) {
                          institutionCubit.addNewGovernmentInstitution(
                            nameController.text.trim(),
                          );
                        } else {
                          institutionCubit.updateGovernmentInstitution(
                            id: widget.institution!.id,
                            name: nameController.text.trim(),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
