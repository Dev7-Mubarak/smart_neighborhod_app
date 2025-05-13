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
