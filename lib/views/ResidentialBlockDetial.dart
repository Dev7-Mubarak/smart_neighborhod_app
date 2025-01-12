import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../components/constants/app_color.dart';

class ResiddentialBlocksDetail extends StatefulWidget {
  const ResiddentialBlocksDetail({super.key});

  @override
  State<ResiddentialBlocksDetail> createState() =>
      _ResiddentialBlocksDetailState();
      
}

class _ResiddentialBlocksDetailState extends State<ResiddentialBlocksDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0, // إزالة الخط السفلي
        bottomOpacity: 0,
        title:const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child:  Center(
            child: Text(
              'الحارة الذكية',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
       body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المربع السكني
            Container(
              margin: EdgeInsets.all(10),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/house_image.jpg'), // استبدل هذا بالصورة الخاصة بك
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // تفاصيل المربع السكني
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المربع السكني 1',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('مدير المربع: خالد أحمد'),
                  Text('عدد الأسر: 200'),
                  Text('عدد الأزواج: 50'),
                  Text('عدد الأبناء: 110'),
                ],
              ),
            ),
            Divider(thickness: 1, height: 30, color: Colors.grey),
            // عنوان الجدول
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'الأسر في المربع السكني',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // زر إضافة أسرة وشريط البحث
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('إضافة أسرة'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'بحث',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // الجدول
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(color: Colors.blue, width: 1),
                columnWidths:const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                },
                children: [
                  _buildTableRow(['رب الأسرة', 'التصنيف', 'رقم التواصل'], isHeader: true),
                  _buildTableRow(['محمد أحمد', '1', '123456789']),
                  _buildTableRow(['خالد صالح', '2', '987654321']),
                  _buildTableRow(['سعيد محمد', '3', '567891234']),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blue : Colors.white,
      ),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}


