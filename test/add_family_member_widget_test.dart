import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/views/families/add_family_member.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/core/API/dio_consumer.dart';

// Mock classes for testing
class MockDioConsumer implements DioConsumer {
  @override
  Future<dynamic> delete(String path, {Map<String, dynamic>? data, bool isFromData = false}) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryparameters}) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> post(String path, {dynamic data, bool isFromData = false}) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> update(String path, {dynamic data, bool isFromData = false}) {
    throw UnimplementedError();
  }
}

void main() {
  group('AddFamilyMember Widget Tests', () {
    late MockDioConsumer mockApi;
    late FamilyCubit familyCubit;
    late PersonCubit personCubit;

    setUp(() {
      mockApi = MockDioConsumer();
      familyCubit = FamilyCubit(api: mockApi);
      personCubit = PersonCubit(api: mockApi);
    });

    testWidgets('should display AddFamilyMember UI elements', (WidgetTester tester) async {
      // Create the widget with proper BLoC providers
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<FamilyCubit>.value(value: familyCubit),
              BlocProvider<PersonCubit>.value(value: personCubit),
            ],
            child: const AddFamilyMember(familyId: 1),
          ),
        ),
      );

      // Verify the app bar title
      expect(find.text('إضافة فرد للأسرة'), findsOneWidget);
      
      // Verify the main instruction text
      expect(find.text('اختر شخصاً موجوداً أو أضف شخصاً جديداً'), findsOneWidget);
      
      // Verify the action buttons
      expect(find.text('إلغاء'), findsOneWidget);
      expect(find.text('إضافة كعضو'), findsOneWidget);
      expect(find.text('إضافة شخص جديد'), findsOneWidget);
    });

    testWidgets('should show loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<FamilyCubit>.value(value: familyCubit),
              BlocProvider<PersonCubit>.value(value: personCubit),
            ],
            child: const AddFamilyMember(familyId: 1),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have navigation buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<FamilyCubit>.value(value: familyCubit),
              BlocProvider<PersonCubit>.value(value: personCubit),
            ],
            child: const AddFamilyMember(familyId: 1),
          ),
        ),
      );

      // Wait for any initial loading
      await tester.pump();

      // Verify back button in app bar
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}