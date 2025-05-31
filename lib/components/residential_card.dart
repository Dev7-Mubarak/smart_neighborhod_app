import 'package:flutter/material.dart';
import '../models/Block.dart';
import '../views/residdentailBlocks/residential_block_detial.dart';
import 'constants/app_color.dart';
import 'constants/app_image.dart';

class BuildHousingUnitCard extends StatelessWidget {
  final Block block;
  final void Function(BuildContext context, Block block) onLongPressCallback;

  const BuildHousingUnitCard({
    super.key,
    required this.block,
    required this.onLongPressCallback, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResiddentialBlocksDetail(block: block)),
      ),
      onLongPress: () {
        onLongPressCallback(context, block);
      },
      borderRadius: BorderRadius.circular(16), // نفس الانحناء للكرت
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // مسافة بين الكروت
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.gray,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AppImage.residentailimage.isEmpty
                  ? FadeInImage.assetNetwork(
                      height: MediaQuery.of(context).size.width *
                          0.5, // ارتفاع الصورة ديناميكي
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: AppImage.loadingimage,
                      image: AppImage.residentailimage,
                    )
                  : Image.asset(AppImage.residentailimage),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    block.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "مدير المربع: ${block.managerName}",
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
