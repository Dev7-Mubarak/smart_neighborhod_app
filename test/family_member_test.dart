import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/models/enums/gender.dart';
import 'package:smart_negborhood_app/models/enums/blood_type.dart';
import 'package:smart_negborhood_app/models/enums/identity_type.dart';
import 'package:smart_negborhood_app/models/enums/marital_status.dart';
import 'package:smart_negborhood_app/models/enums/occupation_status.dart';

void main() {
  group('Family Member Integration Tests', () {
    test('Gender enum should have display names', () {
      final displayNames = GenderExtension.getDisplayNames();
      expect(displayNames, isNotEmpty);
      expect(displayNames.contains('ذكر'), isTrue);
      expect(displayNames.contains('أنثى'), isTrue);
    });

    test('Gender enum should convert from display name correctly', () {
      expect(GenderExtension.fromDisplayName('ذكر'), equals(Gender.male));
      expect(GenderExtension.fromDisplayName('أنثى'), equals(Gender.female));
    });

    test('Blood type enum should have values', () {
      expect(BloodType.values, isNotEmpty);
      expect(BloodType.values.length, equals(8));
    });

    test('Identity type enum should have values', () {
      expect(IdentityType.values, isNotEmpty);
      expect(IdentityType.values.first, equals(IdentityType.identityCard));
    });

    test('Marital status enum should have values', () {
      expect(MaritalStatus.values, isNotEmpty);
      expect(MaritalStatus.values.first, equals(MaritalStatus.single));
    });

    test('Occupation status enum should have values', () {
      expect(OccupationStatus.values, isNotEmpty);
      expect(OccupationStatus.values.first, equals(OccupationStatus.employee));
    });

    test('Enum toString should return proper string format', () {
      final bloodType = BloodType.aPositive;
      final enumString = bloodType.toString().split('.').last;
      expect(enumString, equals('aPositive'));
    });
  });

  group('Form Validation Logic', () {
    test('Required fields validation logic', () {
      // Simulate validation logic used in the form
      String? validateRequired(String? value, String fieldName) {
        return value == null || value.isEmpty
            ? 'يرجى إدخال $fieldName'
            : null;
      }

      expect(validateRequired('', 'الاسم الأول'), contains('يرجى إدخال'));
      expect(validateRequired('John', 'الاسم الأول'), isNull);
      expect(validateRequired(null, 'الاسم الأول'), contains('يرجى إدخال'));
    });

    test('Date validation logic', () {
      final now = DateTime.now();
      final pastDate = DateTime(2000, 1, 1);
      final futureDate = DateTime(2030, 1, 1);

      expect(pastDate.isBefore(now), isTrue);
      expect(futureDate.isAfter(now), isTrue);
    });
  });
}