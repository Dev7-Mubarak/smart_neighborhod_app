import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/data/models/BlockDetails.dart';

class BlockStatsSection extends StatelessWidget {
  final BlockDetails details;

  const BlockStatsSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('مدير المربع: ${details.managerName}', style: _style),
        SizedBox(height: 5),
        Text('عدد الأسر: ${details.familyCount}', style: _style),
      ],
    );
  }

  TextStyle get _style => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
}
