import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/circular_logo.dart';
import 'package:smart_negborhood_app/core/common/widgets/defult_button.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/features/auth/cubits/forgetapassword/forgetapassword_cubit.dart';


class CheckEmail extends StatefulWidget {
  CheckEmail({super.key});

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNumController = TextEditingController();

  final TextEditingController secondNumController = TextEditingController();

  final TextEditingController thirdNumController = TextEditingController();

  final TextEditingController fourthNumController = TextEditingController();
  final TextEditingController fifthNumController = TextEditingController();
  final TextEditingController sixthNumController = TextEditingController();

  late ForgetapasswordCubit forgetapasswordCubit;

  final FocusNode firstFocus = FocusNode();

  final FocusNode secondFocus = FocusNode();

  final FocusNode thirdFocus = FocusNode();

  final FocusNode fourthFocus = FocusNode();
  final FocusNode fifthFocus = FocusNode();
  final FocusNode sixthFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    forgetapasswordCubit = context.read<ForgetapasswordCubit>();
  }

  @override
  void dispose() {
    firstNumController.dispose();
    secondNumController.dispose();
    thirdNumController.dispose();
    fourthNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetapasswordCubit, ForgetapasswordState>(
      listener: (context, state) {
        if (state is SendConfirmationCodeLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PopScope(
              canPop: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state is SendConfirmationCodeSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamed(context, AppRoute.createNewPassword
          ,arguments: BlocProvider.of<ForgetapasswordCubit>(context)
          );
        } else if (state is SendConfirmationCodeFailure) {
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
                    alignment: Alignment.topLeft,
                    child: CircularLogo(),
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
                        "التحقق من رمز الكود",
                        style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                        const SizedBox(height: 15),
                        const Text(
                          "الرجاء إدخال رمز الكود الذي أرسلناه للتو إلى الإيميل المدخل",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // const Text(
                        //   "Ahmed@Khaled.com",
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCodeCircle(
                              controller: firstNumController,
                              currentFocus: firstFocus,
                              nextFocus: secondFocus,
                            ),
                            buildCodeCircle(
                              controller: secondNumController,
                              currentFocus: secondFocus,
                              nextFocus: thirdFocus,
                            ),
                            buildCodeCircle(
                              controller: thirdNumController,
                              currentFocus: thirdFocus,
                              nextFocus: fourthFocus,
                            ),
                            buildCodeCircle(
                              controller: fourthNumController,
                              currentFocus: fourthFocus,
                              nextFocus: fifthFocus,
                            ),
                            buildCodeCircle(
                              controller: fifthNumController,
                              currentFocus: fifthFocus,
                              nextFocus: sixthFocus,
                            ),
                            buildCodeCircle(
                              controller: sixthNumController,
                              currentFocus: sixthFocus,
                              nextFocus: null,
                            ),
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
                  DefaultButton(
                    text: 'التالي',
                    backgroundColor: AppColor.primaryColor,
                    color: AppColor.white,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        forgetapasswordCubit.sendConfirmationCode(
                          "${firstNumController.text}${secondNumController.text}${thirdNumController.text}${fourthNumController.text}${fifthNumController.text}${sixthNumController.text}",
                        );
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

class buildCodeCircle extends StatelessWidget {
  const buildCodeCircle({
    super.key,
    required this.controller,
    required this.currentFocus,
    required this.nextFocus,
  });

  final TextEditingController controller;
  final FocusNode currentFocus;
  final FocusNode? nextFocus;

  @override
  Widget build(BuildContext context) {
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
            color: AppColor.primaryColor,
          ),
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
