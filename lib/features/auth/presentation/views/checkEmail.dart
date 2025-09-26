import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/TextFieldOTP.dart';
import 'package:smart_negborhood_app/core/common/widgets/circular_logo.dart';
import 'package:smart_negborhood_app/core/common/widgets/defult_button.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'dart:async';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
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
    firstNumController.dispose();
    secondNumController.dispose();
    thirdNumController.dispose();
    fourthNumController.dispose();
    fifthNumController.dispose();
    sixthNumController.dispose();
    firstFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetapasswordCubit, ForgetapasswordState>(
      listener: (context, state) {
        if (state is SendConfirmationCodeLoading) {
          context.showLoadingDialog();
        } else if (state is SendConfirmationCodeSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pushNamed(
            context,
            AppRoute.createNewPassword,
            arguments: BlocProvider.of<ForgetapasswordCubit>(context),
          );
        } else if (state is SendConfirmationCodeFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
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
                        Text(
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
                            fontSize: AppSize.textSizeOfLable,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFieldOTPWidget(
                              Focusnode: firstFocus,
                              first: true,
                              last: false,
                              controller: firstNumController,
                            ),
                            TextFieldOTPWidget(
                              controller: secondNumController,
                              first: false,
                              last: false,
                            ),
                            TextFieldOTPWidget(
                              controller: thirdNumController,
                              first: false,
                              last: false,
                            ),
                            TextFieldOTPWidget(
                              controller: fourthNumController,
                              first: false,
                              last: false,
                            ),
                            TextFieldOTPWidget(
                              controller: fifthNumController,
                              first: false,
                              last: false,
                            ),
                            TextFieldOTPWidget(
                              controller: sixthNumController,
                              first: false,
                              last: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.center,
                          child: ResendTimerWidget(
                            onResend: () {
                              forgetapasswordCubit.sendEmail(
                                context.read<ForgetapasswordCubit>().email,
                              );
                            },
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

class ResendTimerWidget extends StatefulWidget {
  final VoidCallback onResend; // دالة لإعادة الإرسال عند الضغط على الزر

  const ResendTimerWidget({super.key, required this.onResend});

  @override
  State<ResendTimerWidget> createState() => _ResendTimerWidgetState();
}

class _ResendTimerWidgetState extends State<ResendTimerWidget> {
  Timer? _timer;
  int _start = 60;
  bool _isResendButtonActive = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _isResendButtonActive = false;
      _start = 60;
    });

    const oneSec = Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendButtonActive = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isResendButtonActive
        ? TextButton(
            onPressed: () {
              widget.onResend(); // استدعاء دالة إعادة الإرسال
              startTimer(); // إعادة تشغيل المؤقت
            },
            child: const Text(
              "إعادة إرسال الكود",
              style: TextStyle(
                fontSize: 15,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Text(
            "إعادة إرسال الكود في 00:${_start.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
