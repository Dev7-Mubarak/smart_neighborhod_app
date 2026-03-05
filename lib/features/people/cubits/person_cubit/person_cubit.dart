import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import '../../data/models/Person.dart';
import '../../../../core/common/enums/blood_type.dart';
import '../../../../core/common/enums/marital_status.dart';
import '../../../../core/common/enums/occupation_status.dart';
import '../../../../core/common/enums/vehicle_type.dart';
import '../../../../core/common/enums/residency_status.dart';
part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  PersonCubit({required this.api}) : super(PersonInitial());
  static PersonCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Person? person;
  XFile? profilePicture;
  String? selectedGender;

  BloodType? selectedBloodType;
  MaritalStatus? selectedMaritalStatus;
  OccupationStatus? selectedOccupationStatus;
  VehicleType? selectedVehicleType;
  ResidencyStatus? selectedResidencyStatus;
  bool hasChronicDiseases = false;
  // contact flags (used by some legacy toggle methods, keep until UI is cleaned)
  bool isWhatsapp = false;
  bool isContactNumber = false;
  bool isCall = false;

  DateTime? selectedDate;
  bool _hasNextPage = false;
  int _pageNumber = 1;
  final int _pageSize = 1000;
  List<Person> people = [];

  /// Sets the cubit fields for editing a person.
  /// Copies all relevant fields from the given [person] to the cubit state.
  void setPersonForUpdate(Person person) {
    this.person = person;
    selectedBloodType = person.bloodType;
    selectedMaritalStatus = person.maritalStatus;
    selectedOccupationStatus = person.occupationStatus;
    selectedVehicleType = person.vehicleType;
    selectedResidencyStatus = person.residencyStatus;
    selectedDate = person.dateOfBirth;
    selectedGender = person.gender?.name;
    hasChronicDiseases = person.hasChronicDiseases ?? false;
  }

  /// Loads the next page of people if available.
  /// Increments the page number and fetches more people if [_hasNextPage] is true.
  Future<void> loadNextPage({String? search}) async {
    if (!_hasNextPage) return;
    _pageNumber++;
    await getPeople(search: search);
  }

  Future<void> getPeople({String? search}) async {
    if (search != null) {
      _resetPeopleList();
    }

    emit(PersonLoading(isFirstFetch: _pageNumber == 1 && people.isEmpty));
    try {
      final response = await api.get(
        ApiLink.getAllPepole,
        queryparameters: {
          'pageNumber': _pageNumber,
          'pageSize': _pageSize,
          'search': search,
        },
      );

      _hasNextPage = response["data"]["hasNextPage"];

      if (response["data"]["items"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> paganatedPeople = response["data"]["items"];
      people.addAll(paganatedPeople.map((e) => Person.fromJson(e)).toList());

      emit(PersonLoaded(people: people));
    } on Serverexception catch (e) {
      emit(PersonFailure(errorMessage: e.errModel.errorMessage));
    } catch (e, stackTrace) {
      print("Parsing Error: $e"); // سيطبع لك سبب المشكلة بالضبط
      print(stackTrace);
      emit(PersonFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addNewPerson({
    required String firstName,
    required String secondName,
    required String thirdName,
    required String lastName,
    required String? phoneNumber,
    String? job,
    String? nationalId,
    String? vehicleRegistrationNumber,
    String? chronicDiseasesNotes,
  }) async {
    emit(WaitingForUpdateOrAddPerson());

    try {
      final Map<String, dynamic> requestData = {
        "FirstName": firstName,
        "SecondName": secondName,
        "ThirdName": thirdName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": selectedDate?.toIso8601String(),
        "Gender": selectedGender,

        "BloodType": selectedBloodType?.toString().split('.').last,
        "MaritalStatus": selectedMaritalStatus?.toString().split('.').last,
        "OccupationStatus": selectedOccupationStatus
            ?.toString()
            .split('.')
            .last,
        "Job": job,
        "NationalId": nationalId,
        "VehicleType": selectedVehicleType?.toString().split('.').last,
        "VehicleRegistrationNumber": vehicleRegistrationNumber,
        "ResidencyStatus": selectedResidencyStatus?.toString().split('.').last,
        "HasChronicDiseases": hasChronicDiseases,
        "ChronicDiseasesNotes": chronicDiseasesNotes,
        "Image": profilePicture != null
            ? await MultipartFile.fromFile(
                profilePicture!.path,
                filename: profilePicture!.name,
              )
            : null,
      };

      print("Request Data: $requestData");

      final response = await api.post(
        ApiLink.addNewPerson,
        isFromData: true,
        data: requestData,
      );

      if (response["isSuccess"]) {
        emit(PersonAddedSuccessfully(message: response["message"]));
        _resetPeopleList();
        await getPeople();
      } else {
        emit(PersonAddedFailure(errorMessage: response["message"]));
      }
    } on Serverexception catch (e) {
      emit(PersonAddedFailure(errorMessage: e.errModel.errorMessage));
    } catch (e, stackTrace) {
      print("Unexpected error: $e");
      print(stackTrace);
      emit(
        PersonAddedFailure(errorMessage: "An unexpected error occurred: $e"),
      );
    }
  }

  Future<void> updatePerson({
    required int id,
    String? firstName,
    String? secondName,
    String? thirdName,
    String? lastName,
    String? phoneNumber,
    String? job,
    String? nationalId,
    String? vehicleRegistrationNumber,
    String? chronicDiseasesNotes,
  }) async {
    emit(WaitingForUpdateOrAddPerson());
    try {
      final Map<String, dynamic> requestData = {
        "FirstName": firstName,
        "SecondName": secondName,
        "ThirdName": thirdName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": selectedDate?.toIso8601String(),
        "Gender": selectedGender,

        "BloodType": selectedBloodType?.toString().split('.').last,
        "MaritalStatus": selectedMaritalStatus?.toString().split('.').last,
        "OccupationStatus": selectedOccupationStatus
            ?.toString()
            .split('.')
            .last,
        "Job": job,
        "NationalId": nationalId,
        "VehicleType": selectedVehicleType?.toString().split('.').last,
        "VehicleRegistrationNumber": vehicleRegistrationNumber,
        "ResidencyStatus": selectedResidencyStatus?.toString().split('.').last,
        "HasChronicDiseases": hasChronicDiseases,
        "ChronicDiseasesNotes": chronicDiseasesNotes,
        if (profilePicture != null)
          "Image": await MultipartFile.fromFile(
            profilePicture!.path,
            filename: profilePicture!.name,
          ),
      };

      print("Update Request Data: $requestData");

      final response = await api.update(
        '${ApiLink.updatePerson}/$id',
        isFromData: true,
        data: requestData,
      );

      print("Update Response: $response");

      // Try to extract updated person data from response and update local state
      dynamic raw = response["data"];
      Map<String, dynamic>? updatedPersonMap;
      if (raw != null) {
        if (raw is String) {
          try {
            final decoded = jsonDecode(raw);
            if (decoded is Map<String, dynamic>) updatedPersonMap = decoded;
          } catch (_) {}
        } else if (raw is Map<String, dynamic>) {
          updatedPersonMap = raw;
        }
      }

      if (response["isSuccess"]) {
        // If API returned the updated person object, update the cubit's `person`.
        if (updatedPersonMap != null) {
          try {
            person = Person.fromJson(updatedPersonMap);
          } catch (_) {
            // ignore parse errors; still proceed
          }
        }

        emit(PersonUpdatedSuccessfully(message: response["message"]));
        _resetPeopleList();
        await getPeople();
      } else {
        emit(PersonFailure(errorMessage: response["message"]));
      }
    } on Serverexception catch (e) {
      emit(PersonFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(PersonFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deletePerson(int id) async {
    emit(WaitingForUpdateOrAddPerson());
    try {
      final response = await api.delete('${ApiLink.deletePerson}/$id');

      if (response["isSuccess"]) {
        emit(PersonDeletedSuccessfully(message: response["message"]));
        _resetPeopleList();
        await getPeople();
      }
    } on Serverexception catch (e) {
      emit(PersonDeletedFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(PersonDeletedFailure(errorMessage: e.toString()));
    }
  }

  Future<bool> fetchPersonById(int id) async {
    emit(PersonLoading(isFirstFetch: false));
    try {
      final response = await api.get('${ApiLink.getPersonById}/$id');

      dynamic raw = response["data"];
      Map<String, dynamic>? personMap;
      if (raw != null) {
        if (raw is String) {
          try {
            final decoded = jsonDecode(raw);
            if (decoded is Map<String, dynamic>) personMap = decoded;
          } catch (_) {}
        } else if (raw is Map<String, dynamic>) {
          personMap = raw;
        } else if (raw is List && raw.isNotEmpty) {
          final first = raw.first;
          if (first is Map<String, dynamic>) personMap = first;
        }
      }

      if (personMap != null) {
        person = Person.fromJson(personMap);
        // initialize selection fields for edit screen
        setPersonForUpdate(person!);
        emit(PersonLoaded(people: people));
        return true;
      }

      throw Serverexception(
        errModel: ErrorModel(
          statusCode: 404,
          errorMessage: 'Person not found',
          isSuccess: false,
        ),
      );
    } on Serverexception catch (e) {
      emit(PersonFailure(errorMessage: e.errModel.errorMessage));
      return false;
    } catch (e, st) {
      print('fetchPersonById error: $e');
      print(st);
      emit(PersonFailure(errorMessage: e.toString()));
      return false;
    }
  }

  void _resetPeopleList() {
    _pageNumber = 1;
    people.clear();
  }

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }

  void uplodePorfilePicture(XFile image) {
    profilePicture = image;
    emit(UplodePeofilePicture());
  }

  void changeSelctedGender(String value) {
    selectedGender = value;
    emit(ChangeSelctedGender());
  }

  void changeSelectedVehicleType(VehicleType? selectedVehicleType) {
    this.selectedVehicleType = selectedVehicleType;
    emit(ChangeSelectedVehicleType());
  }

  void changeSelectedResidencyStatus(ResidencyStatus? selectedResidencyStatus) {
    this.selectedResidencyStatus = selectedResidencyStatus;
    emit(ChangeSelectedResidencyStatus());
  }

  void changeSelectedBloodType(BloodType selectedBloodType) {
    this.selectedBloodType = selectedBloodType;
    emit(ChangeSelectedBloodType());
  }

  void changeSelectedMaritalStatus(MaritalStatus selectedMaritalStatus) {
    this.selectedMaritalStatus = selectedMaritalStatus;
    emit(ChangeSelectedMaritalStatus());
  }

  void changeSelectedOccupationStatus(
    OccupationStatus selectedOccupationStatus,
  ) {
    this.selectedOccupationStatus = selectedOccupationStatus;
    emit(ChangeSelectedOccupationStatus());
  }

  void toggleHasChronicDiseases() {
    hasChronicDiseases = !hasChronicDiseases;
    emit(ChangeContactType());
  }
}
