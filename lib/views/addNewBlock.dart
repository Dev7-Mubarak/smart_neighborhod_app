import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../components/CustomDropdown.dart';
import '../components/NavigationBar.dart';
import '../components/boldText.dart';
import '../components/constants/app_color.dart';
import '../components/default_text_form_filed.dart';
import '../components/smallButton.dart';

class AddNewBlock extends StatefulWidget {
  const AddNewBlock({super.key});

  @override
  State<AddNewBlock> createState() => _AddNewBlockState();
}

class _AddNewBlockState extends State<AddNewBlock> {
  final TextEditingController nameBlockController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'إضافة مربع سكني جديد',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              boldtext(
                boldSize: .2,
                fontcolor: Colors.black54,
                fontsize: 18,
                text: 'اسم المربع السكني',
              ),
              SizedBox(
                height: 18,
              ),
              DefaultTextFormFiled(
                bordercolor: AppColor.gray2,
                fillcolor: AppColor.white,
                hintText: 'اسم المربع السكني',
                controller: nameBlockController,
                isPassword: false,
                keyboardType: TextInputType.name,
                suffixIcon: null,
                validator: (value) {},
              ),
              const SizedBox(height: 30),
              boldtext(
                boldSize: .2,
                fontcolor: Colors.black54,
                fontsize: 18,
                text: 'مدير المربع السكني ',
              ),
              const SizedBox(height: 18),
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColor.gray),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'اختر مديراً',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            items: ['مدير 1', 'مدير 2', 'مدير 3'],
                            onChanged: (newValue) {
                              setState(() {
                                selectedManager = newValue;
                              });
                            },
                            selectedValue: selectedManager,
                            text: 'اختر مديراً',
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(Icons.person,
                            color: AppColor.primaryColor, size: 40),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'اسم المستخدم',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormFiled(
                            hintText: 'اسم مدير المربع السكني',
                            bordercolor: AppColor.gray2,
                            fillcolor: AppColor.white,
                            controller: usernameController,
                            isPassword: false,
                            suffixIcon: null,
                            keyboardType: TextInputType.name,
                            validator: (value) {},
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(Icons.person,
                            color: AppColor.primaryColor, size: 40),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'كلمة المرور',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormFiled(
                            hintText: 'كلمة المرور',
                            bordercolor: AppColor.gray2,
                            fillcolor: AppColor.white,
                            controller: passwordController,
                            isPassword: false,
                            suffixIcon: null,
                            keyboardType: TextInputType.name,
                            validator: (value) {},
                          ),
                        ),
                        SizedBox(width: 10),
                        const Icon(Icons.visibility,
                            color: AppColor.primaryColor, size: 40),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallButton(
                    text: 'إلغاء',
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SmallButton(
                    text: 'إضافة',
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: navigationBar(),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
