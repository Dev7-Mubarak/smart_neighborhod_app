import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'boldText.dart';

class subname extends StatelessWidget {
  const subname({
    super.key,
    required this.text,
     this.fontsize=20,
     this.textAlign=TextAlign.right
  });
  final String text;
    final TextAlign textAlign;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: boldtext(
        textAlign:textAlign,
        boldSize: .1,
        fontcolor: Colors.black54,
        fontsize: fontsize,
        text: text,
      ),
    );
  }
}