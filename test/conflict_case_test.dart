import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/models/conflict_case.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';

void main() {
  group('ConflictCase Model Tests', () {
    test('ConflictCase should be created from valid JSON', () {
      final json = {
        'id': 1,
        'conflictTypeName': 'رأي مختلف',
        'managerName': null,
        'firstPartyName': null,
        'secondPartyName': null,
        'notes': 'we got agree about the issue',
        'imageUrl': 'https://localhost:44352/People/test.jpg',
        'sessionDate': '2000-02-02T00:00:00',
        'isResolved': true,
        'firstPartyId': 17,
        'secondPartyId': 27,
        'conflictTypeId': 1,
        'title': 'Solve big Issue'
      };

      final conflictCase = ConflictCase.fromJson(json);

      expect(conflictCase.id, 1);
      expect(conflictCase.conflictTypeName, 'رأي مختلف');
      expect(conflictCase.notes, 'we got agree about the issue');
      expect(conflictCase.isResolved, true);
      expect(conflictCase.title, 'Solve big Issue');
    });

    test('ConflictCase should handle null values gracefully', () {
      final json = {
        'id': 2,
        'conflictTypeName': 'نزاع',
        'notes': 'test notes',
        'imageUrl': '',
        'sessionDate': '2023-01-01T00:00:00',
        'isResolved': false,
        'firstPartyId': 1,
        'secondPartyId': 2,
        'conflictTypeId': 1,
        'title': ''
      };

      final conflictCase = ConflictCase.fromJson(json);

      expect(conflictCase.managerName, null);
      expect(conflictCase.firstPartyName, null);
      expect(conflictCase.secondPartyName, null);
      expect(conflictCase.title, '');
    });

    test('ConflictCase should convert to JSON correctly', () {
      final conflictCase = ConflictCase(
        id: 1,
        conflictTypeName: 'Test Type',
        notes: 'Test notes',
        imageUrl: 'test.jpg',
        sessionDate: DateTime.parse('2023-01-01T00:00:00'),
        isResolved: true,
        firstPartyId: 1,
        secondPartyId: 2,
        conflictTypeId: 1,
        title: 'Test Title',
      );

      final json = conflictCase.toJson();

      expect(json['id'], 1);
      expect(json['conflictTypeName'], 'Test Type');
      expect(json['notes'], 'Test notes');
      expect(json['isResolved'], true);
      expect(json['title'], 'Test Title');
    });
  });

  group('ConflictCase State Tests', () {
    test('ConflictCasesLoaded state should contain conflict cases list', () {
      final conflictCases = [
        ConflictCase(
          id: 1,
          conflictTypeName: 'Test',
          notes: 'Test notes',
          imageUrl: 'test.jpg',
          sessionDate: DateTime.now(),
          isResolved: true,
          firstPartyId: 1,
          secondPartyId: 2,
          conflictTypeId: 1,
          title: 'Test',
        ),
      ];
      
      final state = ConflictCasesLoaded(conflictCases: conflictCases);
      
      expect(state.conflictCases, conflictCases);
      expect(state.conflictCases.length, 1);
    });

    test('ConflictCasesLoading state should be of correct type', () {
      final state = ConflictCasesLoading();
      
      expect(state, isA<FamilyState>());
      expect(state, isA<ConflictCasesLoading>());
    });

    test('New conflict case states should be subtypes of FamilyState', () {
      final states = [
        ConflictCasesLoading(),
        ConflictCasesLoaded(conflictCases: []),
      ];

      for (final state in states) {
        expect(state, isA<FamilyState>());
      }
    });
  });
}