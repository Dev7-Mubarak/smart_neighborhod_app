import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/circular_logo.dart';
import 'package:smart_negborhood_app/core/common/widgets/custom_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/defult_button.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
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
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.validateEmail,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
