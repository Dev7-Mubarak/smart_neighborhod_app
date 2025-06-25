import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smart_negborhood_app/components/constants/app_image.dart';

import '../../components/CustomDropdown.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../components/default_text_form_filed.dart';
import '../../components/smallButton.dart';
import '../../components/subname.dart';
import '../../services/DateHelper.dart';

class AddNewAnnouncement extends StatefulWidget {
  const AddNewAnnouncement({super.key});

  @override
  State<AddNewAnnouncement> createState() => _AddNewAnnouncementState();
}

class _AddNewAnnouncementState extends State<AddNewAnnouncement> {
  final TextEditingController nameBlockController = TextEditingController();
  final TextEditingController DatewriteTheAnnouncementController =
      TextEditingController();
  final TextEditingController AnnouncementDateController =
      TextEditingController();
  final TextEditingController TimeController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController PlacesController = TextEditingController();
  String? selectedWriter;
  String? selectedType;
  bool isRepeatedAd = false;
  String? selectedAnnouncementType;
  String? selectedTheParod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'الإعلانات',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Center(
                child: Text(
                  'إضافة إعلان',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColor.gray,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const subname(text: 'كاتب الإعلان'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            items: ['الشخص 1', 'الشخص 2', 'الشخص 3'],
                            onChanged: (newValue) {
                              setState(() {
                                selectedWriter = newValue;
                              });
                            },
                            selectedValue: selectedWriter,
                            text: 'كاتب الإعلان',
                            validator: (String) {
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.person,
                          color: AppColor.primaryColor,
                          size: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const subname(text: 'تاريخ كتابة الإعلان'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await DateTimeHelper.selectDate(
                              context,
                              DatewriteTheAnnouncementController,
                            );
                          },
                          child: const Icon(
                            Icons.calendar_month,
                            color: AppColor.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DefaultTextFormFiled(
                            bordercolor: AppColor.gray2,
                            fillcolor: AppColor.white,
                            hintText: 'تاريخ كتابة الإعلان',
                            controller: DatewriteTheAnnouncementController,
                            isPassword: false,
                            keyboardType:
                                TextInputType.none, // تعطيل لوحة المفاتيح
                            suffixIcon: null,
                            readOnly: true, // منع الإدخال اليدوي
                            onTap: () async {
                              await DateTimeHelper.selectDate(
                                context,
                                DatewriteTheAnnouncementController,
                              );
                            },
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const subname(text: 'نوع الإعلان'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const subname(text: 'إعلان مكرر'),
                        Radio<String>(
                          value: 'إعلان مكرر',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (selectedType == 'إعلان مكرر') ...[
                      const SizedBox(height: 20),
                      const subname(text: 'إسم الإعلان'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown(
                              items: [
                                'توزيع إسطوانات غاز',
                                'الإسم الثاني',
                                'الإسم الأول',
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedAnnouncementType = newValue;
                                });
                              },
                              selectedValue: selectedAnnouncementType,
                              text: 'إسم الإعلان',
                              validator: (String) {
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            AppImage.mic,
                            width: 40, // عرض الصورة
                            height: 40, // ارتفاع الصورة
                            // fit: BoxFit.contain, // احتواء الصورة داخل الحجم
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const subname(text: 'التاريخ'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await DateTimeHelper.selectDate(
                                context,
                                AnnouncementDateController,
                              );
                            },
                            child: const Icon(
                              Icons.calendar_month,
                              color: AppColor.primaryColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DefaultTextFormFiled(
                              bordercolor: AppColor.gray2,
                              fillcolor: AppColor.white,
                              hintText: '',
                              controller: AnnouncementDateController,
                              isPassword: false,
                              keyboardType:
                                  TextInputType.none, // تعطيل لوحة المفاتيح
                              suffixIcon: null,
                              readOnly: true, // منع الإدخال اليدوي
                              onTap: () async {
                                await DateTimeHelper.selectDate(
                                  context,
                                  AnnouncementDateController,
                                );
                              },
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const subname(text: 'الوقت'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await DateTimeHelper.selectTime(
                                context,
                                TimeController,
                              ); // استدعاء الدالة لاختيار الوقت
                            },
                            child: const Icon(
                              Icons.access_time, // أيقونة الوقت
                              color: AppColor.primaryColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DefaultTextFormFiled(
                              bordercolor: AppColor.gray2,
                              fillcolor: AppColor.white,
                              hintText: 'وقت الإعلان', // نص التوضيح
                              controller: TimeController, // تحكم النص
                              isPassword: false,
                              keyboardType:
                                  TextInputType.none, // تعطيل لوحة المفاتيح
                              suffixIcon: null,
                              readOnly: true, // منع الإدخال اليدوي
                              onTap: () async {
                                await DateTimeHelper.selectTime(
                                  context,
                                  TimeController,
                                ); // استدعاء الدالة عند النقر
                              },
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const subname(text: 'صباحاً'),
                          Radio<String>(
                            value: 'صباحاً',
                            groupValue: selectedTheParod,
                            onChanged: (value) {
                              setState(() {
                                selectedTheParod = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const subname(text: 'مساءً'),
                          Radio<String>(
                            value: 'مساءً',
                            groupValue: selectedTheParod,
                            onChanged: (value) {
                              setState(() {
                                selectedTheParod = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const subname(text: 'المكان'),
                      const SizedBox(height: 10),
                      DefaultTextFormFiled(
                        bordercolor: AppColor.gray2,
                        fillcolor: AppColor.white,
                        hintText: 'المكان',
                        controller: PlacesController,
                        isPassword: false,
                        keyboardType: TextInputType.name,
                        suffixIcon: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء إدخال المكان ';
                          }
                          return null;
                        },
                      ),
                      if (selectedAnnouncementType == "توزيع إسطوانات غاز") ...[
                        const SizedBox(height: 20),
                        const subname(text: 'عدد إسطوانات الغاز'),
                        const SizedBox(height: 10),
                        DefaultTextFormFiled(
                          bordercolor: AppColor.gray2,
                          fillcolor: AppColor.white,
                          hintText: 'عدد إسطوانات الغاز',
                          controller: PlacesController,
                          isPassword: false,
                          keyboardType: TextInputType.name,
                          suffixIcon: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'الرجاء إدخال عدد إسطوانات الغاز';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const subname(text: 'إعلان جديد'),
                        Radio<String>(
                          value: 'إعلان جديد',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (selectedType == 'إعلان جديد') ...[
                      const subname(text: 'نص الإعلان'),
                      const SizedBox(height: 10),
                      DefaultTextFormFiled(
                        bordercolor: AppColor.gray2,
                        fillcolor: AppColor.white,
                        hintText: 'نص الإعلان',
                        controller: PlacesController,
                        isPassword: false,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        suffixIcon: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء إدخال نص الإعلان';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallButton(text: 'إلغاء', onPressed: () {}),
                  const SizedBox(width: 10),
                  SmallButton(text: 'إضافة', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
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
