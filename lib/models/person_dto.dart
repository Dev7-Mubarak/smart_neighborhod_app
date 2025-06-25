// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:smart_negborhood_app/cubits/person_cubit/person_cubit.dart';
import 'package:smart_negborhood_app/models/Person.dart';

class PersonDto {
  PersonCubit personCubit;
  Person? person;
  PersonDto({required this.personCubit, this.person});
}
