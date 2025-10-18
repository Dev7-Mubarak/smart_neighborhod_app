import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/family_assistances_list_table.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/core/common/enums/blood_type.dart';
import 'package:smart_negborhood_app/core/common/enums/marital_status.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_member/family_member_cubit.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../auth/data/models/login_model.dart';
import '../../data/models/family_detiles_model.dart';

class FamilyDetiles extends StatefulWidget {
  const FamilyDetiles({super.key, required this.familyId});

  final int familyId;
  @override
  State<FamilyDetiles> createState() => _FamilyDetilesState();
}

class _FamilyDetilesState extends State<FamilyDetiles> {
  late final ProfileModel _profileModel;

  @override
  void initState() {
    super.initState();
    _getFamilyDetiles();
    _profileModel = SharedPreferencesService.getProfile()!;
  }

  void _getFamilyDetiles() async {
    final familyCubit = context.read<FamilyCubit>();
    await familyCubit.getFamilyDetilesById(widget.familyId);
    debugPrint('Family details loaded for family ID: ${widget.familyId}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilyCubit, FamilyState>(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddFamily) {
          context.showLoadingDialog();
        }
        if (state is FamilyMemberDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          // Refresh family details after deletion
          context.read<FamilyCubit>().getFamilyDetilesById(widget.familyId);
        } else if (state is FamilyFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
        if (state is FamilyMemberAddedSuccessfully) {
          context.read<FamilyCubit>().getFamilyDetilesById(widget.familyId);
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: Scaffold(
        appBar: const FamilyDetailsAppBar(),
        body: BlocBuilder<FamilyCubit, FamilyState>(
          builder: (context, state) {
            if (state is FamilyFailure) {
              return OnFailureWidget(
                onRetry: () => context.read<FamilyCubit>().getFamilyDetilesById(
                  widget.familyId,
                ),
              );
            }
            if (state is FamilyDetilesLoaded) {
              return FamilyDetailsBody(
                state: state,
                profileModel: _profileModel,
              );
            }
            if (state is FamilyLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('جاري تحميل بيانات الأسرة...'),
                  ],
                ),
              );
            }
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري التحضير...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FamilyDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FamilyDetailsAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Center(
        child: Text(
          'معلومات الأسرة',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FamilyDetailsBody extends StatelessWidget {
  final FamilyDetilesLoaded state;
  final ProfileModel profileModel;
  const FamilyDetailsBody({
    super.key,
    required this.state,
    required this.profileModel,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FamilyDetilesCard(familyDetiles: state.familyDetiles),
          const SizedBox(height: 16),
          const _SectionTitle(title: 'أفراد الأسرة'),
          const SizedBox(height: 16),
          FamilyMembersSection(
            familyMembers: state.familyDetiles.familyMembers,
            profileModel: profileModel,
          ),
          const SizedBox(height: 16),
          if (profileModel.role == AppRole.Admin.name)
            _AddMemberButtonRow(state.familyDetiles.headOfFamily),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Divider(
              color: Color.fromARGB(255, 44, 44, 44),
              thickness: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle(title: 'المساعدات المقدمة للأسرة'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchableTextFormField(
                        // controller: _searchController,
                        hintText: 'بحث باسم رب الأسرة',
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close),
                        ),
                        prefixIcon: Icons.search,
                        bachgroundColor: AppColor.gray2,
                        // onChanged: _onSearchChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FamilyAssistancesListTable(
                  familyAssisytances: state.familyDetiles.assistances,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}

class _AddMemberButtonRow extends StatelessWidget {
  final HeadOfFamily? selectedFamilyHead;
  const _AddMemberButtonRow(this.selectedFamilyHead);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SmallButton(
            text: 'إضافة فرد جديد',
            onPressed: () {
              final familyCubit = context.read<FamilyCubit>();
              familyCubit.selectedFamilyHead = selectedFamilyHead;
              Navigator.pushNamed(
                context,
                AppRoute.addFamilyMember,
                arguments: familyCubit,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FamilyDetilesCard extends StatelessWidget {
  final FamilyDetilesModel familyDetiles;
  const FamilyDetilesCard({super.key, required this.familyDetiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Card(
        color: AppColor.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Modern family avatar & name
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColor.primaryColor.withOpacity(0.12),
                    child: Icon(
                      Icons.groups,
                      color: AppColor.primaryColor,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          familyDetiles.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                familyDetiles.location,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Divider(color: Colors.grey[300], thickness: 1.2),
              const SizedBox(height: 10),
              // Modern info rows with icons
              _modernInfoRow(
                Icons.apartment,
                'المربع السكني',
                familyDetiles.blockName,
              ),
              _modernInfoRow(
                Icons.category,
                'تصنيف الأسرة',
                familyDetiles.familyCategoryName,
              ),
              _modernInfoRow(
                Icons.person,
                'رب الأسرة',
                familyDetiles.headOfFamily?.fullName ?? '',
              ),
              _modernInfoRow(
                Icons.phone,
                'رقم الجوال',
                familyDetiles.headOfFamily?.phoneNumber ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 22),
          const SizedBox(width: 10),
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyMembersSection extends StatelessWidget {
  final List<FamilyMember> familyMembers;
  final ProfileModel profileModel;

  const FamilyMembersSection({
    super.key,
    required this.familyMembers,
    required this.profileModel,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'Rendering FamilyMembersSection with ${familyMembers.length} members',
    );
    return SizedBox(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: familyMembers.length,
        itemBuilder: (context, index) {
          return MemberCard(
            familyMember: familyMembers[index],
            profileModel: profileModel,
          );
        },
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final FamilyMember familyMember;
  final ProfileModel profileModel;

  const MemberCard({
    super.key,
    required this.familyMember,
    required this.profileModel,
  });

  @override
  Widget build(BuildContext context) {
    final familyCubit = context.read<FamilyCubit>();
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.familyMemberDetails,
          arguments: FamilyMemberCubit(api: DioConsumer(dio: Dio()))
            ..setFamilyMember(familyMember),
        );
      },
      onLongPress: () {
        if (profileModel.role == AppRole.Admin.name)
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'خيارات فرد الأسرة',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('حذف فرد الأسرة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmationDialog(
                        context,
                        familyMember,
                        familyCubit,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('تغيير دور فرد الأسرة'),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to change role screen or show dialog
                      // Navigator.pushNamed(
                      //   context,
                      //   AppRoute.changeFamilyMemberRole,
                      //   arguments: familyMember,
                      // );
                    },
                  ),
                ],
              ),
            ),
          );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Card(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Divider(height: 18, color: Colors.grey, thickness: 1),
                infoRow('رقم الجوال', familyMember.person.phoneNumber),
                infoRow(
                  'الجنس',
                  familyMember.person.gender == "Female" ? "أنثى" : "ذكر",
                ),
                infoRow(
                  'تاريخ الميلاد',
                  familyMember.person.dateOfBirth.toString().split(' ').first,
                ),
                infoRow('فصيلة الدم', familyMember.person.bloodType.arabicName),
                infoRow(
                  'الحالة الاجتماعية',
                  familyMember.person.maritalStatus.arabicName,
                ),
                infoRow('المهنة', familyMember.person.job ?? 'غير محدد'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.gray2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'اضغط للمزيد من التفاصيل',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    FamilyMember member,
    FamilyCubit familyCubit,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا الفرد من الأسرة؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                await familyCubit.deleteFamilyMember(
                  familyCubit.family!.id,
                  familyMember.familyMemberId,
                );
                Navigator.of(context).pop();
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  // Helper widget for info rows in Arabic
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
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(color: Colors.black54, fontSize: 15),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
