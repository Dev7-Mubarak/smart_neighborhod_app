import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';

class CustomTableWidget extends StatelessWidget {
  final List<String> columnTitles;
  final List<List<dynamic>> rowData;
  final List<double> columnFlexes;
  final void Function(int rowIndex, dynamic rowObject)? onRowLongPress;
  final List<dynamic>? originalObjects;
  final void Function(int rowIndex)? onRowTap;

  const CustomTableWidget({
    super.key,
    required this.columnTitles,
    required this.rowData,
    required this.columnFlexes,
    this.onRowLongPress,
    this.originalObjects,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColor.primaryColor),
          child: IntrinsicHeight(
            child: Row(
              children: columnTitles.asMap().entries.map((entry) {
                int colIndex = entry.key;
                String title = entry.value;
                return Expanded(
                  flex: columnFlexes[colIndex].toInt(),
                  child: _buildHeaderCell(title),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: rowData.length,
            itemBuilder: (context, index) {
              List<dynamic> row = rowData[index];
              return InkWell(
                onLongPress: () =>
                    onRowLongPress?.call(index, originalObjects?[index]),
                onTap: () => onRowTap?.call(index),

                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: IntrinsicHeight(
                    child: Row(
                      children: row.asMap().entries.map((cellEntry) {
                        int cellIndex = cellEntry.key;
                        dynamic cellData = cellEntry.value;
                        return Expanded(
                          flex: columnFlexes[cellIndex].toInt(),
                          child: _buildCell(cellData.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
