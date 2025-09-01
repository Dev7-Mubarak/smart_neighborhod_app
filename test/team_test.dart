// import 'package:bloc_test/bloc_test.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:smart_negborhood_app/core/common/enums/project_priority.dart';
// import 'package:smart_negborhood_app/core/common/enums/project_status.dart';
// import 'package:smart_negborhood_app/core/constants/api_link.dart';
// import 'package:smart_negborhood_app/core/services/API/dio_consumer.dart';
// import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
// import 'package:smart_negborhood_app/core/services/errors/exception.dart';
// import 'package:smart_negborhood_app/features/Assistances/data/models/project.dart';
// import 'package:smart_negborhood_app/features/Assistances/data/models/project_catgory.dart';
// import 'package:smart_negborhood_app/features/teams/cubits/team/team_cubit.dart';
// import 'package:smart_negborhood_app/features/teams/cubits/team/team_state.dart';
// import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
// import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';
// import 'team_test.mocks.dart';

// @GenerateMocks([DioConsumer])
// void main() {
//   group('Team Model Tests', () {
//     test('Team should be created from valid JSON', () {
//       final json = {
//         'id': 1,
//         'name': 'team1',
//         'teamMembers': [
//           {
//             "teamMemberId": 7,
//             "personId": 3,
//             "personName": "fg gh gf gh",
//             "teamId": 11,
//             "teamName": "حراسة نهارية",
//             "teamRoleId": 2,
//             "teamRoleName": "النائب",
//             "dateOfJoin": "2025-06-29T05:40:33.282",
//           },
//         ],
//       };

//       final team = Team.fromJson(json);
//       expect(team.id, 1);
//       expect(team.name, 'team1');
//       expect(team.teamMembers, [
//         TeamMember(
//           teamMemberId: 7,
//           personId: 3,
//           personName: "fg gh gf gh",
//           dateOfJoin: DateTime(2025, 6, 29, 5, 40, 33, 282),
//           teamRoleId: 2,
//           teamRoleName: "النائب",
//           teamId: 11,
//           teamName: "حراسة نهارية",
//         ),
//       ]);
//     });

//     test('Team should handle null values gracefully', () {
//       final json = {'id': null, 'name': null, 'teamMembers': null};

//       final team = Team.fromJson(json);
//       expect(team.id, 0);
//       expect(team.name, '');
//       expect(team.teamMembers, []);
//     });

//     test('Team should handle if some properties not pass from json', () {
//       final Map<String, dynamic> json = {};

//       final team = Team.fromJson(json);
//       expect(team.id, 0);
//       expect(team.name, '');
//       expect(team.teamMembers, []);
//     });

//     test(
//       'Team model constracter should accept correct data types for properties',
//       () {
//         final team = Team(id: 1, name: 'team1', teamMembers: []);
//         expect(team.id, 1);
//         expect(team.name, 'team1');
//         expect(team.teamMembers, []);
//       },
//     );
//     test('FamilyType should have default constructor', () {
//       final team = Team();
//       expect(team.id, 0);
//       expect(team.name, '');
//       expect(team.teamMembers, []);
//     });

//     test('Team model should support setting ID for update mode', () {
//       final team = Team(
//         name: 'Updated Team',
//         teamMembers: [
//           TeamMember(
//             teamMemberId: 7,
//             personId: 3,
//             personName: "fg gh gf gh",
//             dateOfJoin: DateTime(2025, 6, 29, 5, 40, 33, 282),
//             teamRoleId: 2,
//             teamRoleName: "النائب",
//             teamId: 11,
//             teamName: "حراسة نهارية",
//           ),
//         ],
//       );

//       // Set ID for update mode
//       team.id = 123;

//       expect(team.id, 123);
//       expect(team.name, 'Updated Team');
//     });
//   });

//   group('Team State Tests', () {
//     test('TeamLoaded state should contain teams list', () {
//       final teams = [
//         Team(
//           name: 'Updated Team',
//           teamMembers: [
//             TeamMember(
//               teamMemberId: 7,
//               personId: 3,
//               personName: "fg gh gf gh",
//               dateOfJoin: DateTime(2025, 6, 29, 5, 40, 33, 282),
//               teamRoleId: 2,
//               teamRoleName: "النائب",
//               teamId: 11,
//               teamName: "حراسة نهارية",
//             ),
//           ],
//         ),
//       ];

//       final state = TeamLoaded(allTeams: teams, filteredTeams: teams);

