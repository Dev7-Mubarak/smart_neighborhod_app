import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';

import '../../components/NavigationBar.dart';
import '../../components/subname.dart';
import '../../components/table.dart';
import '../../models/moahadat.dart';

class ProfilePage extends StatelessWidget {
  List<moahadat> moahadatList = [
    moahadat('معاهدات', "عدم إلحاق الضرر بالمعل العامة", DateTime(2002), true),
    moahadat('أتفاق', "عدم إلحاق الضرر بالمعل العامة", DateTime(2003), true),
    moahadat('معاهدات', "عدم إلحاق الضرر بالمعل العامة", DateTime(2005), true),
    moahadat('معاهدات', "عدم إلحاق الضرر بالمعل العامة", DateTime(2024), true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 290,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 90, color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'فاطمة علي',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      ':الجنس',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'أنثى',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':تاريخ الميلاد',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: '25\1\1975',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':نوع الهوية',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'بطاقة شخصية',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':رقم الهوية',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: '245322',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':رقم الجوال',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: '777555444',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':طريقة الاتصال',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'اتصال و واتس اب',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':الإيميل',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'sarah@gmail.com',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'الحالة',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'موظفة',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':الوظيفة',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'معلمة',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':فصيلة الدم',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'O+',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':حالة الفرد',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'متزوج',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      ':دور الفرد',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const subname(
                      text: 'أم',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('المعاملات:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    CustomTableWidget(
                      columnFlexes: [2, 2, 3, 2, 1.5],
                      columnTitles: [
                        "تمت المعاملة",
                        'التاريخ',
                        'الإسم',
                        'نوع المعاملة',
                        'رقم'
                      ],
                      rowData: moahadatList.asMap().entries.map((entry) {
                        int index = entry.key;
                        var moahadat = entry.value;
                        return [
                          '${moahadat.moahadatDone}',
                          '${moahadat.moahadatDate}',
                          moahadat.moahadatName,
                          moahadat.moahadatType,
                          '${index + 1}'
                        ];
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Center(child: SmallButton(text: 'تعديل', onPressed: () {})),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const navigationBar());
  }
}
