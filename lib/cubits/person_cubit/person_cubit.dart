import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:smart_neighborhod_app/core/errors/errormodel.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../models/Person.dart';
import '../../models/enums/blood_type.dart';
import '../../models/enums/identity_type.dart';
import '../../models/enums/marital_status.dart';
import '../../models/enums/occupation_status.dart';

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

  Future<void> getPeople() async {
    emit(PersonLoading());
    try {
      final response = await api.get(
        ApiLink.getAllPepole,
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel:
                ErrorModel(status: 400, errorMessage: "No data received"));
      }

      List<dynamic> people = response["data"];

      emit(
          PersonLoaded(people: people.map((e) => Person.fromJson(e)).toList()));
    } on Serverexception catch (e) {
      emit(PersonFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(PersonFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addNewPerson(
      {required String firstName,
      required String secondName,
      required String thirdName,
      required String lastName,
      required String phoneNumber,
      required String identityNumber,
      required String dateOfBirth,
      required String? email,
      required String? job,
      em}) async {
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
          "DateOfBirth": dateOfBirth,
          "Gender": selectedGender,
          "Image": profilePicture,
          "BloodType": selectedBloodType,
          "IdentityNumber": identityNumber,
          "IdentityType": selectedIdentityType,
          "MaritalStatus": selectedMaritalStatus,
          "OccupationStatus": selectedOccupationStatus,
          "Job": job,
        },
      );

      if (response["isSuccess"]) {
        emit(PersonAddedSuccessfully(message: response["message"]));
      } else {
        emit(PersonFailure(errorMessage: response["message"]));
      }
    } on Serverexception catch (e) {
      emit(PersonFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(PersonFailure(errorMessage: e.toString()));
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
