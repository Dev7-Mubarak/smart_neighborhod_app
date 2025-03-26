import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/login_cubit/login_cubit.dart';
import 'package:smart_neighborhod_app/cubits/login_cubit/login_state.dart';
import '../components/boldText.dart';
import '../components/circular_logo.dart';
import '../components/constants/app_color.dart';
import '../components/constants/app_route.dart';
import '../components/default_text_form_filed.dart';
import '../components/defult_button.dart';
import '../core/API/dio_consumer.dart';
import '../cubits/forgetapassword/forgetapassword_cubit.dart';

class forgetapassword extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final passwordContoller = TextEditingController();

  final isLoading = false;
  forgetapassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetapasswordCubit(),
      child: BlocConsumer<ForgetapasswordCubit, ForgetapasswordState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.white,
              elevation: 0, // إزالة الخط السفلي
              bottomOpacity: 0,
              iconTheme: IconThemeData(
                color: Colors.black, // تغيير لون سهم الرجوع إلى الأسود
              ),
              // لإزالة السهم الإفتراضي التي تضعة فلاتر و إضافة سهم مخصص في الجهة اليمنى
              // leading: Container(), // إزالة السهم الافتراضي من اليسار
              // actions: [
              //   IconButton(
              //     icon:
              //         Icon(Icons.arrow_back, color: Colors.black), // زر الرجوع
              //     onPressed: () {
              //       Navigator.pop(context); // الرجوع إلى الصفحة السابقة
              //     },
              //   ),
              // ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Align(
                          alignment: Alignment.topLeft, child: CircularLogo()),
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
                          DefaultTextFormFiled(
                            hintText: 'قم بإدخال الأيميل',
                            controller: passwordContoller,
                            keyboardType: TextInputType
                                .emailAddress, // تحديد نوع الإدخال كإيميل
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'قم بإدخال عنوان البريد الإلكتروني';
                              }

                              // التحقق من صحة البريد الإلكتروني باستخدام RegExp
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                              if (!emailRegex.hasMatch(value)) {
                                return 'الرجاء إدخال بريد إلكتروني صالح';
                              }

                              return null;
                            },
                            isPassword: false,
                            suffixIcon: null,
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
                            // إستدعاء فنكشن من الكيوبت تقوم بعمل ركوست إلى ال API ,و إرسال الإيميل معه
                            Navigator.pushNamed(
                              context,
                              AppRoute.checkEmail,
                            );
                          }
                        },
                        fontsize: 20,
                      ),
                    )
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
