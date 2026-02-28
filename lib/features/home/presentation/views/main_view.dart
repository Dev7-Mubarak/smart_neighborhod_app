import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/enums/app_role.dart';
import 'package:smart_negborhood_app/core/services/shared_preferences_service.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import 'package:smart_negborhood_app/features/home/presentation/views/home_view.dart';
import 'package:smart_negborhood_app/features/residential_blocks/presentation/views/residential_block_view.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/views/residential_neighborhood_view.dart';
import 'package:smart_negborhood_app/features/residential_units/presentation/views/residential_unit_view.dart';
import '../../../../core/common/cubits/navigation_cubit.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../settings/presentation/views/setteings_view.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  ProfileModel? _profile;

  @override
  void initState() {
    super.initState();
    _profile = SharedPreferencesService.getProfile();
  }

  Widget _getRoleBasedView() {
    if (_profile?.role!.toLowerCase() ==
        AppRoles.unitManager.name.toLowerCase()) {
      return const ResidentialUnitView();
    } else if (_profile?.role!.toLowerCase() ==
        AppRoles.blockManager.name.toLowerCase()) {
      return const ResidentialBlockView();
    }
    return const ResidentialNeighborhoodView();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      _getRoleBasedView(),
      const SettingsView(),
    ];

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: IndexedStack(index: selectedIndex, children: pages),
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
