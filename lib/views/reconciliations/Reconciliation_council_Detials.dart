import 'package:flutter/material.dart';

import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/app_image.dart';
import '../../components/subname.dart';
import '../../components/table.dart';
import '../../models/ReconciliationCouncil.dart';

class ReconciliationcouncilDetials extends StatefulWidget {
  const ReconciliationcouncilDetials({super.key});

  @override
  State<ReconciliationcouncilDetials> createState() =>
      _ReconciliationcouncilDetialsState();
}

class _ReconciliationcouncilDetialsState
    extends State<ReconciliationcouncilDetials> {
  ReconciliationCouncil reconciliationCouncil = ReconciliationCouncil(
    First_party: [
      ["محمد سعيد", "2567222"],
      ["محمد علي", "556231"]
    ],
    Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
    Notes: 'تفاصيل النزاع والملاحظات حول الجلسة',
    Second_party: [
      ["محمد سعيد", "2567222"],
      ["محمد علي", "556231"]
    ],
    Session_Date: DateTime(2024, 1, 15),
    Session_Output: 'تم الصلح بنجاح ولله الحمد',
    Supervisor: 'سالم بن نبهان',
    Treaty_Done: true,
    Witnesses: [
      ["محمد سعيد", "2567222"],
      ["محمد علي", "556231"]
    ],
    tital: 'نزاع على ملكية عقار',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'مجالس الصلح',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                reconciliationCouncil.tital,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: AssetImage(AppImage.cheate),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColor.gray),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    subname(text: ':الطرف الأول'),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTableWidget(
                      columnTitles: ['رقم الهوية', 'الإسم', 'رقم'],
                      columnFlexes: [2, 3, 1],
                      rowData: reconciliationCouncil.First_party.asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        var reconciliation = entry.value;
                        return [
                          reconciliation[1],
                          reconciliation[0],
                          '${index + 1}'
                        ];
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    subname(text: ':الطرف الثاني'),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTableWidget(
                      columnTitles: ['رقم الهوية', 'الإسم', 'رقم'],
                      columnFlexes: [2, 3, 1],
                      rowData: reconciliationCouncil.Second_party.asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        var reconciliation = entry.value;
                        return [
                          reconciliation[1],
                          reconciliation[0],
                          '${index + 1}'
                        ];
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    subname(text: ':الشهود'),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTableWidget(
                      columnTitles: ['رقم الهوية', 'الإسم', 'رقم'],
                      columnFlexes: [2, 3, 1],
                      rowData: reconciliationCouncil.Witnesses.asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        var reconciliation = entry.value;
                        return [
                          reconciliation[1],
                          reconciliation[0],
                          '${index + 1}'
                        ];
                      }).toList(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
