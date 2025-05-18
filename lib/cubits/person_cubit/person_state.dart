part of 'person_cubit.dart';

@immutable
abstract class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> people;

  PersonLoaded({
    required this.people,
  });
}

class PersonLoading extends PersonState {}

class PersonFailure extends PersonState {
  final String errorMessage;
  PersonFailure({
    required this.errorMessage,
  });
}

class PersonAddedSuccessfully extends PersonState {
  final String message;
  PersonAddedSuccessfully({required this.message});
}

class UplodePeofilePicture extends PersonState {}

class ChangeSelctedGender extends PersonState {}

class ChangeContactType extends PersonState {}

class ChangeSelectedIdentityType extends PersonState {}

class ChangeSelectedBloodType extends PersonState {}

class ChangeSelectedMaritalStatus extends PersonState {}

class ChangeSelectedOccupationStatus extends PersonState {}
