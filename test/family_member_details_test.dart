import 'package:flutter_test/flutter_test.dart';
import 'package:smart_negborhood_app/models/family_member_details_model.dart';

void main() {
  group('FamilyMemberDetailsModel', () {
    test('should create FamilyMemberDetailsModel from JSON', () {
      // Arrange
      final json = {
        "id": 1,
        "fullName": "فاطمة علي",
        "gender": "أنثى",
        "birthDate": "1975-05-25",
        "documentType": "بطاقة شخصية",
        "documentNumber": "245322",
        "phoneNumber": "777555444",
        "contactMethod": "اتصال و واتس اب",
        "email": "sarah@gmail.com",
        "status": "موظفة",
        "job": "معلمة",
        "bloodType": "O+",
        "maritalStatus": "متزوجة",
        "familyRole": "أم",
        "notes": "التعليقات",
        "usages": [
          {
            "id": 1,
            "type": "استخدام مساعدات غذائية",
            "name": "معاملة",
            "date": "2023-01-25",
            "status": "✓"
          },
          {
            "id": 2,
            "type": "استخدام",
            "name": "معاملة",
            "date": "",
            "status": ""
          }
        ]
      };

      // Act
      final model = FamilyMemberDetailsModel.fromJson(json);

      // Assert
      expect(model.id, 1);
      expect(model.fullName, "فاطمة علي");
      expect(model.gender, "أنثى");
      expect(model.birthDate, "1975-05-25");
      expect(model.documentType, "بطاقة شخصية");
      expect(model.documentNumber, "245322");
      expect(model.phoneNumber, "777555444");
      expect(model.contactMethod, "اتصال و واتس اب");
      expect(model.email, "sarah@gmail.com");
      expect(model.status, "موظفة");
      expect(model.job, "معلمة");
      expect(model.bloodType, "O+");
      expect(model.maritalStatus, "متزوجة");
      expect(model.familyRole, "أم");
      expect(model.notes, "التعليقات");
      expect(model.usages.length, 2);
      expect(model.usages[0].id, 1);
      expect(model.usages[0].type, "استخدام مساعدات غذائية");
      expect(model.usages[0].name, "معاملة");
      expect(model.usages[0].date, "2023-01-25");
      expect(model.usages[0].status, "✓");
    });

    test('should handle missing values gracefully', () {
      // Arrange
      final json = {
        "id": 1,
        "fullName": "test user",
      };

      // Act
      final model = FamilyMemberDetailsModel.fromJson(json);

      // Assert
      expect(model.id, 1);
      expect(model.fullName, "test user");
      expect(model.gender, "");
      expect(model.birthDate, "");
      expect(model.usages.length, 0);
    });
  });

  group('ServiceUsage', () {
    test('should create ServiceUsage from JSON', () {
      // Arrange
      final json = {
        "id": 1,
        "type": "استخدام مساعدات غذائية",
        "name": "معاملة",
        "date": "2023-01-25",
        "status": "✓"
      };

      // Act
      final usage = ServiceUsage.fromJson(json);

      // Assert
      expect(usage.id, 1);
      expect(usage.type, "استخدام مساعدات غذائية");
      expect(usage.name, "معاملة");
      expect(usage.date, "2023-01-25");
      expect(usage.status, "✓");
    });

    test('should handle missing values gracefully', () {
      // Arrange
      final json = {
        "id": 1,
      };

      // Act
      final usage = ServiceUsage.fromJson(json);

      // Assert
      expect(usage.id, 1);
      expect(usage.type, "");
      expect(usage.name, "");
      expect(usage.date, "");
      expect(usage.status, "");
    });
  });
}