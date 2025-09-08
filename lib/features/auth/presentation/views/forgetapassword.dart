import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/circular_logo.dart';
import 'package:smart_negborhood_app/core/common/widgets/custom_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/defult_button.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/utils/app_validator.dart';
import '../../cubits/forgetapassword/forgetapassword_cubit.dart';

class Forgetapassword extends StatefulWidget {
  const Forgetapassword({super.key});

  @override
  State<Forgetapassword> createState() => _ForgetapasswordState();
}

class _ForgetapasswordState extends State<Forgetapassword> {
  final formKey = GlobalKey<FormState>();

  final passwordContoller = TextEditingController();

  late ForgetapasswordCubit forgetapasswordCubit;
  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    forgetapasswordCubit = context.read<ForgetapasswordCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    passwordContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetapasswordCubit, ForgetapasswordState>(
      listener: (context, state) {
        if (state is SendEmailLoading) {
          context.showLoadingDialog();
        } else if (state is SendEmailSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pushNamed(
            context,
            AppRoute.checkEmail,
            arguments: BlocProvider.of<ForgetapasswordCubit>(context),
          );
        } else if (state is SendEmailFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          bottomOpacity: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(
             AppSize.paddingOfPage,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 40),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: CircularLogo(),
                    ),
                  ),
                  Text(
                    context.locale.appTitle,
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSize.spasingBetweenAppTitleAndForm),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "نسيت كلمة المرور",
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "لا تقلق! الرجاء إدخال الأيميل",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "الإيميل",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                        CustomTextFormField(
                          hintText: 'قم بإدخال الأيميل',
                          controller: passwordContoller,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidator.validateEmail,
                          suffixIcon: null,
                          focusNode: emailFocusNode,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  DefaultButton(
                    text: 'التالي',
                    backgroundColor: AppColor.primaryColor,
                    color: AppColor.white,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        forgetapasswordCubit.sendEmail(passwordContoller.text);
                      }
                    },
                    fontsize:  AppSize.fontSizeOfBigButton,
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
