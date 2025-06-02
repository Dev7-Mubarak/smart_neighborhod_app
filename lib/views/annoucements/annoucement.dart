import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/smallButton.dart';

import '../../components/custom_navigation_bar.dart';
import '../../models/Announcemwnt.dart';

class announcement extends StatefulWidget {
  @override
  _announcementState createState() => _announcementState();
}

class _announcementState extends State<announcement> {
  @override
  void initState() {
    super.initState();
    announcementsdisplay = announcements; // نسخ القائمة الأصلية
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
//       appBar: AppBar(
//         backgroundColor: AppColor.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: const Center(
//           child: Text(
//             'الإعلانات',
//             style: TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
//           ),
//         ),
//       ),
//       body:
//       SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColor.primaryColor,
//                       minimumSize: const Size(40, 40),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       "إضافة",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SearchWidget<Announcement>(
//                     originalList: announcements,
//                     onSearch: updateSearchResults,
//                     searchCriteria: (announcement) => announcement.title,
//                   ),
//                 ],
//               ),
//             ),

//             // Expanded(
//             //   child: ListView.builder(
//             //     itemCount: announcementsdisplay.length,
//             //     itemBuilder: (context, index) {
//             //       final announcement = announcementsdisplay[index];

//             //       return Container(
//             //         width: double.infinity,
//             //         color: AppColor.gray,
//             //         margin:
//             //             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             //         child: SingleChildScrollView(
//             //           child: Row(
//             //             children: [
//             //               Container(
//             //                 padding: const EdgeInsets.all(5), // مسافة داخلية للعنصر
//             //                 decoration: BoxDecoration(
//             //                   color: Colors.amber,
//             //                   // announcement.getColorFromString(announcement.type),
//             //                   borderRadius: BorderRadius.circular(15),
//             //                 ),
//             //                 child: Stack(
//             //                   children: [
//             //                     // الصورة مائلة إلى جهة اليمين
//             //                     Positioned(
//             //                       right: 0, // محاذاة الصورة إلى الجهة اليمنى
//             //                       top: 20, // إزاحة الصورة قليلاً نحو الأعلى
//             //                       left: 20,
//             //                       child:
//             //                           //  announcement.getIconFromString(announcement.type))
//             //                           Image.asset(
//             //                         AppImage.gas,
//             //                         width: 60, // عرض الصورة
//             //                         height: 60, // ارتفاع الصورة
//             //                         fit: BoxFit.contain, // احتواء الصورة داخل الحجم
//             //                       ),
//             //                     )
//             //                   ],
//             //                 ),
//             //               ),
//             //               boldtext(
//             //                 boldSize:.4,
//             //                 fontcolor: Colors.black,
//             //                 fontsize: 18,
//             //                 text: announcement.title,
//             //               ),
//             //               subname(
//             //                 text: "${announcement.date} - ${announcement.time}",
//             //               ),
//             //               Icon(Icons.share),
//             //             ],
//             //           ),
//             //         ),
//             //       );
//             //     },
//             //   ),
//             // ),
//             ...
//  announcementsdisplay.map<Widget>((announcement) {
//   return Container(
//     width: 100,
//     color: AppColor.gray,
//     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         children: [
//           Container(
//             width: 100,
//             padding: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               color: Colors.amber,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   right: 0,
//                   top: 20,
//                   left: 20,
//                   child: Image.asset(
//                     AppImage.gas,
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 5), // مسافة بين العناصر
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 boldtext(
//                   boldSize: .4,
//                   fontcolor: Colors.black,
//                   fontsize: 16,
//                   text: announcement.title,
//                 ),
//                 subname(
//                   text: "${announcement.date} - ${announcement.time}",
//                 ),
//               ],
//             ),
//           ),
//           Icon(Icons.share),
//         ],
//       ),
//     ),
//   );
// }).toList(),
// ...

//             // announcementsdisplay.map<Widget>((announcement){
//             // return Container(
//             //   width: 100,
//             //   color: AppColor.gray,
//             //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(10),
//             //     child: Row(
//             //       children: [
//             //         Container(
//             //           width: 100,
//             //           padding: const EdgeInsets.all(5),
//             //           decoration: BoxDecoration(
//             //             color: Colors.amber,
//             //             borderRadius: BorderRadius.circular(15),
//             //           ),
//             //           child: Stack(
//             //             children: [
//             //               Positioned(
//             //                 right: 0,
//             //                 top: 20,
//             //                 left: 20,
//             //                 child: Image.asset(
//             //                   AppImage.gas,
//             //                   width: 60,
//             //                   height: 60,
//             //                   fit: BoxFit.contain,
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //         const SizedBox(width: 5), // مسافة بين العناصر

//             //         // معلومات الإعلان
//             //         Expanded(
//             //           child: Column(
//             //             crossAxisAlignment: CrossAxisAlignment.start,
//             //             children: [
//             //               boldtext(
//             //                 boldSize: .4,
//             //                 fontcolor: Colors.black,
//             //                 fontsize: 16,
//             //                 text: announcement.title,
//             //               ),
//             //               subname(
//             //                 text: "${announcement.date} - ${announcement.time}",
//             //               ),
//             //             ],
//             //           ),
//             //         ),

//             //         // أيقونة المشاركة
//             //         Expanded(child: Icon(Icons.share)),
//             //       ],
//             //     ),
//             //   ),
//             // );

//           ]
//         ),
//       ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

// return Container(
//   margin:
//       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   child: ListTile(
//     leading: Container(
//       padding: const EdgeInsets.all(5), // مسافة داخلية للعنصر
//       decoration: BoxDecoration(
//         color: Colors.amber,
//         // announcement.getColorFromString(announcement.type),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Stack(
//         children: [
//           // الصورة مائلة إلى جهة اليمين
//           Positioned(
//             right: 0, // محاذاة الصورة إلى الجهة اليمنى
//             top: 20, // إزاحة الصورة قليلاً نحو الأعلى
//             left: 20,
//             child:
//                 //  announcement.getIconFromString(announcement.type))
//                 Image.asset(
//               AppImage.gas,
//               width: 80, // عرض الصورة
//               height: 80, // ارتفاع الصورة
//               fit: BoxFit.contain, // احتواء الصورة داخل الحجم
//             ),
//           )
//         ],
//       ),
//     ),
//     title: boldtext(
//       boldSize: .4,
//       fontcolor: Colors.black,
//       fontsize: 18,
//       text: announcement.title,
//     ),
//     subtitle: subname(
//       text: "${announcement.date} - ${announcement.time}",
//     ),
//     trailing: const Icon(Icons.share),
//   ),
// );
