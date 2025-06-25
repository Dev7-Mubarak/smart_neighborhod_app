import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';

import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_image.dart';
import '../../components/searcharea.dart';
import '../../models/Announcemwnt.dart';

class announcement1 extends StatefulWidget {
  const announcement1({super.key});

  @override
  _announcement1State createState() => _announcement1State();
}

class _announcement1State extends State<announcement1> {
  @override
  void initState() {
    // TODO: implement initState
    announcementsdisplay = announcements;
  }

  List<Announcement> announcements = [
    Announcement(
      title: "سوف يتم بيع الأسطوانات غداً بتاريخ 2024/1/15 الساعة 11 صباحًا",
      date: DateTime(2024, 1, 15),
      time: "11 صباحًا",
      details: "بعدالة العمودي، عدد الأسطوانات محدود (60)",
      type: 'gas',
    ),
    Announcement(
      title: "بيع أكياس الروتي الطازج بتاريخ 2024/1/11 الساعة 9 صباحًا",
      date: DateTime(2024, 1, 11),
      time: "9 صباحًا",
      details: "بجانب بقالة العمودي، عدد الأكواب محدود",
      type: 'bread',
    ),
    Announcement(
      title:
          "توزيع السلال الغذائية للأسر المسجلة حسب الكشوف بتاريخ 2024/2/20 الساعة 8 مساءً عقب العشاء",
      date: DateTime(2024, 2, 20),
      time: "بعد صلاة العشاء",
      details: "بمسجد الحي، الأولوية للأسر المسجلة",
      type: 'basket',
    ),
    Announcement(
      title: "سوف يتم بيع الأسطوانات غداً بتاريخ 2025/1/15 الساعة 11 صباحًا",
      date: DateTime(2025, 1, 15),
      time: "11 صباحًا",
      details: "بعدالة العمودي، عدد الأسطوانات محدود (60)",
      type: 'gas',
    ),
    Announcement(
      title: "إعلان عن مبادرة خيرية لبيع الأدوات والمستلزمات الطلابية المخفضة",
      date: DateTime(2025, 3, 5),
      time: "8 صباحًا",
      details: "بيع المستلزمات بأسعار رمزية للأيتام وأبناء الأسر المحتاجة",
      type: 'notAlocated',
    ),
  ];
  List<Announcement> announcementsdisplay = [];

  void updateSearchResults(List<Announcement> filteredList) {
    setState(() {
      announcementsdisplay = filteredList;
    });
  }

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
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
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
                    SearchWidget<Announcement>(
                      originalList: announcements,
                      onSearch: updateSearchResults,
                      searchCriteria: (announcement2) => announcement2.title,
                    ),
                  ],
                ),
              ),
              ...announcementsdisplay.map<Widget>(
                (e) => caredAnnouncement(announcement: e),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

class caredAnnouncement extends StatelessWidget {
  // تحويل النص إلى أيقونة
  getIcon(String type) {
    switch (type) {
      case "gas":
        return AppImage.gas;
      case "basket":
        return AppImage.basket;
      case "bread":
        return AppImage.bread;
      default:
        return AppImage.homeMicrovon;
    }
  }

  // تحويل النص إلى لون
  Color getColor(String type) {
    switch (type) {
      case "gas":
        return Color(0xFFEFA98D);

      case "basket":
        return Color(0xFFE8618C);
      case "bread":
        return Color(0xFF22CCB2);

      default:
        return Color(0xFF237885);
    }
  }

  const caredAnnouncement({required this.announcement, super.key});
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.gray,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              announcement.title,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.5, // زيادة المسافة بين الأسطر
              ),
              softWrap: true, // يضمن أن النص يلتف بدلاً من تجاوزه
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              3,
              0,
            ), // مسافة داخلية للعنصر
            decoration: BoxDecoration(
              color: getColor(announcement.type),
              borderRadius: BorderRadius.circular(15),
            ),
            height: 130,
            width: 100,
            child: Image.asset(
              getIcon(announcement.type),
              width: 10, // عرض الصورة
              height: 10, // ارتفاع الصورة
              // fit: BoxFit.contain, // احتواء الصورة داخل الحجم
            ), // احتواء الصورة داخل الحجم
          ),
        ],
      ),
    );
  }
}
