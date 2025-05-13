import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';

class CustomTableWidget extends StatelessWidget {
  final List<String> columnTitles; // عناوين الأعمدة
  final List<List<dynamic>> rowData; // بيانات الصفوف
  final List<double> columnFlexes; // توزيع عرض الأعمدة

  const CustomTableWidget({
    Key? key,
    required this.columnTitles,
    required this.rowData,
    required this.columnFlexes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: {
        for (int i = 0; i < columnFlexes.length; i++)
          i: FlexColumnWidth(columnFlexes[i])
      },
      children: [
        // رأس الجدول
        TableRow(
          decoration: const BoxDecoration(color: AppColor.primaryColor),
          children:
              columnTitles.map((title) => _buildHeaderCell(title)).toList(),
        ),
        // الصفوف الديناميكية
        ...rowData.asMap().entries.map((entry) {
          int index = entry.key;
          List<dynamic> row = entry.value;
          return TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            children: row.map((cellData) => _buildCell(cellData)).toList(),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
