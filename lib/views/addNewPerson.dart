// import 'dart:html';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/boldText.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/default_text_form_filed.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';

import '../components/CustomDropdown.dart';
import '../components/NavigationBar.dart';

class addNewPerson extends StatefulWidget {
  const addNewPerson({super.key});

  @override
  State<addNewPerson> createState() => _addNewPersonState();
}

class _addNewPersonState extends State<addNewPerson> {
  // لإدارة اختيار الصورة
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // دالة لاختيار الصورة من المعرض
  Future<void> _pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _pickedImage = File(imageFile.path);
      });
    }
  }

  // للتحكم في مربعي الاختيار
  bool isCall = false;
  bool isWhatsApp = false;
  // حقول تحكم بالنصوص
  final TextEditingController incomeController =
      TextEditingController(); // الدخل الكلي

  final TextEditingController fatherNameController =
      TextEditingController(); // اسم رب الأسرة (حاليًا للأمثلة)
  final TextEditingController identityNumberController =
      TextEditingController(); // رقم الهوية
  final TextEditingController birthDateController =
      TextEditingController(); // تاريخ الميلاد
  final TextEditingController phoneNumberController =
      TextEditingController(); // رقم الجوال
  final TextEditingController emailController =
      TextEditingController(); // الإيميل

  // القوائم المنسدلة (Dropdowns)
  String? selectedIdentityType; // نوع الهوية
  String? selectedGender; // الجنس
  String? selectedBloodType; // فصيلة الدم
  String? selectedStatus; // الحالة
  String? selectedRole; // دور الفرد

  // أمثلة بيانات للاختبار
  final List<String> houseTypes = ['ملك', 'إيجار'];

  final List<String> identityTypes = ['بطاقة شخصية', 'جواز سفر'];
  // سنزيل الـ dropdown القديم للجنس ونستخدم Radio Buttons بدلاً منه
  final List<String> bloodTypes = [
    '+A',
    '-A',
    '+B',
    '-B',
    '+O',
    '-O',
    '+AB',
    '-AB'
  ];
  final List<String> statuses = ['موظف', 'عاطل', 'طالب'];
  final List<String> roles = ['أب', 'أم', 'ابن', 'ابنة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'إضافة فرد جديد',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // قسم معلومات رب الأسرة
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColor.gray,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  boldtext(
                    fontcolor: Colors.black54,
                    fontsize: 20,
                    text: 'اسم الأسرة:باوزير',
                    boldSize: .3,
                  ),
                  const SizedBox(height: 20),
                  // الأسماء الأربعة
                  subname(text: 'الأسم الأول'),
                  const SizedBox(height: 8),
                  DefaultTextFormFiled(
                    bordercolor: AppColor.gray2,
                    fillcolor: AppColor.white,
                    hintText: 'الأسم الأول',
                    controller: fatherNameController,
                    isPassword: false,
                    keyboardType: TextInputType.text,
                    suffixIcon: null,
                    validator: (value) {},
                  ),
                  const SizedBox(height: 20),
                  subname(text: 'الأسم الثاني'),
                  const SizedBox(height: 8),
                  DefaultTextFormFiled(
                    bordercolor: AppColor.gray2,
                    fillcolor: AppColor.white,
                    hintText: 'الأسم الثاني',
                    controller: fatherNameController,
                    isPassword: false,
                    keyboardType: TextInputType.text,
                    suffixIcon: null,
                    validator: (value) {},
                  ),
                  const SizedBox(height: 20),
                  subname(text: 'الأسم الثالث'),
                  const SizedBox(height: 8),
                  DefaultTextFormFiled(
                    bordercolor: AppColor.gray2,
                    fillcolor: AppColor.white,
                    hintText: 'الأسم الثالث',
                    controller: fatherNameController,
                    isPassword: false,
                    keyboardType: TextInputType.text,
                    suffixIcon: null,
                    validator: (value) {},
                  ),
                  const SizedBox(height: 20),
                  subname(text: 'الأسم الرابع'),
                  const SizedBox(height: 8),
                  DefaultTextFormFiled(
                    bordercolor: AppColor.gray2,
                    fillcolor: AppColor.white,
                    hintText: 'الأسم الرابع',
                    controller: fatherNameController,
                    isPassword: false,
                    keyboardType: TextInputType.text,
                    suffixIcon: null,
                    validator: (value) {},
                  ),
                  const SizedBox(height: 20),

                  // نوع الهوية و رقم الهوية جنبًا إلى جنب
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        // Expanded الأول: نوع الهوية
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              subname(text: 'نوع الهوية'),
                              const SizedBox(height: 8),
                              CustomDropdown(
                                items: identityTypes,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedIdentityType = newValue;
                                  });
                                },
                                selectedValue: selectedIdentityType,
                                text: 'نوع الهوية',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Expanded الثاني: رقم الهوية
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              subname(text: 'رقم الهوية '),
                              const SizedBox(height: 8),
                              DefaultTextFormFiled(
                                bordercolor: AppColor.gray2,
                                fillcolor: AppColor.white,
                                hintText: 'رقم الهوية',
                                controller: identityNumberController,
                                isPassword: false,
                                keyboardType: TextInputType.number,
                                suffixIcon: null,
                                validator: (value) {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // الجنس بشكل Radio Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      subname(text: 'الجنس'),
                      // const SizedBox(height: 8),
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // اختيار ذكر
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'ذكر',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                subname(
                                  text: 'ذكر',
                                )
                              ],
                            ),
                            const SizedBox(width: 30),
                            // اختيار أنثى
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'أنثى',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                const subname(text: 'انثى')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // رقم التواصل
                  subname(text: 'رقم التواصل'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone,
                          color: AppColor.primaryColor, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: DefaultTextFormFiled(
                          bordercolor: AppColor.gray2,
                          fillcolor: AppColor.white,
                          hintText: 'رقم التواصل',
                          controller: phoneNumberController,
                          isPassword: false,
                          keyboardType: TextInputType.phone,
                          suffixIcon: null,
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  subname(text: 'طريقةالإتصال'),
                  SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // خيار "اتصال"
                        Row(
                          children: [
                            subname(text: 'اتصال'),
                            Checkbox(
                              value: isCall,
                              activeColor: AppColor.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCall = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // خيار "واتس اب"
                        Row(
                          children: [
                            subname(text: 'واتس اب'),
                            Checkbox(
                              value: isWhatsApp,
                              activeColor: AppColor.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  isWhatsApp = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // الإيميل
                  subname(text: 'الإيميل'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.email,
                          color: AppColor.primaryColor, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: DefaultTextFormFiled(
                          bordercolor: AppColor.gray2,
                          fillcolor: AppColor.white,
                          hintText: 'الإيميل',
                          controller: emailController,
                          isPassword: false,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: null,
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // تاريخ الميلاد
                  subname(text: 'تاريخ الميلاد'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: AppColor.primaryColor, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: DefaultTextFormFiled(
                          bordercolor: AppColor.gray2,
                          fillcolor: AppColor.white,
                          hintText: 'تاريخ الميلاد',
                          controller: birthDateController,
                          isPassword: false,
                          keyboardType: TextInputType.datetime,
                          suffixIcon: null,
                          validator: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // فصيلة الدم
                  subname(text: 'فصيلة الدم'),
                  const SizedBox(height: 8),
                  CustomDropdown(
                    selectedValue: selectedBloodType,
                    items: bloodTypes,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBloodType = newValue;
                      });
                    },
                    text: 'فصيلة الدم',
                  ),

                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              subname(text: 'الحالة'),
                              const SizedBox(height: 8),
                              CustomDropdown(
                                selectedValue: selectedStatus,
                                items: statuses,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedStatus = newValue;
                                  });
                                },
                                text: 'الحالة',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // دور الفرد
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              subname(text: 'دور الفرد'),
                              const SizedBox(height: 8),
                              CustomDropdown(
                                selectedValue: selectedRole,
                                items: roles,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedRole = newValue;
                                  });
                                },
                                text: 'دور الفرد',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  // زر إضافة صورة شخصية + مربع الصورة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallButton(
                        text: 'إضافة صورة شخصية',
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _pickedImage == null
                            ? const Icon(Icons.person,
                                size: 60, color: Colors.grey)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            // أزرار الإضافة والإلغاء
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallButton(
                  text: 'إلغاء',
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                SmallButton(
                  text: 'إضافة',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: navigationBar(),
    );
  }
}

class subname extends StatelessWidget {
  const subname({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: boldtext(
        boldSize: .1,
        fontcolor: Colors.black54,
        fontsize: 16,
        text: text,
      ),
    );
  }
}
