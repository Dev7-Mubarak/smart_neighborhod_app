import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/cubits/login_cubit/login_cubit.dart';
import 'package:smart_negborhood_app/cubits/login_cubit/login_state.dart';
import 'package:smart_negborhood_app/generated/l10n.dart';

import '../../components/circular_logo.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/app_route.dart';
import '../../components/default_text_form_filed.dart';
import '../../components/defult_button.dart';
import '../../components/language_toggle_button.dart';
import '../../core/API/dio_consumer.dart';

class Login extends StatelessWidget {
  final isPassword = true;
  final formKey = GlobalKey<FormState>();
  final emailContoller = TextEditingController();
  final passwordContoller = TextEditingController();

  final isLoading = false;
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(api: DioConsumer(dio: Dio())),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushNamed(context, AppRoute.mainHome);
            //  print(state.userdata.id);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                LanguageToggleButton(),
                const SizedBox(width: 16),
              ],
            ),
            body: Center(
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
                    Text(
                      S.of(context).appTitle,
                      style: const TextStyle(
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
                          Text(
                            S.of(context).usernameLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DefaultTextFormFiled(
                            hintText: S.of(context).enterUsername,
                            controller: emailContoller,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).pleaseEnterUsername;
                              }
                              return null;
                            },
                            suffixIcon: Icons.person,
                            isPassword: false,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            S.of(context).passwordLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DefaultTextFormFiled(
                            hintText: S.of(context).enterPassword,
                            controller: passwordContoller,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).pleaseEnterPassword;
                              }
                              return null;
                            },
                            suffixIcon: Icons.key,
                            isPassword: LoginCubit.get(context).isPassword,
                            prefixIcon: LoginCubit.get(context).prefixIcon,
                            onPrefixIconPressed: () {
                              LoginCubit.get(context).changePasswordVisibilty();
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
                            child: Text(
                              S.of(context).forgotPassword,
                              style: const TextStyle(
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
                    ConditionalBuilder(
                      condition: state is! LoginLoading,
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      builder: (context) => DefaultButton(
                        text: S.of(context).login,
                        backgroundColor: AppColor.primaryColor,
                        color: AppColor.white,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).signIn(
                              email: emailContoller.text,
                              password: passwordContoller.text,
                            );
                            // Navigator.pushNamed(
                            //   context,
                            //   AppRoute.mainhome,
                            // );
                          }
                        },
                        fontsize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
