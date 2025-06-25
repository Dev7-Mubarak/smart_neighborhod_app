import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/boldText.dart';
import '../../components/constants/app_image.dart';
import '../../components/searcharea.dart';
import '../../models/ReconciliationCouncil.dart';

class ReconciliationCouncilsScreen extends StatefulWidget {
  const ReconciliationCouncilsScreen({super.key});

  @override
  _ReconciliationCouncilsScreenState createState() =>
      _ReconciliationCouncilsScreenState();
}

class _ReconciliationCouncilsScreenState
    extends State<ReconciliationCouncilsScreen> {
  @override
  void initState() {
    super.initState(); // استدعاء super.initState()
    reconciliationCouncilsDisplay = reconciliationCouncilsList;
  }

  List<ReconciliationCouncil> reconciliationCouncilsList = [
    ReconciliationCouncil(
      First_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
      Notes: 'اتل ئسايلا ىاسؤلاىئا سلاىؤ سىاؤلا ىئا ؤىياساى سيؤاىسلا',
      Second_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Session_Date: DateTime(2024, 1, 15),
      Session_Output: 'تم الصلح بنجاح ولله الحمد',
      Supervisor: 'سالم بن نبهان',
      Treaty_Done: true,
      Witnesses: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      tital: 'نزاع على ملكية عقار',
    ),
    ReconciliationCouncil(
      First_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
      Notes: 'اتل ئسايلا ىاسؤلاىئا سلاىؤ سىاؤلا ىئا ؤىياساى سيؤاىسلا',
      Second_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Session_Date: DateTime(2024, 1, 15),
      Session_Output: 'تم الصلح بنجاح ولله الحمد',
      Supervisor: 'سالم بن نبهان',
      Treaty_Done: true,
      Witnesses: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      tital: 'نزاع على ملكية عقار',
    ),
    ReconciliationCouncil(
      First_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
      Notes: 'اتل ئسايلا ىاسؤلاىئا سلاىؤ سىاؤلا ىئا ؤىياساى سيؤاىسلا',
      Second_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Session_Date: DateTime(2024, 1, 15),
      Session_Output: 'تم الصلح بنجاح ولله الحمد',
      Supervisor: 'سالم بن نبهان',
      Treaty_Done: true,
      Witnesses: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      tital: 'نزاع على ملكية عقار',
    ),
    ReconciliationCouncil(
      First_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
      Notes: 'اتل ئسايلا ىاسؤلاىئا سلاىؤ سىاؤلا ىئا ؤىياساى سيؤاىسلا',
      Second_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Session_Date: DateTime(2024, 1, 15),
      Session_Output: 'تم الصلح بنجاح ولله الحمد',
      Supervisor: 'سالم بن نبهان',
      Treaty_Done: true,
      Witnesses: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      tital: 'نزاع على ملكية عقار',
    ),
    ReconciliationCouncil(
      First_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
      Notes: 'اتل ئسايلا ىاسؤلاىئا سلاىؤ سىاؤلا ىئا ؤىياساى سيؤاىسلا',
      Second_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Session_Date: DateTime(2024, 1, 15),
      Session_Output: 'تم الصلح بنجاح ولله الحمد',
      Supervisor: 'سالم بن نبهان',
      Treaty_Done: true,
      Witnesses: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      tital: 'نزاع على ملكية عقار',
    ),
    ReconciliationCouncil(
      First_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Image_link: 'assets/images/ReconciliationCouncil/Container33.png',
      Notes: 'اتل ئسايلا ىاسؤلاىئا سلاىؤ سىاؤلا ىئا ؤىياساى سيؤاىسلا',
      Second_party: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      Session_Date: DateTime(2024, 1, 15),
      Session_Output: 'تم الصلح بنجاح ولله الحمد',
      Supervisor: 'سالم بن نبهان',
      Treaty_Done: true,
      Witnesses: [
        ["محمد سعيد", "2567222"],
        ["محمد علي", "556231"],
      ],
      tital: 'نزاع على ملكية عقار',
    ),
  ];
  List<ReconciliationCouncil> reconciliationCouncilsDisplay = [];

  void updateSearchResults(List<ReconciliationCouncil> filteredList) {
    setState(() {
      reconciliationCouncilsDisplay = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      minimumSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "إضافة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SearchWidget<ReconciliationCouncil>(
                    originalList: reconciliationCouncilsList,
                    onSearch: updateSearchResults,
                    searchCriteria: (ReconciliationCouncil1) =>
                        ReconciliationCouncil1.tital,
                  ),
                ],
              ),
              SizedBox(height: 20),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: reconciliationCouncilsDisplay
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.all(
                          10,
                        ), // مسافة داخلية للعنصر
                        decoration: BoxDecoration(
                          color: Color(0x80636AE8), // استخدام لون محدد
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 170, // أضف عرضًا ثابتًا
                              height: 100, // أضف ارتفاعًا ثابتًا
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(AppImage.residentailimage),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: boldtext(
                                // textAlign: TextAlign.center,
                                fontsize: 14,
                                text: e.tital,
                                fontcolor: Colors.black,
                                boldSize: .1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: boldtext(
                                fontsize: 14,
                                text:
                                    'الطرف الأول: ${e.First_party.isNotEmpty ? e.First_party[0] : "غير متوفر"}',
                                fontcolor: Colors.black,
                                boldSize: .1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: boldtext(
                                fontsize: 14,
                                text:
                                    'الطرف الثاني: ${e.Second_party.isNotEmpty ? e.Second_party[0] : "غير متوفر"}',
                                fontcolor: Colors.black,
                                boldSize: .1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: boldtext(
                                fontsize: 14,
                                text:
                                    ' تاريخ الجلسة: ${e.Session_Date ?? "غير متوفر"}',
                                fontcolor: Colors.black,
                                boldSize: .1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(), // تحويل map إلى قائمة
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