//       expect(state.filteredTeams, teams);
//       expect(state.allTeams, teams);
//       expect(state.filteredTeams.length, 1);
//     });

//     test('ProjectsOfTeamLoaded state should contain Projects list', () {
//       final Projects = [
//         Project(
//           id: 0,
//           name: "ee",
//           description: "ii",
//           startDate: DateTime(2025, 6, 29, 5, 40, 33, 282),
//           endDate: DateTime(2025, 6, 29, 5, 40, 33, 282),
//           projectStatus: ProjectStatus.Completed,
//           projectPriority: ProjectPriority.Medium,
//           budget: 3000,
//           manager: Manager(fullName: "ww rrr", id: 1),
//           projectCategory: ProjectCategory(
//             id: 1,
//             name: "ww",
//             description: "wwwee",
//           ),
//         ),
//       ];
//       final state = ProjectsOfTeamLoaded(Projects);

//       expect(state.allProjects, Projects);
//     });
//     test('New team states should be subtypes of TeamState', () {
//       final states = [
//         TeamLoaded(allTeams: [], filteredTeams: []),
//         TeamInitial(),
//         ProjectsOfTeamLoaded([]),
//         TeamLoading(),
//         WiateAddedUpdatedTeam(),
//         TeamFailure(errorMessage: ''),
//         TeamAddedSuccessfully(message: ''),
//         ChangeSelectedJoiedDate(),
//         ChangeSelectedTeamLeadId(),
//         TeamUpdatedSuccessfully(message: ''),
//         TeamDeletedSuccessfully(message: ''),
//         TeamByIdLoaded(
//           team: Team(
//             name: 'Updated Team',
//             teamMembers: [
//               TeamMember(
//                 teamMemberId: 7,
//                 personId: 3,
//                 personName: "fg gh gf gh",
//                 dateOfJoin: DateTime(2025, 6, 29, 5, 40, 33, 282),
//                 teamRoleId: 2,
//                 teamRoleName: "النائب",
//                 teamId: 11,
//                 teamName: "حراسة نهارية",
//               ),
//             ],
//           ),
//         ),
//       ];

//       for (final state in states) {
//         expect(state, isA<TeamState>());
//       }
//     });

//     test('TeamUpdatedSuccessfully state should contain message', () {
//       const message = 'تم اضافة الاسرة بنجاح';
//       final state = TeamUpdatedSuccessfully(message: message);

//       expect(state.message, message);
//     });

//     test('TeamAddedSuccessfully state should contain message', () {
//       const message = 'تم تحديث الأسرة بنجاح';
//       final state = TeamAddedSuccessfully(message: message);

//       expect(state.message, message);
//     });
//     test('TeamDeletedSuccessfully state should contain message', () {
//       const message = 'تم تحديث الأسرة بنجاح';
//       final state = TeamDeletedSuccessfully(message: message);

//       expect(state.message, message);
//     });

//     test('TeamFailure state should contain error message', () {
//       const errorMessage = 'حدث خطأ في التحديث';
//       final state = TeamFailure(errorMessage: errorMessage);

//       expect(state.errorMessage, errorMessage);
//     });
//   });

//   group('Team cubit Tests', () {
//     late MockDioConsumer mockDioConsumer;
//     late TeamCubit teamCubit;

