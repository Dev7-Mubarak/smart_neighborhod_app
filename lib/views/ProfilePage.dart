import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';

import '../components/NavigationBar.dart';
import '../components/boldText.dart';
import '../components/subname.dart';
import '../components/table.dart';
import '../models/family.dart';
import '../models/moahadat.dart';

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
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.only(
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
                  Text(
                    ':الجنس',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'أنثى',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':تاريخ الميلاد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: '25\1\1975',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':نوع الهوية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'بطاقة شخصية',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':رقم الهوية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: '245322',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':رقم الجوال',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: '777555444',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':طريقة الاتصال',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'اتصال و واتس اب',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':الإيميل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'sarah@gmail.com',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'الحالة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'موظفة',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':الوظيفة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'معلمة',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':فصيلة الدم',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'O+',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':حالة الفرد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'متزوج',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ':دور الفرد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subname(
                    text: 'أم',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text('المعاملات:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                       '${moahadat.moahadatDone}' ,
                       '${moahadat.moahadatDate}' ,
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
      bottomNavigationBar: const navigationBar()
    );
  }
}
