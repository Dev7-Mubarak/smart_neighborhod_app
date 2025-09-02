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
import 'package:smart_negborhood_app/features/auth/cubits/forgetapassword/forgetapassword_cubit.dart';

class CreateNewPassword extends StatefulWidget {
  CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final isPassword = true;

  final formKey = GlobalKey<FormState>();

  final SecondpasswordContoller = TextEditingController();

  final FirstpasswordContoller = TextEditingController();

  late ForgetapasswordCubit forgetapasswordCubit;
  final FocusNode firstFocus = FocusNode();
  final FocusNode secondFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    forgetapasswordCubit = context.read<ForgetapasswordCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    SecondpasswordContoller.dispose();
    FirstpasswordContoller.dispose();
    firstFocus.dispose();
    secondFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetapasswordCubit, ForgetapasswordState>(
      listener: (context, state) {
        if (state is SendNewPasswordLoading) {
          context.showLoadingDialog();
        } else if (state is SendNewPasswordSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pushNamed(context, AppRoute.mainHome);
        } else if (state is SendNewPasswordFailure) {
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
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
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
                          "انشأ كلمة مرور جديدة",
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "يجب أن تكون كلمة مرورك الجديدة مختلفة عن كلمة المرور المستخدمة سابقًا. ",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "كلمه المرور:",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<ForgetapasswordCubit, ForgetapasswordState>(
                          buildWhen: (previous, current) =>
                              current is ChangeFirstPasswordVisibility,
                          builder: (context, state) {
                            return CustomTextFormField(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: FirstpasswordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: AppValidator.validatePassword,
                              prefixIcon: Icons.key,
                              obscureText: forgetapasswordCubit.FirstisPassword,
                              suffixIcon: forgetapasswordCubit.FirstprefixIcon,
                              onsuffixIconPressed: () {
                                forgetapasswordCubit
                                    .changeFirstPasswordVisibilty();
                              },
                              focusNode: firstFocus,
                              onSubmitted: (value) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(secondFocus);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "يجب أن تحتوي على الأقل على 8 رموز ,وحرف كبير و حرف صغير و رمز و رقم",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const Text(
                          "أعد كتابة كلمة المرور:",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<ForgetapasswordCubit, ForgetapasswordState>(
                          buildWhen: (previous, current) =>
                              current is ChangeSecondPasswordVisibility,
                          builder: (context, state) {
                            return CustomTextFormField(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: SecondpasswordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: AppValidator.validatePassword,
                             prefixIcon : Icons.key,
                              obscureText:
                                  forgetapasswordCubit.SecondisPassword,
                             suffixIcon : forgetapasswordCubit.SecondprefixIcon,
                              onsuffixIconPressed: () {
                                forgetapasswordCubit
                                    .changeSecondPasswordVisibilty();
                              },
                              focusNode: secondFocus,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  DefaultButton(
                    text: 'إرسال',
                    backgroundColor: AppColor.primaryColor,
                    color: AppColor.white,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (FirstpasswordContoller.text ==
                            SecondpasswordContoller.text) {
                          forgetapasswordCubit.sendNewPassword(
                            FirstpasswordContoller.text,
                            SecondpasswordContoller.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('كلمة السر غير متطابقة مع الأخرى'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                    },
                    fontsize: AppSize.fontSizeOfBigButton,
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
