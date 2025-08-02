import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/custom_text_input_filed.dart';

import '../../components/boldText.dart';
import '../../components/circular_logo.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/app_route.dart';
import '../../components/default_text_form_filed.dart';
import '../../components/defult_button.dart';
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

  @override
  void initState() {
    super.initState();
    forgetapasswordCubit = context.read<ForgetapasswordCubit>();
  }

  @override
  void dispose() {
    passwordContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
     BlocListener<ForgetapasswordCubit, ForgetapasswordState>(
      listener: (context, state) {
        if (state is SendEmailLoading){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PopScope(
              canPop: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is SendEmailSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamed(context, AppRoute.checkEmail);
        } else if (state is SendEmailFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } 
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          bottomOpacity: 0,
          iconTheme: IconThemeData(color: Colors.black),
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
                      const boldtext(
                        boldSize: .4,
                        fontcolor: AppColor.primaryColor,
                        fontsize: 25,
                        text: "نسيت كلمة المرور",
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "لا تقلق! الرجاء إدخال الأيميل",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "الإيميل",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        hintText: 'قم بإدخال الأيميل',
                        controller: passwordContoller,
                        keyboardType: TextInputType
                            .emailAddress, 
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'قم بإدخال عنوان البريد الإلكتروني';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'الرجاء إدخال بريد إلكتروني صالح';
                          }

                          return null;
                        },
                        suffixIcon: null,
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
                     fontsize: 20,
                   ),
                // ConditionalBuilder(
                //   condition: state is! SendEmailLoading,
                //   fallback: (context) =>
                //       const Center(child: CircularProgressIndicator()),
                //   builder: (context) => DefaultButton(
                //     text: 'التالي',
                //     backgroundColor: AppColor.primaryColor,
                //     color: AppColor.white,
                //     onPressed: () {
                //       if (formKey.currentState!.validate()) {
                //         forgetapasswordCubit.sendEmail(passwordContoller.text);
                //       }
                //     },
                //     fontsize: 20,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
