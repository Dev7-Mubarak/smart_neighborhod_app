import 'package:flutter/material.dart';

import 'constants/app_color.dart';
import 'constants/app_image.dart';

class CircularLogo extends StatelessWidget {
  const CircularLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(29)),
          border: Border.all(color: AppColor.primaryColor, width: 0.3)),
      child: const Image(image: AssetImage(AppImage.logo)),
    );
  }
}
