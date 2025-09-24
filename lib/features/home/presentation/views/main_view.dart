import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/home/presentation/views/home_view.dart';

import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../residdentailBlocks/presentation/views/residdential_blocks.dart';
import '../../../settings/presentation/views/setteings_view.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const HomeView(),
    const ResidentialBlockView(),
    const SettingsView(),
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
