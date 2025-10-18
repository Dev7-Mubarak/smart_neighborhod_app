import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import '../../../../core/common/cubits/navigation_cubit.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../widgets/home_category_Card_list_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late final ProfileModel? _profile;
  @override
  void initState() {
    _profile = SharedPreferencesService.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        bottomOpacity: 0,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                context.read<NavigationCubit>().changePage(2);
              },
              borderRadius: BorderRadius.circular(50),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColor.primaryColor,
                child: Text(
                  _profile?.email.isNotEmpty == true
                      ? _profile!.email[0].toUpperCase()
                      : '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            InkWell(
              onTap: () {
                context.read<NavigationCubit>().changePage(2);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً,',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      _profile?.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            IconButton(
              icon: Icon(
                Icons.notifications_rounded,
                color: AppColor.primaryColor.withOpacity(0.9),
                size: 28,
              ),
              onPressed: () {},
              tooltip: 'الاشعارات',
            ),
          ],
        ),
        centerTitle: false,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.white, AppColor.gray.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const HomeCategoryCardListWidget(),
      ),
    );
  }
}
