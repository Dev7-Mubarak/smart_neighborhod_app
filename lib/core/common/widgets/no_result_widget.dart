import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_negborhood_app/core/constants/app_image.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';

import 'vertical_image_and_text_widget.dart';

class NoResultWidget extends StatelessWidget {
  const NoResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return VerticalImageAndTextWidget(
      image: SvgPicture.asset(
        AppImage.noResultsFound,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      ),
      title: locale.noResultsFound,
    );
  }
}