//     setUp(() {
//       mockDioConsumer = MockDioConsumer();
//       teamCubit = TeamCubit(api: mockDioConsumer);
//     });
//     tearDown(() {
//       teamCubit.close();
//     });
//     group('getAllTeams function Tests', () {
//       final List<Team> tExpectedTeams = [
//         Team(
//           id: 12,
//           name: "فريق e2",
//           teamMembers: [
//             TeamMember(
//               teamMemberId: 9,
//               personId: 3,
//               personName: "fg gh gf gh",
//               teamId: 12,
//               teamName: "فريق e2",
//               teamRoleId: 1,
//               teamRoleName: "مدير المشروع",
//               dateOfJoin: DateTime.parse("2025-06-29T22:36:33.217502"),
//             ),
//           ],
//         ),
//       ];
//       blocTest<TeamCubit, TeamState>(
//         'Emits [TeamLoading,TeamLoaded] when getAllTeams is successful',
//         build: () {
//           when(mockDioConsumer.get(ApiLink.getAllTeams)).thenAnswer(
//             (_) async => {
//               "isSuccess": true,
//               "statusCode": "OK",
//               "message": "تم جلب الفرق بنجاح",
//               "data": [
//                 {
//                   "id": 12,
//                   "name": "فريق e2",
//                   "teamMembers": [
//                     {
//                       "teamMemberId": 9,
//                       "personId": 3,
//                       "personName": "fg gh gf gh",
//                       "teamId": 12,
//                       "teamName": "فريق e2",
//                       "teamRoleId": 1,
//                       "teamRoleName": "مدير المشروع",
//                       "dateOfJoin": "2025-06-29T22:36:33.217502",
//                     },
//                   ],
//                 },
//               ],
//               "errors": null,
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.getAllTeams(),
//         expect: () => [
//           isA<TeamLoading>(),
//           isA<TeamLoaded>()
//               .having((state) => state.allTeams, 'allTeams', tExpectedTeams)
//               .having(
//                 (state) => state.filteredTeams,
//                 'filteredTeams',
//                 tExpectedTeams,
//               ),
//         ],
//       );
//       test('get method should call once when execute getAllTeams method', () {
//         when(mockDioConsumer.get(ApiLink.getAllTeams)).thenAnswer(
//           (_) async => {
//             "isSuccess": true,
//             "statusCode": "OK",
//             "message": "تم جلب الفرق بنجاح",
//             "data": [
//               {
//                 "id": 12,
//                 "name": "فريق e2",
//                 "teamMembers": [
//                   {
//                     "teamMemberId": 9,
//                     "personId": 3,
//                     "personName": "fg gh gf gh",
//                     "teamId": 12,
//                     "teamName": "فريق e2",
//                     "teamRoleId": 1,
//                     "teamRoleName": "مدير المشروع",
//                     "dateOfJoin": "2025-06-29T22:36:33.217502",
//                   },
//                 ],
//               },
//             ],
//             "errors": null,
//           },
//         );
//         teamCubit.getAllTeams();
//         verify(mockDioConsumer.get(ApiLink.getAllTeams)).called(1);
//       });
//       blocTest<TeamCubit, TeamState>(
//         'Emits [TeamLoading,TeamFailure] when getAllTeams is Failure because BadRequest no data received ',
//         build: () {
//           when(mockDioConsumer.get(ApiLink.getAllTeams)).thenAnswer(
//             (_) async => {
//               "isSuccess": false,
//               "statusCode": "BadRequest",
//               "message": "Validation errors occurred.",
//               "data": null,
//               "errors": [
//                 {
//                   "field": "TeamDto",
//                   "errorMessage": "The TeamDto field is required.",
//                 },
//               ],
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.getAllTeams(),
//         expect: () => [isA<TeamLoading>(), isA<TeamFailure>()],
//       );
//       blocTest<TeamCubit, TeamState>(
//         'Emits [TeamLoading,TeamFailure] when getAllTeams is Failure',
//         build: () {
//           final serverException = Serverexception(
//             errModel: ErrorModel(
//               statusCode: '500',
//               errorMessage: 'حدث خطأ في الخادم',
//               isSuccess: false,
//             ),
//           );
//           when(
//             mockDioConsumer.get(ApiLink.getAllTeams),
//           ).thenThrow(serverException);
//           return teamCubit;
//         },
//         act: (cubite) => cubite.getAllTeams(),
//         expect: () => [
//           isA<TeamLoading>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             'حدث خطأ في الخادم',
//           ),
//         ],
//       );
//     });

//     group('addNewTeam function Tests', () {
//       blocTest<TeamCubit, TeamState>(
//         'Emits [WiateAddedUpdatedTeam,TeamAddedSuccessfully] when addNewTeam is successful',
//         build: () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );

//           when(
//             mockDioConsumer.post(ApiLink.addTeam, data: anyNamed('data')),
//           ).thenAnswer(
//             (_) async => {
//               "isSuccess": true,
//               "statusCode": "OK",
//               "message": "تمت الإضافة بنجاح",
//               "data": {
//                 "name": "string",
//                 "teamLeadId": 2,
//                 "inJoiedDate": "2025-08-09T19:54:48.1Z",
//               },
//               "errors": null,
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.addNewTeam("string"),
//         expect: () => [
//           isA<WiateAddedUpdatedTeam>(),
//           isA<TeamAddedSuccessfully>().having(
//             (state) => state.message,
//             'message',
//             'تمت الإضافة بنجاح',
//           ),
//         ],
//       );
//       test('post method should call once when execute addNewTeam method', () {
//         teamCubit.selectedPersonId = 2;
//         teamCubit.selectedJoiedDate = DateTime.parse(
//           "2025-08-09T19:54:48.100Z",
//         );

