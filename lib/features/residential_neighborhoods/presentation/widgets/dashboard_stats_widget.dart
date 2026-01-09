import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_Dashboard_model.dart';

class DashboardStatsWidget extends StatelessWidget {
  final ResidentialNeighborhoodDashboardModel data;

  const DashboardStatsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            title: locale.Neighborhoods,
            count: data.totalNeighborhoods,
            icon: Icons.location_city,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            title: locale.Units,
            count: data.totalUnits,
            icon: Icons.home,
            color: const Color(0xFFEFA98D),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            title: locale.Blocks,
            count: data.totalBlocks,
            icon: Icons.grid_view,
            color: const Color(0xFFE8618C),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 222, 222, 222),
            blurRadius: 8,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
