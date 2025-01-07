import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/constants/app_image.dart';

class ResidentialBlock extends StatefulWidget {
  const ResidentialBlock({super.key});

  @override
  State<ResidentialBlock> createState() => _ResidentialBlockState();
}

class _ResidentialBlockState extends State<ResidentialBlock> {
  @override
  Widget build(BuildContext context) {
    return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: 5, // عدد المربعات السكنية
                  itemBuilder: (context, index) {
                    return _buildHousingUnitCard(index + 1, context);
                  },
                ),
              ),
            ),
          ],
        );
  }
}


  // تصميم كرت المربع السكني
  Widget _buildHousingUnitCard(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // مسافة بين الكروت
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.gray,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade300,
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(AppImage.residentailimage, // صورة افتراضية للمربع السكني
              height: MediaQuery.of(context).size.width * 0.5, // ارتفاع الصورة ديناميكي
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "المربع السكني $index",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "مدير المربع: خالد أحمد",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  