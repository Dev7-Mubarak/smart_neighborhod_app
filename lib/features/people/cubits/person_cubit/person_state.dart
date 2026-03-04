part of 'person_cubit.dart';

@immutable
abstract class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> people;

  PersonLoaded({required this.people});
}

class PersonLoading extends PersonState {
  final bool isFirstFetch;
  PersonLoading({this.isFirstFetch = false});
}

class PersonFailure extends PersonState {
  final String errorMessage;
  PersonFailure({required this.errorMessage});
}

class PersonAddedSuccessfully extends PersonState {
  final String message;
  PersonAddedSuccessfully({required this.message});
}

class PersonAddedFailure extends PersonState {
  final String errorMessage;
  PersonAddedFailure({required this.errorMessage});
}

class PersonDeletedSuccessfully extends PersonState {
  final String message;
  PersonDeletedSuccessfully({required this.message});
}

class PersonDeletedFailure extends PersonState {
  final String errorMessage;
  PersonDeletedFailure({required this.errorMessage});
}

class PersonUpdatedSuccessfully extends PersonState {
  final String message;
  PersonUpdatedSuccessfully({required this.message});
}

class PersonUpdatedFailure extends PersonState {
  final String errorMessage;
  PersonUpdatedFailure({required this.errorMessage});
}

class UplodePeofilePicture extends PersonState {}

class WaitingForUpdateOrAddPerson extends PersonState {}

class ChangeBirthDate extends PersonState {}

class ChangeSelctedGender extends PersonState {}

class ChangeContactType extends PersonState {}

// Identity type and person type states were removed when those fields
// were cleaned from the cubit/view. Only keep relevant states.

class ChangeSelectedBloodType extends PersonState {}

class ChangeSelectedMaritalStatus extends PersonState {}

class ChangeSelectedOccupationStatus extends PersonState {}


class ChangeSelectedVehicleType extends PersonState {}

class ChangeSelectedResidencyStatus extends PersonState {}
