import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict_case.dart';
import 'package:smart_negborhood_app/core/common/enums/blood_type.dart';
import 'package:smart_negborhood_app/core/common/enums/marital_status.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';

import '../../cubits/family_member/family_member_cubit.dart';
import '../../cubits/family_member/family_member_state.dart';

class FamilyMemberDetailsPage extends StatefulWidget {
  final FamilyMember familyMember;

  const FamilyMemberDetailsPage({super.key, required this.familyMember});

  @override
  State<FamilyMemberDetailsPage> createState() =>
      _FamilyMemberDetailsPageState();
}

class _FamilyMemberDetailsPageState extends State<FamilyMemberDetailsPage> {
  @override
  void initState() {
    super.initState();
    final familyMemberCubit = context.read<FamilyMemberCubit>();
    familyMemberCubit.getConflictCasesByFamilyMember(
      widget.familyMember.familyMemberId,
    );
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
            const SizedBox(height: 20),
            _MemberProfileSection(familyMember: widget.familyMember),
            const SizedBox(height: 20),
            _MemberDetailsSection(familyMember: widget.familyMember),
            const SizedBox(height: 20),
            const _SectionTitle(title: 'سجل الخدمات والنشاطات'),
            const SizedBox(height: 16),
            _ConflictCasesSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MemberProfileSection extends StatelessWidget {
  final FamilyMember familyMember;

  const _MemberProfileSection({required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: AppColor.gray,
              child: familyMember.person.image != null
                  ? ClipOval(
                      child: Image.network(
                        familyMember.person.image!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    )
                  : const Icon(Icons.person, size: 60, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            familyMember.person.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MemberDetailsSection extends StatelessWidget {
  final FamilyMember familyMember;

  const _MemberDetailsSection({required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Card(
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                _DetailRow(
                  'الجنس',
                  familyMember.person.gender == "Female" ? "أنثى" : "ذكر",
                ),
                _DetailRow(
                  'تاريخ الميلاد',
                  familyMember.person.dateOfBirth.toString().split(' ').first,
                ),
                _DetailRow(
                  'فصيلة الدم',
                  familyMember.person.bloodType.arabicName,
                ),
                _DetailRow('رقم الجوال', familyMember.person.phoneNumber),
                _DetailRow(
                  'طريقة التواصل',
                  familyMember.person.isWhatsapp ? "واتساب" : "مكالمة",
                ),
                _DetailRow(
                  'الحالة الاجتماعية',
                  familyMember.person.maritalStatus.arabicName,
                ),
                _DetailRow('المهنة', familyMember.person.job ?? '-'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
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
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConflictCasesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
      builder: (context, state) {
        if (state is ConflictCasesLoading) {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري تحميل البيانات...'),
              ],
            ),
          );
        }

        if (state is FamilyFailure) {
          return OnFailureWidget(
            onRetry: () {
              // Note: We need to get the member ID from context or pass it differently
              // For now, this will trigger a generic retry
            },
          );
        }

        if (state is ConflictCasesLoaded) {
          return _ConflictCasesTable(conflictCases: state.conflictCases);
        }

        return const Center(child: Text('لا توجد بيانات متاحة'));
      },
    );
  }
}

class _ConflictCasesTable extends StatelessWidget {
  final List<ConflictCase> conflictCases;

  const _ConflictCasesTable({required this.conflictCases});

  @override
  Widget build(BuildContext context) {
    if (conflictCases.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.all(40),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'لا توجد حالات نزاع مسجلة',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'رقم',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'العنوان',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'نوع الخدمة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'الحالة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Table Rows
              ...conflictCases.asMap().entries.map(
                (entry) => _ConflictCaseRow(
                  conflictCase: entry.value,
                  index: entry.key + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConflictCaseRow extends StatelessWidget {
  final ConflictCase conflictCase;
  final int index;

  const _ConflictCaseRow({required this.conflictCase, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              index.toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              conflictCase.title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              conflictCase.conflictTypeName,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: conflictCase.isResolved
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                conflictCase.isResolved ? 'محلول' : 'قيد المراجعة',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: conflictCase.isResolved
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
                textAlign: TextAlign.center,
              ),
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
        fontSize: 20,
      ),
    );
  }
}
