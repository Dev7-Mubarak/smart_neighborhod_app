import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/home/presentation/views/home_view.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/views/residential_neighborhood_view.dart';
import '../../../../core/common/cubits/navigation_cubit.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../settings/presentation/views/setteings_view.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  final List<Widget> _pages = const [
    HomeView(),
    ResidentialNeighborhoodView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: IndexedStack(index: selectedIndex, children: _pages),
            bottomNavigationBar: CustomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) =>
                  context.read<NavigationCubit>().changePage(index),
            ),
          );
        },
      ),
    );
  }
}
