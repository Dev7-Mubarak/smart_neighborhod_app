import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_neighborhod_app/core/errors/errormodel.dart';
import 'package:dio/dio.dart';
import 'package:smart_neighborhod_app/models/enums/Gender.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../models/Person.dart';
import '../../models/enums/blood_type.dart';
import '../../models/enums/identity_type.dart';
import '../../models/enums/marital_status.dart';
import '../../models/enums/occupation_status.dart';
import 'package:intl/intl.dart';
part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  PersonCubit({required this.api}) : super(PersonInitial());
  static PersonCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  XFile? profilePicture;
  String? selectedGender;
  bool isCall = false;
  bool isWhatsapp = false;
  IdentityType? selectedIdentityType;
  BloodType? selectedBloodType;
  MaritalStatus? selectedMaritalStatus;
  OccupationStatus? selectedOccupationStatus;
  DateTime? selectedDate;
  final TextEditingController dateController = TextEditingController();

  Future<void> getPeople() async {
    emit(PersonLoading());
    try {
      final response = await api.get(
        ApiLink.getAllPepole,
      );

      if (response["data"]["items"] == null) {
        throw Serverexception(
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
      }

      List<dynamic> people = response["data"]["items"];

      emit(
          PersonLoaded(people: people.map((e) => Person.fromJson(e)).toList()));
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
    required String phoneNumber,
    required String identityNumber,
    required String? email,
  }) async {
    emit(PersonLoading());
    try {
      final response = await api.post(
        ApiLink.addNewPerson,
        isFromData: true,
        data: {
          "FirstName": firstName,
          "SecondName": secondName,
          "ThirdName": thirdName,
          "LastName": lastName,
          "PhoneNumber": phoneNumber,
          "IsWhatsapp": isWhatsapp,
          "IsContactNumber": isCall,
          "Email": email,
          "DateOfBirth": selectedDate?.toIso8601String(),
          "Gender": GenderExtension.fromDisplayName(selectedGender!)
              .toString()
              .split('.')
              .last,
          "BloodType": selectedBloodType?.toString().split('.').last,
          "IdentityNumber": identityNumber,
          "IdentityType": selectedIdentityType?.toString().split('.').last,
          "MaritalStatus": selectedMaritalStatus?.toString().split('.').last,
          "OccupationStatus":
              selectedOccupationStatus?.toString().split('.').last,
          "Job": null,
          if (profilePicture != null)
            "Image": await MultipartFile.fromFile(profilePicture!.path,
                filename: profilePicture!.name),
        },
      );

      if (response["isSuccess"]) {
        emit(PersonAddedSuccessfully(message: response["message"]));
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
    emit(PersonLoading());
    try {
      final response = await api.delete(
        '${ApiLink.deletePerson}/$id',
      );

      if (response["isSuccess"]) {
        emit(PersonDeletedSuccessfully(message: response["message"]));
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

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(picked!);
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

  void changeContactType({bool? isCall, bool? isWhatsapp}) {
    this.isCall = isCall ?? false;
    this.isWhatsapp = isWhatsapp ?? false;
    emit(ChangeContactType());
  }

  void changeSelectedIdentityType(IdentityType selectedIdentityType) {
    this.selectedIdentityType = selectedIdentityType;
    emit(ChangeSelectedIdentityType());
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
      OccupationStatus selectedOccupationStatus) {
    this.selectedOccupationStatus = selectedOccupationStatus;
    emit(ChangeSelectedOccupationStatus());
  }
}
