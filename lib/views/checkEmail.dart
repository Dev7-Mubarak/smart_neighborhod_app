import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../components/boldText.dart';
import '../components/circular_logo.dart';
import '../components/constants/app_color.dart';
import '../components/constants/app_route.dart';
import '../components/defult_button.dart';
import '../cubits/checkEmail/check_email_cubit.dart';
import '../cubits/forgetapassword/forgetapassword_cubit.dart';

class checkEmail extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNumController = TextEditingController();
  final TextEditingController secondNumController = TextEditingController();
  final TextEditingController thirdNumController = TextEditingController();
  final TextEditingController fourthNumController = TextEditingController();

  final FocusNode firstFocus = FocusNode();
  final FocusNode secondFocus = FocusNode();
  final FocusNode thirdFocus = FocusNode();
  final FocusNode fourthFocus = FocusNode();

  checkEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckEmailCubit(),
      child: BlocConsumer<CheckEmailCubit, CheckEmailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                          alignment: Alignment.topLeft, child: CircularLogo()),
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
                              text: "التحقق من رمز الكود",
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "الرجاء إدخال رمز الكود الذي أرسلناه للتو إلى",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Ahmed@Khaled.com",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCodeCircle(
                                    firstNumController, firstFocus, secondFocus),
                                _buildCodeCircle(
                                    secondNumController, secondFocus, thirdFocus),
                                _buildCodeCircle(
                                    thirdNumController, thirdFocus, fourthFocus),
                                _buildCodeCircle(
                                    fourthNumController, fourthFocus, null),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "إعادة إرسال الكود في 00:32",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ConditionalBuilder(
                        condition: state is! SendEmailLoading,
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        builder: (context) => DefaultButton(
                          text: 'التالي',
                          backgroundColor: AppColor.primaryColor,
                          color: AppColor.white,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // كود الربط بالAPI  الذي نقوم فيه بإرسال الرمز وإرجاع قيمة
                              Navigator.pushNamed(context, AppRoute.createNewPassword);
                            }
                          },
                          fontsize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCodeCircle(TextEditingController controller,
      FocusNode currentFocus, FocusNode? nextFocus) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Center(
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال قيمة';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'الرجاء إدخال أرقام فقط';
            }
            return null;
          },
          controller: controller,
          focusNode: currentFocus,
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && nextFocus != null) {
              FocusScope.of(currentFocus.context!).requestFocus(nextFocus);
            }
          },
          // onSubmitted: (_) {
          //   if (nextFocus != null) {
          //     FocusScope.of(currentFocus.context!).requestFocus(nextFocus);
          //   }
          // },
          onEditingComplete: () {
            if (nextFocus != null) {
              FocusScope.of(currentFocus.context!).requestFocus(nextFocus);
            }
          },
        ),
      ),
    );
  }
}
