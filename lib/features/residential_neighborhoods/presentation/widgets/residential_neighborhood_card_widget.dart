import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_image.dart';
import '../../data/models/residential_neighborhood_model.dart';

class ResidentialNeighborhoodCardWidget extends StatelessWidget {
  final ResidentialNeighborhoodModel residentialNeighborhood;
  final void Function(
    BuildContext context,
    ResidentialNeighborhoodModel residentialNeighborhood,
  )
  onLongPressCallback;
  final void Function(
    BuildContext context,
    ResidentialNeighborhoodModel residentialNeighborhood,
  )
  onTapCallback;

  const ResidentialNeighborhoodCardWidget({
    super.key,
    required this.residentialNeighborhood,
    required this.onLongPressCallback,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    var locale = context.locale;
    return InkWell(
      onTap: () {
        onTapCallback(context, residentialNeighborhood);
      },
      onLongPress: () {
        onLongPressCallback(context, residentialNeighborhood);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.gray,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AppImage.residentailimage.isNotEmpty
                  ? Image.asset(
                      AppImage.residentailimage,
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: AppImage.loadingimage,
                      image: AppImage.residentailimage,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(AppImage.residentailimage);
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    residentialNeighborhood.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${locale.blockManager}: ${residentialNeighborhood.neighborhoodManagerName}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
