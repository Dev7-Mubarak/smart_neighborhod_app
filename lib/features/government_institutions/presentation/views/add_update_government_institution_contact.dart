import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/utils/app_validator.dart';
import '../../cubits/government_institution_contact/government_institution_contact_cubit.dart';
import '../../cubits/government_institution_contact/government_institution_contact_state.dart';
import '../../data/models/government_institution_contact.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/small_text.dart';
import '../../../../core/common/widgets/custom_text_input_filed.dart';

class AddUpdateGovernmentInstitutionContact extends StatefulWidget {
  const AddUpdateGovernmentInstitutionContact({super.key, this.contact});
  final GovernmentInstitutionContact? contact;
  @override
  State<AddUpdateGovernmentInstitutionContact> createState() =>
      AddUpdateGovernmentInstitutionContactState();
}

class AddUpdateGovernmentInstitutionContactState
    extends State<AddUpdateGovernmentInstitutionContact> {
  late final TextEditingController nameController;
  late final TextEditingController jobController;
  late final TextEditingController phoneController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GovernmentInstitutionContactCubit contactCubit;

  @override
  void initState() {
    super.initState();
    contactCubit = context.read<GovernmentInstitutionContactCubit>();
    nameController = TextEditingController(text: widget.contact?.name ?? '');
    jobController = TextEditingController(text: widget.contact?.job ?? '');
    phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      GovernmentInstitutionContactCubit,
      GovernmentInstitutionContactState
    >(
      listener: (context, state) {
        if (state is WaitAddedUpdatedGovernmentInstitutionContact) {
          context.showLoadingDialog();
        } else if (state is GovernmentInstitutionContactAddedSuccessfully ||
            state is GovernmentInstitutionContactUpdatedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
          final message =
              (state is GovernmentInstitutionContactAddedSuccessfully)
              ? state.message
              : (state as GovernmentInstitutionContactUpdatedSuccessfully)
                    .message;
          context.showSuccessSnackBar(message);
        } else if (state is GovernmentInstitutionContactFailure) {
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
            widget.contact == null ? 'إضافة جهة اتصال' : 'تعديل جهة اتصال',
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم'),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: nameController,
                    hintText: 'ادخل الاسم',
                    validator: (value) =>
                        AppValidator.validateEmptyField(value),
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الوظيفة'),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: jobController,
                    hintText: 'ادخل الوظيفة',
                    validator: (value) =>
                        AppValidator.validateEmptyField(value),
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'رقم الهاتف'),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: phoneController,
                    hintText: 'ادخل رقم الهاتف',
                    validator: (value) =>
                        AppValidator.validateEmptyField(value),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SmallButton(
                      text: widget.contact == null ? 'إضافة' : 'تعديل',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.contact == null) {
                            contactCubit.addGovernmentInstitutionContact(
                              name: nameController.text.trim(),
                              job: jobController.text.trim(),
                              phone: phoneController.text.trim(),
                            );
                          } else {
                            contactCubit.updateGovernmentInstitutionContact(
                              id: widget.contact!.id,
                              name: nameController.text.trim(),
                              job: jobController.text.trim(),
                              phone: phoneController.text.trim(),
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
      ),
    );
  }
}
