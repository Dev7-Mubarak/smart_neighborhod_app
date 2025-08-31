import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/circular_logo.dart';
import 'package:smart_negborhood_app/core/common/widgets/custom_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/defult_button.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
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

  final isLoading = false;
  late ForgetapasswordCubit forgetapasswordCubit;

  @override
  void initState() {
    super.initState();
    forgetapasswordCubit = context.read<ForgetapasswordCubit>();
  }

  @override
  void dispose() {
    SecondpasswordContoller.dispose();
    FirstpasswordContoller.dispose();
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
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CircularLogo(),
                    ),
                  ),
                  const Text(
                    "الحارة الذكية",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          ":كلمة المرور",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<ForgetapasswordCubit, ForgetapasswordState>(
                          buildWhen: (previous, current) =>
                              current is ChangeFirstPasswordVisibility,
                          builder: (context, state) {
                            return CustomTextFormField(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: FirstpasswordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator:AppValidator.validatePassword,
                              suffixIcon: Icons.key,
                              obscureText: forgetapasswordCubit.FirstisPassword,
                              prefixIcon: forgetapasswordCubit.FirstprefixIcon,
                              onPrefixIconPressed: () {
                                forgetapasswordCubit
                                    .changeFirstPasswordVisibilty();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "يجب أن تحتوي على الأقل على 8 رموز ,وحرف كبير و حرف صغير و رمز و رقم",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          ":أعد كتابة كلمة المرور",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<ForgetapasswordCubit, ForgetapasswordState>(
                          buildWhen: (previous, current) =>
                              current is ChangeSecondPasswordVisibility,
                          builder: (context, state) {
                            return CustomTextFormField(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: SecondpasswordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: AppValidator.validatePassword,
                              suffixIcon: Icons.key,
                              obscureText:
                                  forgetapasswordCubit.SecondisPassword,
                              prefixIcon: forgetapasswordCubit.SecondprefixIcon,
                              onPrefixIconPressed: () {
                                forgetapasswordCubit
                                    .changeSecondPasswordVisibilty();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
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
                    fontsize: 20,
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
