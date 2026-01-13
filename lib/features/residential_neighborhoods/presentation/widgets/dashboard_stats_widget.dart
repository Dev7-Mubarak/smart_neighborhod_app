import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_Dashboard_model.dart';
import '../../../../core/common/widgets/stat_item_widget.dart';

class DashboardStatsWidget extends StatelessWidget {
  final ResidentialNeighborhoodDashboardModel data;

  const DashboardStatsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Row(
      children: [
        Expanded(
          child: StatItemWidget(
            title: locale.Neighborhoods,
            count: data.totalNeighborhoods,
            icon: Icons.location_city,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatItemWidget(
            title: locale.Units,
            count: data.totalUnits,
            icon: Icons.home,
            color: const Color(0xFFEFA98D),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatItemWidget(
            title: locale.Blocks,
            count: data.totalBlocks,
            icon: Icons.grid_view,
            color: const Color(0xFFE8618C),
          ),
        ),
      ],
    );
  }
}
