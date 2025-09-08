
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';

class TextFieldOTPWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool last;
  final bool first;
  final FocusNode? Focusnode;


  const TextFieldOTPWidget({
    required this.controller,
    required this.first,
    required this.last,
    super.key, this.Focusnode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Colors.blueGrey),
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextFormField(
        focusNode: Focusnode,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 8,
          ),
        ),
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          } else if (value.isEmpty && last == true) {}
        },
        textInputAction: TextInputAction.none,
      ),
    );
  }
}