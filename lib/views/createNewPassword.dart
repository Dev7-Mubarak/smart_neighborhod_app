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
import '../cubits/NewPassword/new_password_cubit.dart';

class createNewPassword extends StatelessWidget {
  final isPassword = true;
  final formKey = GlobalKey<FormState>();
  final SecondpasswordContoller = TextEditingController();
  final FirstpasswordContoller = TextEditingController();

  final isLoading = false;
  createNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPasswordCubit(),
      child: BlocConsumer<NewPasswordCubit, NewPasswordState>(
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
                            child: CircularLogo()),
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
                              text: "انشأ كلمة مرور جديدة",
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
                            DefaultTextFormFiled(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: FirstpasswordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                                                 if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال كلمة المرور';
                                  }
                                  if (value.length < 8) {
                                    return 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
                                  }
                                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';
                                  }
                                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
                                  }
                                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                      .hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل';
                                  }
                                  return null;
                      
                              },
                              suffixIcon: Icons.key,
                              isPassword:
                                  NewPasswordCubit.get(context).FirstisPassword,
                              prefixIcon:
                                  NewPasswordCubit.get(context).FirstprefixIcon,
                              onPrefixIconPressed: () {
                                NewPasswordCubit.get(context)
                                    .changeFirstPasswordVisibilty();
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
                            DefaultTextFormFiled(
                              hintText: 'قم بإدخال كلمة المرور',
                              controller: SecondpasswordContoller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال كلمة المرور';
                                  }
                                  if (value.length < 8) {
                                    return 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
                                  }
                                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';
                                  }
                                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
                                  }
                                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                      .hasMatch(value)) {
                                    return 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل';
                                  }
                                  return null;
                      
                              },
                              suffixIcon: Icons.key,
                              isPassword: NewPasswordCubit.get(context)
                                  .SecondisPassword,
                              prefixIcon: NewPasswordCubit.get(context)
                                  .SecondprefixIcon,
                              onPrefixIconPressed: () {
                                NewPasswordCubit.get(context)
                                    .changeSecondPasswordVisibilty();
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ConditionalBuilder(
                        condition: state is! LoginLoading,
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        builder: (context) => DefaultButton(
                          text: 'إرسال',
                          backgroundColor: AppColor.primaryColor,
                          color: AppColor.white,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (FirstpasswordContoller.text == SecondpasswordContoller.text) {
                                // كود الربط بالAPI <حيث نرسل له كلمة السر ويقوم بإعاده تعيينها
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.mainhome,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('كلمة السر غير متطابقة مع الأخرى'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
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
}
