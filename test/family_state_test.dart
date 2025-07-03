import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';

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

    test('All states should be subtypes of FamilyState', () {
      final states = [
        FamilyInitial(),
        FamilyLoading(),
        FamilyAddedSuccessfully(message: 'test'),
        FamilyUpdatedSuccessfully(message: 'test'),
        FamilyFailure(errorMessage: 'test'),
      ];

      for (final state in states) {
        expect(state, isA<FamilyState>());
      }
    });
  });
}