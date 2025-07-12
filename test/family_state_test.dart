import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/models/family_member_details_model.dart';

void main() {
  group('Family State Tests', () {
    test('FamilyAddedSuccessfully state should contain message', () {
      const message = 'تم اضافة الاسرة بنجاح';
      final state = FamilyAddedSuccessfully(message: message);
      
      expect(state.message, message);
    });

    test('FamilyUpdatedSuccessfully state should contain message', () {
      const message = 'تم تحديث الأسرة بنجاح';
      final state = FamilyUpdatedSuccessfully(message: message);
      
      expect(state.message, message);
    });

    test('FamilyFailure state should contain error message', () {
      const errorMessage = 'حدث خطأ في التحديث';
      final state = FamilyFailure(errorMessage: errorMessage);
      
      expect(state.errorMessage, errorMessage);
    });

    test('FamilyMemberDetailsLoaded state should contain family member details', () {
      final memberDetails = FamilyMemberDetailsModel(
        id: 1,
        fullName: 'test user',
        gender: 'Male',
        birthDate: '1990-01-01',
        documentType: 'ID',
        documentNumber: '123456',
        phoneNumber: '1234567890',
        contactMethod: 'phone',
        email: 'test@email.com',
        status: 'active',
        job: 'engineer',
        bloodType: 'A+',
        maritalStatus: 'single',
        familyRole: 'son',
        notes: 'test notes',
        usages: [],
      );
      
      final state = FamilyMemberDetailsLoaded(familyMemberDetails: memberDetails);
      
      expect(state.familyMemberDetails, memberDetails);
      expect(state.familyMemberDetails.id, 1);
      expect(state.familyMemberDetails.fullName, 'test user');
    });

    test('FamilyMemberDetailsFailure state should contain error message', () {
      const errorMessage = 'فشل في تحميل بيانات العضو';
      final state = FamilyMemberDetailsFailure(errorMessage: errorMessage);
      
      expect(state.errorMessage, errorMessage);
    });

    test('All states should be subtypes of FamilyState', () {
      final memberDetails = FamilyMemberDetailsModel(
        id: 1,
        fullName: 'test user',
        gender: 'Male',
        birthDate: '1990-01-01',
        documentType: 'ID',
        documentNumber: '123456',
        phoneNumber: '1234567890',
        contactMethod: 'phone',
        email: 'test@email.com',
        status: 'active',
        job: 'engineer',
        bloodType: 'A+',
        maritalStatus: 'single',
        familyRole: 'son',
        notes: 'test notes',
        usages: [],
      );

      final states = [
        FamilyInitial(),
        FamilyLoading(),
        FamilyAddedSuccessfully(message: 'test'),
        FamilyUpdatedSuccessfully(message: 'test'),
        FamilyFailure(errorMessage: 'test'),
        FamilyMemberDetailsLoading(),
        FamilyMemberDetailsLoaded(familyMemberDetails: memberDetails),
        FamilyMemberDetailsFailure(errorMessage: 'test'),
      ];

      for (final state in states) {
        expect(state, isA<FamilyState>());
      }
    });
  });
}