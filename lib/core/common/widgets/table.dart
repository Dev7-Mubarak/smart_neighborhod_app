import 'package:flutter/material.dart';

class CustomTableWidget extends StatelessWidget {
  final List<String> columnTitles;
  final List<List<dynamic>> rowData;
  final List<int> columnFlexes;
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ======== Table Header ========
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1), // Indigo shade
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: columnTitles.asMap().entries.map((entry) {
                  final colIndex = entry.key;
                  final title = entry.value;

                  return Expanded(
                    flex: columnFlexes[colIndex],
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // ======== Table Rows ========
            if (rowData.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'لا توجد بيانات متاحة',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              )
            else
              ...rowData.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onRowTap?.call(index),
                  onLongPress: () =>
                      onRowLongPress?.call(index, originalObjects?[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: row.asMap().entries.map((cellEntry) {
                        final cellIndex = cellEntry.key;
                        final cellData = cellEntry.value;

                        return Expanded(
                          flex: columnFlexes[cellIndex],
                          child: Text(
                            cellData.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
