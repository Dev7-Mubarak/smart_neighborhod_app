import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/components/constants/api_link.dart';

void main() {
  group('Add Family Member Integration Tests', () {
    test('should have addFamilyMember API endpoint defined correctly', () {
      // Test that the API endpoint is correctly defined
      expect(ApiLink.addFamilyMember, equals('https://smartneighboorhood.runasp.net/api/Family/AddMember'));
      expect(ApiLink.addFamilyMember, contains('/Family/AddMember'));
      expect(ApiLink.addFamilyMember, startsWith('https://smartneighboorhood.runasp.net/api'));
    });

    test('should have existing API endpoints still working', () {
      // Ensure we didn't break existing API endpoints
      expect(ApiLink.addNewPerson, equals('https://smartneighboorhood.runasp.net/api/Person/Add'));
      expect(ApiLink.getFamilyDetilesById, equals('https://smartneighboorhood.runasp.net/api/Family/GetFamilyDetilesById'));
      expect(ApiLink.addFamily, equals('https://smartneighboorhood.runasp.net/api/Family/Add'));
    });

    test('should verify server URL consistency', () {
      // All endpoints should use the same server URL
      const expectedServer = 'https://smartneighboorhood.runasp.net/api';
      
      expect(ApiLink.addFamilyMember, startsWith(expectedServer));
      expect(ApiLink.addNewPerson, startsWith(expectedServer));
      expect(ApiLink.getFamilyDetilesById, startsWith(expectedServer));
      expect(ApiLink.addFamily, startsWith(expectedServer));
    });
  });
}