//         when(
//           mockDioConsumer.post(ApiLink.addTeam, data: anyNamed('data')),
//         ).thenAnswer(
//           (_) async => {
//             "isSuccess": true,
//             "statusCode": "OK",
//             "message": "تمت الإضافة بنجاح",
//             "data": {
//               "name": "string",
//               "teamLeadId": 2,
//               "inJoiedDate": "2025-08-09T19:54:48.1Z",
//             },
//             "errors": null,
//           },
//         );
//         teamCubit.addNewTeam("string");
//         verify(
//           mockDioConsumer.post(ApiLink.addTeam, data: anyNamed('data')),
//         ).called(1);
//       });
//       blocTest<TeamCubit, TeamState>(
//         'Emits [WiateAddedUpdatedTeam,TeamFailure] when addNewTeam is Failure because BadRequest no data received ',
//         build: () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );

//           when(
//             mockDioConsumer.post(ApiLink.addTeam, data: anyNamed('data')),
//           ).thenAnswer(
//             (_) async => {
//               "isSuccess": false,
//               "statusCode": "BadRequest",
//               "message": "Validation errors occurred.",
//               "data": null,
//               "errors": [
//                 {
//                   "field": "TeamDto",
//                   "errorMessage": "The TeamDto field is required.",
//                 },
//               ],
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.addNewTeam("string"),
//         expect: () => [
//           isA<WiateAddedUpdatedTeam>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             "Validation errors occurred.",
//           ),
//         ],
//       );
//       blocTest<TeamCubit, TeamState>(
//         'Emits [WiateAddedUpdatedTeam,TeamFailure] when addNewTeam is Failure',
//         build: () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );

//           final serverException = Serverexception(
//             errModel: ErrorModel(
//               statusCode: '500',
//               errorMessage: 'حدث خطأ في الخادم',
//               isSuccess: false,
//             ),
//           );
//           when(
//             mockDioConsumer.post(ApiLink.addTeam, data: anyNamed('data')),
//           ).thenThrow(serverException);
//           return teamCubit;
//         },
//         act: (cubite) => cubite.addNewTeam("string"),
//         expect: () => [
//           isA<WiateAddedUpdatedTeam>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             "حدث خطأ في الخادم",
//           ),
//         ],
//       );
//     });

//     group('updateTeams function Tests', () {
//       blocTest<TeamCubit, TeamState>(
//         'Emits [WiateAddedUpdatedTeam,TeamUpdatedSuccessfully] when updateTeams is successful',
//         build: () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );

//           when(
//             mockDioConsumer.update(
//               '${ApiLink.updateTeam}/1',
//               data: anyNamed('data'),
//             ),
//           ).thenAnswer(
//             (_) async => {
//               "isSuccess": true,
//               "statusCode": "OK",
//               "message": "تم تحديث الفريق بنجاح",
//               "data": {
//                 "name": "teem33",
//                 "teamLeadId": 2,
//                 "inJoiedDate": "2025-08-09T19:54:48.100Z",
//               },
//               "errors": null,
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.updateTeams(id: 1, name: 'teem33'),
//         expect: () => [
//           isA<WiateAddedUpdatedTeam>(),
//           isA<TeamUpdatedSuccessfully>().having(
//             (state) => state.message,
//             'message',
//             "تم تحديث الفريق بنجاح",
//           ),
//         ],
//       );
//       test(
//         'update method should call once when execute updateTeams method',
//         () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );

//           when(
//             mockDioConsumer.update(
//               '${ApiLink.updateTeam}/1',
//               data: anyNamed('data'),
//             ),
//           ).thenAnswer(
//             (_) async => {
//               "isSuccess": true,
//               "statusCode": "OK",
//               "message": "تم تحديث الفريق بنجاح",
//               "data": {
//                 "name": "teem33",
//                 "teamLeadId": 2,
//                 "inJoiedDate": "2025-08-09T19:54:48.100Z",
//               },
//               "errors": null,
//             },
//           );
//           teamCubit.updateTeams(id: 1, name: 'teem33');
//           verify(
//             mockDioConsumer.update(
//               '${ApiLink.updateTeam}/1',
//               data: anyNamed('data'),
//             ),
//           ).called(1);
//         },
//       );
//       blocTest<TeamCubit, TeamState>(
//         'Emits [WiateAddedUpdatedTeam,TeamFailure] when updateTeams is Failure because BadRequest no data received ',
//         build: () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );

