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
import 'package:smart_negborhood_app/core/common/enums/identity_type.dart';
import 'package:smart_negborhood_app/core/common/enums/marital_status.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../data/models/family_detiles_model.dart';

class FamilyDetiles extends StatefulWidget {
  const FamilyDetiles({super.key, required this.familyId});

  final int familyId;
  @override
  State<FamilyDetiles> createState() => _FamilyDetilesState();
}

class _FamilyDetilesState extends State<FamilyDetiles> {
  @override
  void initState() {
    super.initState();
    final familyCubit = context.read<FamilyCubit>();
    familyCubit.getFamilyDetilesById(widget.familyId);
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
              return FamilyDetailsBody(state: state);
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
        bottomNavigationBar: const CustomNavigationBar(),
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
  const FamilyDetailsBody({super.key, required this.state});
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
          ),
          const SizedBox(height: 16),
          const _AddMemberButtonRow(),
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
  const _AddMemberButtonRow();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                infoRow('أسم الأسرة', familyDetiles.name),
                infoRow('المربع السكني', familyDetiles.blockName),
                infoRow('الموقع', familyDetiles.location),
                infoRow('نوع الأسرة', familyDetiles.familyTypeName),
                infoRow('تصنيف الأسرة', familyDetiles.familyCategoryName),
                infoRow(
                  'رب الأسرة',
                  familyDetiles.headOfFamily?.fullName ?? '',
                ),
                infoRow(
                  'رقم الجوال',
                  familyDetiles.headOfFamily?.phoneNumber ?? '',
                ),
                infoRow(
                  'الأيميل',
                  familyDetiles.familyMembers.isNotEmpty
                      ? familyDetiles.familyMembers.first.person.email ?? ''
                      : '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class FamilyMembersSection extends StatelessWidget {
  final List<FamilyMember> familyMembers;

  const FamilyMembersSection({super.key, required this.familyMembers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: familyMembers.length,
        itemBuilder: (context, index) {
          return MemberCard(familyMember: familyMembers[index]);
        },
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final FamilyMember familyMember;

  const MemberCard({super.key, required this.familyMember});

  @override
  Widget build(BuildContext context) {
    final familyCubit = context.read<FamilyCubit>();
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.familyMemberDetails,
          arguments: familyCubit..setFamilyMember(familyMember),
        );
      },
      onLongPress: () {
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
                          familyMember.person.gender == "ذكر"
                              ? Icons.male
                              : Icons.female,
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
                infoRow('رقم الهوية', familyMember.person.identityNumber),
                infoRow(
                  'نوع الهوية',
                  familyMember.person.identityType.arabicName,
                ),
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
