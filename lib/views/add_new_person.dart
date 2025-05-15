// import 'dart:html';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/boldText.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';
import '../components/CustomDropdown.dart';
import '../components/NavigationBar.dart';
import '../components/constants/small_text.dart';
import '../components/custom_text_input_filed.dart';

class addNewPerson extends StatefulWidget {
  const addNewPerson({super.key});

  @override
  State<addNewPerson> createState() => _addNewPersonState();
}

class _addNewPersonState extends State<addNewPerson> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _pickedImage = File(imageFile.path);
      });
    }
  }

  bool isCall = false;
  bool isWhatsApp = false;

  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController identityNumberController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedIdentityType;
  String? selectedGender;
  String? selectedBloodType;
  String? selectedStatus;
  String? selectedRole;

  final List<String> identityTypes = ['بطاقة شخصية', 'جواز سفر', 'شهادة ميلاد'];

  final List<String> statuses = ['موظف', 'عاطل', 'طالب'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'إضافة شخص جديد',
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
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColor.gray,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SmallText(text: 'الاسم الاول'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الاول',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم الثاني'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الثاني',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم الثالث'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الثالت',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'الاسم الربع'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'الاسم الرابع',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'رقم الهوية'),
                  const SizedBox(height: 6),
                  const CustomTextFormField(
                    hintText: 'رقم الهوية',
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'نوع الهوية'),
                  const SizedBox(height: 6),
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
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SmallText(text: 'الجنس'),
                      const SizedBox(height: 6),
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
                                const SmallText(
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
                                const SmallText(text: 'انثى')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'رقم التواصل'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Expanded(
                        child: CustomTextFormField(
                          hintText: 'رقم التواصل',
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: const Icon(
                          Icons.phone_callback,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'طريقة الإتصال'),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const SmallText(text: 'اتصال'),
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
                        Row(
                          children: [
                            const SmallText(text: 'واتس اب'),
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
                  const SizedBox(height: 20),
                  const SmallText(text: 'الإيميل'),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'الايميل',
                        ),
                      ),
                      Icon(
                        Icons.email,
                        color: AppColor.primaryColor,
                        size: 30,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'تاريخ الميلاد'),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'تاريخ الميلاد',
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color: AppColor.primaryColor,
                        size: 30,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SmallText(text: 'فصيلة الدم'),
                  const SizedBox(height: 6),
                  CustomDropdown(
                    selectedValue: selectedBloodType,
                    items: const [],
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
                              const SmallText(text: 'الحالة'),
                              const SizedBox(height: 6),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallButton(
                        text: 'إضافة صورة شخصية',
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
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
                      ),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
      bottomNavigationBar: const navigationBar(),
    );
  }
}

class SubName extends StatelessWidget {
  const SubName({
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
        fontsize: 12,
        text: text,
      ),
    );
  }
}
