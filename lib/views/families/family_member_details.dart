import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/on_failure_widget.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/models/family_member_details_model.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';

class FamilyMemberDetailsPage extends StatefulWidget {
  const FamilyMemberDetailsPage({super.key, required this.memberId});

  final int memberId;

  @override
  State<FamilyMemberDetailsPage> createState() => _FamilyMemberDetailsPageState();
}

class _FamilyMemberDetailsPageState extends State<FamilyMemberDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyCubit>().getFamilyMemberDetails(widget.memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FamilyMemberDetailsAppBar(),
      body: BlocBuilder<FamilyCubit, FamilyState>(
        builder: (context, state) {
          if (state is FamilyMemberDetailsFailure) {
            return OnFailureWidget(
              onRetry: () => context.read<FamilyCubit>().getFamilyMemberDetails(widget.memberId),
            );
          }
          if (state is FamilyMemberDetailsLoaded) {
            return FamilyMemberDetailsBody(memberDetails: state.familyMemberDetails);
          }
          if (state is FamilyMemberDetailsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري تحميل بيانات العضو...'),
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
    );
  }
}

class FamilyMemberDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FamilyMemberDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Center(
        child: Text(
          'معلومات العضو',
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

class FamilyMemberDetailsBody extends StatelessWidget {
  final FamilyMemberDetailsModel memberDetails;

  const FamilyMemberDetailsBody({super.key, required this.memberDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          MemberInfoCard(memberDetails: memberDetails),
          const SizedBox(height: 16),
          const _SectionTitle(title: 'تاريخ الاستخدامات'),
          const SizedBox(height: 16),
          UsageHistoryTable(usages: memberDetails.usages),
          const SizedBox(height: 16),
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

class MemberInfoCard extends StatelessWidget {
  final FamilyMemberDetailsModel memberDetails;

  const MemberInfoCard({super.key, required this.memberDetails});

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
                // Personal Information Section
                _buildSectionHeader('المعلومات الشخصية'),
                const SizedBox(height: 8),
                _buildInfoRow('الاسم الكامل', memberDetails.fullName),
                _buildInfoRow('الجنس', memberDetails.gender),
                _buildInfoRow('تاريخ الميلاد', memberDetails.birthDate),
                _buildInfoRow('فصيلة الدم', memberDetails.bloodType),
                _buildInfoRow('الحالة الاجتماعية', memberDetails.maritalStatus),
                _buildInfoRow('دور العائلة', memberDetails.familyRole),
                
                const SizedBox(height: 16),
                
                // Document Information Section
                _buildSectionHeader('معلومات الوثائق'),
                const SizedBox(height: 8),
                _buildInfoRow('نوع الوثيقة', memberDetails.documentType),
                _buildInfoRow('رقم الوثيقة', memberDetails.documentNumber),
                
                const SizedBox(height: 16),
                
                // Contact Information Section
                _buildSectionHeader('معلومات الاتصال'),
                const SizedBox(height: 8),
                _buildInfoRow('رقم الهاتف', memberDetails.phoneNumber),
                _buildInfoRow('البريد الإلكتروني', memberDetails.email),
                _buildInfoRow('طريقة الاتصال', memberDetails.contactMethod),
                
                const SizedBox(height: 16),
                
                // Work Information Section
                _buildSectionHeader('معلومات العمل'),
                const SizedBox(height: 8),
                _buildInfoRow('الحالة المهنية', memberDetails.status),
                _buildInfoRow('المهنة', memberDetails.job),
                
                if (memberDetails.notes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionHeader('ملاحظات'),
                  const SizedBox(height: 8),
                  _buildInfoRow('الملاحظات', memberDetails.notes),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class UsageHistoryTable extends StatelessWidget {
  final List<ServiceUsage> usages;

  const UsageHistoryTable({super.key, required this.usages});

  @override
  Widget build(BuildContext context) {
    if (usages.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.gray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'لا توجد استخدامات مسجلة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Card(
        color: AppColor.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Table Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'النوع',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'الاسم',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'التاريخ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'الحالة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Table Body
              ...usages.map((usage) => _buildUsageRow(usage)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageRow(ServiceUsage usage) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                usage.type,
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                usage.name,
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                usage.date.isNotEmpty ? usage.date : '-',
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                usage.status,
                style: TextStyle(
                  fontSize: 13,
                  color: usage.status == '✓' ? Colors.green : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}