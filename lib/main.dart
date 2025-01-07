import 'package:flutter/material.dart';
import 'test.dart';
import 'views/mainhome.dart';
import 'views/onboarding.dart';

void main() {
  runApp(const SmartNeighbourhood());
}

class SmartNeighbourhood extends StatelessWidget {
  const SmartNeighbourhood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      fontFamily: 'Tajawal-Regular',
      ),
      home: mainhome(),
    );
  }
}
