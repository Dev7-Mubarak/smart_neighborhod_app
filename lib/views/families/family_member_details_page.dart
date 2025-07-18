import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/on_failure_widget.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/models/conflict_case.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';

class FamilyMemberDetailsPage extends StatefulWidget {
  final Person familyMember;
  
  const FamilyMemberDetailsPage({
    super.key, 
    required this.familyMember,
  });

  @override
  State<FamilyMemberDetailsPage> createState() => _FamilyMemberDetailsPageState();
}

class _FamilyMemberDetailsPageState extends State<FamilyMemberDetailsPage> {
  @override
  void initState() {
    super.initState();
    final familyCubit = context.read<FamilyCubit>();
    familyCubit.getConflictCasesByFamilyMember(widget.familyMember.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Center(
          child: Text(
            'تفاصيل عضو الأسرة',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMemberInfoCard(),
            const SizedBox(height: 16),
            const _SectionTitle(title: 'سجل الخدمات والنشاطات'),
            const SizedBox(height: 16),
            _buildConflictCasesSection(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildMemberInfoCard() {
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
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColor.gray2,
                  child: Icon(
                    widget.familyMember.gender == "Female" ? Icons.female : Icons.male,
                    size: 48,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.familyMember.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 24, color: Colors.grey, thickness: 1),
                _buildInfoRow('رقم الهوية', widget.familyMember.identityNumber),
                _buildInfoRow(
                  'نوع الهوية',
                  widget.familyMember.identityType.toString().split('.').last,
                ),
                _buildInfoRow('رقم الجوال', widget.familyMember.phoneNumber),
                _buildInfoRow('البريد الإلكتروني', widget.familyMember.email ?? '-'),
                _buildInfoRow(
                  'الجنس',
                  widget.familyMember.gender == "Female" ? "أنثى" : "ذكر",
                ),
                _buildInfoRow(
                  'تاريخ الميلاد',
                  widget.familyMember.dateOfBirth.toString().split(' ').first,
                ),
                _buildInfoRow(
                  'فصيلة الدم',
                  widget.familyMember.bloodType.toString().split('.').last,
                ),
                _buildInfoRow(
                  'الحالة الاجتماعية',
                  widget.familyMember.maritalStatus.toString().split('.').last,
                ),
                _buildInfoRow('المهنة', widget.familyMember.job ?? '-'),
                _buildInfoRow(
                  'حالة العمل',
                  widget.familyMember.occupationStatus.toString().split('.').last,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildContactButton(
                      'اتصال',
                      Icons.phone,
                      widget.familyMember.isCall,
                    ),
                    _buildContactButton(
                      'واتساب',
                      Icons.message,
                      widget.familyMember.isWhatsapp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
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
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(String label, IconData icon, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictCasesSection() {
    return BlocBuilder<FamilyCubit, FamilyState>(
      builder: (context, state) {
        if (state is FamilyFailure) {
          return OnFailureWidget(
            onRetry: () => context.read<FamilyCubit>()
                .getConflictCasesByFamilyMember(widget.familyMember.id),
          );
        }
        if (state is FamilyMemberConflictCasesLoaded) {
          return _buildConflictCasesList(state.conflictCases);
        }
        if (state is FamilyLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري تحميل سجل الخدمات...'),
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
    );
  }

  Widget _buildConflictCasesList(List<ConflictCase> conflictCases) {
    if (conflictCases.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد خدمات مسجلة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildConflictCasesTable(conflictCases),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildConflictCasesTable(List<ConflictCase> conflictCases) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTableHeader(),
            const Divider(thickness: 2),
            ...conflictCases.map((conflictCase) => _buildTableRow(conflictCase)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'النوع',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'العنوان',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
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
                fontSize: 16,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'الحالة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(ConflictCase conflictCase) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                conflictCase.conflictTypeName,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                conflictCase.title.isNotEmpty ? conflictCase.title : 'غير محدد',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                conflictCase.sessionDate.toString().split(' ').first,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: conflictCase.isResolved ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  conflictCase.isResolved ? 'مكتمل' : 'جاري',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
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