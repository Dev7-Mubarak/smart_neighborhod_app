import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/app_route.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/models/enums/blood_type.dart';
import 'package:smart_negborhood_app/models/enums/identity_type.dart';
import 'package:smart_negborhood_app/models/enums/marital_status.dart';
import 'package:smart_negborhood_app/models/enums/occupation_status.dart';
import 'package:smart_negborhood_app/views/families/family_member_details.dart';
import 'package:smart_negborhood_app/core/API/dio_consumer.dart';
import 'package:dio/dio.dart';

void main() {

  // group('FamilyMemberDetailsPage Widget Tests', () {
  //   late Person testPerson;

  //   setUp(() {
  //     testPerson = Person(
  //       id: 1,
  //       firstName: 'أحمد',
  //       secondName: 'محمد',
  //       thirdName: 'علي',
  //       lastName: 'السعودي',
  //       phoneNumber: '0501234567',
  //       isWhatsapp: true,
  //       isCall: true,
  //       email: 'ahmed@example.com',
  //       dateOfBirth: DateTime(1990, 1, 1),
  //       gender: 'Male',
  //       bloodType: BloodType.O_positive,
  //       identityNumber: '1234567890',
  //       identityType: IdentityType.nationalId,
  //       maritalStatus: MaritalStatus.single,
  //       occupationStatus: OccupationStatus.employee,
  //       job: 'مهندس',
  //     );
  //   });

  //   testWidgets('FamilyMemberDetailsPage should display member information', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: BlocProvider<FamilyCubit>(
  //           create: (_) => FamilyCubit(0, api: DioConsumer(dio: Dio())),
  //           child: FamilyMemberDetailsPage(familyMember: testPerson),
  //         ),
  //       ),
  //     );

  //     // Wait for the widget to build
  //     await tester.pumpAndSettle();

  //     // Verify that the member's name is displayed
  //     expect(find.text('أحمد محمد علي السعودي'), findsOneWidget);
      
  //     // Verify that the app bar title is correct
  //     expect(find.text('تفاصيل عضو الأسرة'), findsOneWidget);
      
  //     // Verify that some member details are displayed
  //     expect(find.text('الجنس'), findsOneWidget);
  //     expect(find.text('ذكر'), findsOneWidget);
  //     expect(find.text('رقم الهوية'), findsOneWidget);
  //     expect(find.text('1234567890'), findsOneWidget);
  //   });

  //   testWidgets('FamilyMemberDetailsPage should show loading state initially', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: BlocProvider<FamilyCubit>(
  //           create: (_) => FamilyCubit(0, api: DioConsumer(dio: Dio())),
  //           child: FamilyMemberDetailsPage(familyMember: testPerson),
  //         ),
  //       ),
  //     );

  //     // Wait for the initial build
  //     await tester.pump();

  //     // Should show loading indicator for conflict cases
  //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
  //     expect(find.text('جاري تحميل البيانات...'), findsOneWidget);
  //   });

  //   testWidgets('FamilyMemberDetailsPage should display service records section', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: BlocProvider<FamilyCubit>(
  //           create: (_) => FamilyCubit(0, api: DioConsumer(dio: Dio())),
  //           child: FamilyMemberDetailsPage(familyMember: testPerson),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     // Verify that the service records section title is displayed
  //     expect(find.text('سجل الخدمات والنشاطات'), findsOneWidget);
  //   });

  //   testWidgets('FamilyMemberDetailsPage should be navigable from route', (WidgetTester tester) async {
  //     final appRouter = AppRouter();
      
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         onGenerateRoute: appRouter.generateRoute,
  //         initialRoute: AppRoute.familyMemberDetails,
  //         onGenerateInitialRoutes: (String initialRoute) {
  //           return [
  //             appRouter.generateRoute(
  //               RouteSettings(
  //                 name: AppRoute.familyMemberDetails,
  //                 arguments: testPerson,
  //               ),
  //             )!,
  //           ];
  //         },
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     // Verify that the page is displayed correctly when navigated to
  //     expect(find.text('تفاصيل عضو الأسرة'), findsOneWidget);
  //     expect(find.text('أحمد محمد علي السعودي'), findsOneWidget);
  //   });
  // });

}