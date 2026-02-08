import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_negborhood_app/core/common/enums/blood_type.dart';
import 'package:smart_negborhood_app/core/common/enums/marital_status.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';

class ResidentialBlockFamilyMembersView extends StatefulWidget {
  const ResidentialBlockFamilyMembersView({super.key});

  @override
  State<ResidentialBlockFamilyMembersView> createState() =>
      _ResidentialBlockFamilyMembersViewState();
}

class _ResidentialBlockFamilyMembersViewState
    extends State<ResidentialBlockFamilyMembersView> {
  late TextEditingController _searchingController;
  late FamilyCubit _familyCubit;

  Timer? _delay;
  @override
  void initState() {
    super.initState();
    _familyCubit = context.read<FamilyCubit>();
    _searchingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;
    return BlocBuilder<FamilyCubit, FamilyState>(
      buildWhen: (previous, current) =>
          current is FamilyLoading ||
          current is FamilyDetilesLoaded ||
          current is FamilyFailure,
      builder: (context, state) {
        String title = locale.familyMembers;

        if (state is FamilyDetilesLoaded) {
          title = state.familyDetiles.name;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      SmallButton(
                        text: locale.add,
                        onPressed: () {
                          // _familyCubit.selectedFamilyHead = selectedFamilyHead;

                          Navigator.pushNamed(
                            context,
                            AppRoute.addFamilyMember,
                            arguments: _familyCubit,
                          ).then((_) {
                            _familyCubit.getFamilyDetilesById(
                              _familyCubit.familyId!,
                            );
                          });
                        },
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: SearchableTextFormField(
                          controller: _searchingController,
                          hintText: locale.lookingFamilyMembers,
                          bachgroundColor: AppColor.gray2,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _searchingController.clear();
                              _familyCubit.filterFamilyMembers('');
                            },
                            icon: const Icon(Icons.close),
                          ),
                          prefixIcon: Icons.search,
                          onChanged: (String query) {
                            _delay?.cancel();
                            _delay = Timer(
                              const Duration(milliseconds: 300),
                              () {
                                _familyCubit.filterFamilyMembers(query.trim());
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  Expanded(child: _buildBody(state, crossAxisCount, locale)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(FamilyState state, int crossAxisCount, locale) {
    if (state is FamilyLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FamilyFailure) {
      return OnFailureWidget(onRetry: () {});
    }

    if (state is FamilyDetilesLoaded) {
      if (state.allFamilyMembers.isEmpty) {
        return Center(child: NoResultWidget());
      }

      return SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: state.allFamilyMembers.map((family) {
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: MemberCard(familyMember: family),
            );
          }).toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class MemberCard extends StatelessWidget {
  final FamilyMember familyMember;

  const MemberCard({super.key, required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColor.gray,
                child: familyMember.person.image != null
                    ? ClipOval(
                        child: Image.network(
                          familyMember.person.image!,
                          fit: BoxFit.cover,
                          width: 64,
                          height: 64,
                        ),
                      )
                    : Icon(
                        familyMember.person.gender == "Female"
                            ? Icons.woman
                            : Icons.man,
                        size: 36,
                        color: Colors.blueGrey,
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                familyMember.person.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(height: 18, color: Colors.grey, thickness: 1),
              infoRow('الدور', familyMember.role.roleName),
              infoRow('رقم الجوال', familyMember.person.phoneNumber),
              infoRow(
                'الجنس',
                familyMember.person.gender == "Female" ? "أنثى" : "ذكر",
              ),
              infoRow('فصيلة الدم', familyMember.person.bloodType.arabicName),
              infoRow(
                'الحالة الاجتماعية',
                familyMember.person.maritalStatus.arabicName,
              ),
              infoRow('المهنة', familyMember.person.job ?? 'غير محدد'),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
