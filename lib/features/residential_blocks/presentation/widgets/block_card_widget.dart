import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_blocks/data/models/residential_block_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/build_mini_state_widget.dart';

class BlockCardWidget extends StatelessWidget {
  final ResidentialBlockModel block;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const BlockCardWidget({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.block,
  });
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(251, 255, 255, 255),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.grid_view,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    block.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    block.managerName,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BuildMiniState(
              icon: Icons.home_work_outlined,
              label: "${block.familiesCount} ${locale.family}",
            ),
          ],
        ),
      ),
    );
  }
}
