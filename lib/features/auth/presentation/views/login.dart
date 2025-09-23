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
import 'package:smart_negborhood_app/features/auth/cubits/login_cubit/login_cubit.dart';
import 'package:smart_negborhood_app/features/auth/cubits/login_cubit/login_state.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final isPassword = true;

  final formKey = GlobalKey<FormState>();

  final emailContoller = TextEditingController();

  final passwordContoller = TextEditingController();

  late LoginCubit loginCubit;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    loginCubit = context.read<LoginCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    passwordContoller.dispose();
    emailContoller.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          context.showLoadingDialog();
        } else if (state is LoginSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pushReplacementNamed(context, AppRoute.mainHome);
        } else if (state is LoginFailure) {
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
                          "البريد الإكتروني للمستخدم :",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        CustomTextFormField(
                          hintText: 'قم بإدخال البريد الإلكتروني ',
                          controller: emailContoller,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidator.validateEmail,
                          prefixIcon: Icons.person,
                          focusNode: emailFocusNode,
                          onSubmitted: (value) {
                            // FocusScope.of(context).nextFocus();
                            FocusScope.of(
                              context,
                            ).requestFocus(passwordFocusNode);
                          },
                        ),
                        const SizedBox(height: AppSize.spasingBetweenInputBloc),
                        const Text(
                          "كلمة المرور :",
                          style: TextStyle(
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: AppSize.spasingBetweenInputsAndLabale,
                        ),
                        BlocBuilder<LoginCubit, LoginState>(
                          buildWhen: (previous, current) =>
                              current is ChangePasswordVisibility,
                          builder: (context, state) {
                            return CustomTextFormField(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: passwordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: AppValidator.validateEmptyField,
                              prefixIcon: Icons.key,
                              obscureText: LoginCubit.get(context).isPassword,
                              suffixIcon: LoginCubit.get(context).prefixIcon,
                              onsuffixIconPressed: () {
                                LoginCubit.get(
                                  context,
                                ).changePasswordVisibilty();
                              },
                              focusNode: passwordFocusNode,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.forgetapassword,
                            );
                          },
                          child: const Text(
                            "هل نسيت كلمة السر؟",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  DefaultButton(
                    text: 'تسجيل الدخول',
                    backgroundColor: AppColor.primaryColor,
                    color: AppColor.white,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        loginCubit.signIn(
                          email: emailContoller.text,
                          password: passwordContoller.text,
                        );
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
