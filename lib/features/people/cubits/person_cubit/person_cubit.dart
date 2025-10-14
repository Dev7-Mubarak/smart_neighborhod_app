import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  PersonCubit({required this.api}) : super(PersonInitial());
  static PersonCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Person? person;
  XFile? profilePicture;
  String? selectedGender;
  bool isCall = false;
  bool isWhatsapp = false;
  BloodType? selectedBloodType;
  MaritalStatus? selectedMaritalStatus;
  OccupationStatus? selectedOccupationStatus;
  DateTime? selectedDate;
  bool _hasNextPage = false;
  int _pageNumber = 1;
  final int _pageSize = 10;
  List<Person> people = [];

  /// Sets the cubit fields for editing a person.
  /// Copies all relevant fields from the given [person] to the cubit state.
  void setPersonForUpdate(Person person) {
    this.person = person;
    selectedBloodType = person.bloodType;
    selectedMaritalStatus = person.maritalStatus;
    selectedOccupationStatus = person.occupationStatus;
    selectedDate = person.dateOfBirth;
    selectedGender = person.gender;
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
    } catch (e) {
      emit(PersonFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addNewPerson({
    required String firstName,
    required String secondName,
    required String thirdName,
    required String lastName,
    required String? phoneNumber,
  }) async {
    emit(WaitingForUpdateOrAddPerson());

    try {
      final Map<String, dynamic> requestData = {
        "FirstName": firstName,
        "SecondName": secondName,
        "ThirdName": thirdName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": selectedDate,
        "Gender": selectedGender,

        "BloodType": selectedBloodType?.toString().split('.').last,
        "MaritalStatus": selectedMaritalStatus?.toString().split('.').last,
        "OccupationStatus": selectedOccupationStatus
            ?.toString()
            .split('.')
            .last,
        "Job": null,

        "Image": profilePicture != null
            ? await MultipartFile.fromFile(
                profilePicture!.path,
                filename: profilePicture!.name,
              )
            : null,
      };

      // Debug log to ensure data is ready
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
  }) async {
    emit(WaitingForUpdateOrAddPerson());
    try {
      final response = await api.update(
        '${ApiLink.updatePerson}/$id',
        isFromData: true,
        data: {
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
          "Job": null,
          if (profilePicture != null)
            "Image": await MultipartFile.fromFile(
              profilePicture!.path,
              filename: profilePicture!.name,
            ),
        },
      );

      if (response["isSuccess"]) {
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

  void toggleContactType({bool? isCall, bool? isWhatsapp}) {
    this.isCall = isCall ?? false;
    this.isWhatsapp = isWhatsapp ?? false;
    emit(ChangeContactType());
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
}