//           when(
//             mockDioConsumer.update(
//               '${ApiLink.updateTeam}/1',
//               data: anyNamed('data'),
//             ),
//           ).thenAnswer(
//             (_) async => {
//               "isSuccess": false,
//               "statusCode": "NotFound",
//               "message": "لم يتم العثور على قائد الفريق",
//               "data": null,
//               "errors": null,
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.updateTeams(id: 1, name: 'teem33'),
//         expect: () => [
//           isA<WiateAddedUpdatedTeam>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             "لم يتم العثور على قائد الفريق",
//           ),
//         ],
//       );
//       blocTest<TeamCubit, TeamState>(
//         'Emits [WiateAddedUpdatedTeam,TeamFailure] when updateTeams is Failure',
//         build: () {
//           teamCubit.selectedPersonId = 2;
//           teamCubit.selectedJoiedDate = DateTime.parse(
//             "2025-08-09T19:54:48.100Z",
//           );
//           final serverException = Serverexception(
//             errModel: ErrorModel(
//               statusCode: '500',
//               errorMessage: 'حدث خطأ في الخادم',
//               isSuccess: false,
//             ),
//           );
//           when(
//             mockDioConsumer.update(
//               '${ApiLink.updateTeam}/1',
//               data: anyNamed('data'),
//             ),
//           ).thenThrow(serverException);
//           return teamCubit;
//         },
//         act: (cubite) => cubite.updateTeams(id: 1, name: 'teem33'),
//         expect: () => [
//           isA<WiateAddedUpdatedTeam>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             "حدث خطأ في الخادم",
//           ),
//         ],
//       );
//     });
//     group('deleteTeam function Tests', () {
//       blocTest<TeamCubit, TeamState>(
//         'Emits [TeamLoading,TeamDeletedSuccessfully] when deleteTeam is successful',
//         build: () {
//           when(mockDioConsumer.delete('${ApiLink.deleteTeam}/1')).thenAnswer(
//             (_) async => {
//               "isSuccess": true,
//               "statusCode": "OK",
//               "message": "",
//               "data": "تم حذف الفريق بنجاح",
//               "errors": null,
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.deleteTeam(1),
//         expect: () => [
//           isA<TeamLoading>(),
//           isA<TeamDeletedSuccessfully>().having(
//             (state) => state.message,
//             'message',
//             "تم حذف الفريق بنجاح",
//           ),
//         ],
//       );
//       test('delete method should call once when execute deleteTeam method', () {
//         when(mockDioConsumer.delete('${ApiLink.deleteTeam}/1')).thenAnswer(
//           (_) async => {
//             "isSuccess": true,
//             "statusCode": "OK",
//             "message": "",
//             "data": "تم حذف الفريق بنجاح",
//             "errors": null,
//           },
//         );
//         teamCubit.deleteTeam(1);
//         verify(mockDioConsumer.delete('${ApiLink.deleteTeam}/1'),
//         ).called(1);
//       });
//       blocTest<TeamCubit, TeamState>(
//         'Emits [TeamLoading,TeamFailure] when deleteTeam is Failure because BadRequest no data received ',
//         build: () {
//           when(mockDioConsumer.delete('${ApiLink.deleteTeam}/1')).thenAnswer(
//             (_) async => {
//               "isSuccess": false,
//               "statusCode": "NotFound",
//               "message": "لم يتم العثور على الفريق",
//               "data": null,
//               "errors": null,
//             },
//           );
//           return teamCubit;
//         },
//         act: (cubite) => cubite.deleteTeam(1),
//         expect: () => [
//           isA<TeamLoading>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             "لم يتم العثور على الفريق",
//           ),
//         ],
//       );
//       blocTest<TeamCubit, TeamState>(
//         'Emits [TeamLoading,TeamFailure] when deleteTeam is Failure',
//         build: () {
//           final serverException = Serverexception(
//             errModel: ErrorModel(
//               statusCode: '500',
//               errorMessage: 'حدث خطأ في الخادم',
//               isSuccess: false,
//             ),
//           );
//           when(
//             mockDioConsumer.delete(
//               '${ApiLink.deleteTeam}/1',
//             ),
//           ).thenThrow(serverException);
//           return teamCubit;
//         },
//         act: (cubite) => cubite.deleteTeam(1),
//         expect: () => [
//           isA<TeamLoading>(),
//           isA<TeamFailure>().having(
//             (state) => state.errorMessage,
//             'errorMessage',
//             "حدث خطأ في الخادم",
//           ),
//         ],
//       );
//     });

//   });
// }
