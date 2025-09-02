import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/text_styles.dart';

class VerticalImageAndTextWidget extends StatelessWidget {
  const VerticalImageAndTextWidget({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
  });

  final Widget image;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: image,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: TextStyles.bold20.copyWith(color: AppColor.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                style: TextStyles.regular14.copyWith(color: AppColor.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
