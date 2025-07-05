import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/models/family.dart';
import 'package:smart_negborhood_app/models/family_category.dart';
import 'package:smart_negborhood_app/models/family_type.dart';

void main() {
  group('Family Add/Update Tests', () {
    test('Family model should have correct properties for add mode', () {
      final family = Family(
        name: 'Test Family',
        location: 'Test Location',
        familyCatgoryId: 1,
        familyTypeId: 1,
        familyNotes: 'Test Notes',
        blockId: 1,
        familyHeadId: 1,
      );

      expect(family.name, 'Test Family');
      expect(family.location, 'Test Location');
      expect(family.familyCatgoryId, 1);
      expect(family.familyTypeId, 1);
      expect(family.familyNotes, 'Test Notes');
      expect(family.blockId, 1);
      expect(family.familyHeadId, 1);
    });

    test('Family model should support setting ID for update mode', () {
      final family = Family(
        name: 'Updated Family',
        location: 'Updated Location',
        familyCatgoryId: 2,
        familyTypeId: 2,
        familyNotes: 'Updated Notes',
        blockId: 2,
        familyHeadId: 2,
      );
      
      // Set ID for update mode
      family.id = 123;
      
      expect(family.id, 123);
      expect(family.name, 'Updated Family');
    });

    test('FamilyCategory should have default constructor', () {
      final category = FamilyCategory();
      expect(category.id, 0);
      expect(category.name, '');
    });

    test('FamilyCategory should support initialization with values', () {
      final category = FamilyCategory(id: 1, name: 'Test Category');
      expect(category.id, 1);
      expect(category.name, 'Test Category');
    });

    test('FamilyType should have default constructor', () {
      final type = FamilyType();
      expect(type.id, 0);
      expect(type.name, '');
    });

    test('FamilyType should support initialization with values', () {
      final type = FamilyType(id: 1, name: 'Test Type');
      expect(type.id, 1);
      expect(type.name, 'Test Type');
    });

    test('FamilyCategory should parse from JSON correctly', () {
      final json = {'id': 5, 'name': 'JSON Category'};
      final category = FamilyCategory.fromJson(json);
      
      expect(category.id, 5);
      expect(category.name, 'JSON Category');
    });

    test('FamilyType should parse from JSON correctly', () {
      final json = {'id': 3, 'name': 'JSON Type'};
      final type = FamilyType.fromJson(json);
      
      expect(type.id, 3);
      expect(type.name, 'JSON Type');
    });
  });
}