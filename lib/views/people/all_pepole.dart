import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_route.dart';
import 'package:smart_neighborhod_app/components/constants/app_size.dart';
import 'package:smart_neighborhod_app/components/custom_text_input_filed.dart';
import 'package:smart_neighborhod_app/models/Person.dart';
import 'package:smart_neighborhod_app/models/person_dto.dart';
import '../../components/constants/app_color.dart';
import '../../components/searcable_text_input_filed.dart';
import '../../components/searcharea.dart';
import '../../components/smallButton.dart';
import '../../cubits/person_cubit/person_cubit.dart';

class AllPeople extends StatefulWidget {
  const AllPeople({super.key});

  @override
  State<AllPeople> createState() => _AllPeopleState();
}

class _AllPeopleState extends State<AllPeople> {
  late List<Person> allPeople;

  @override
  void initState() {
    context.read<PersonCubit>().getPeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'الأشخاص',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SmallButton(
                  text: 'أضافة',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.addNewPerson,
                        arguments: BlocProvider.of<PersonCubit>(context));
                  },
                ),
                const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
                Expanded(
                  child: SearchableTextFormField(
                    hintText: 'بحث',
                    prefixIcon: Icons.clear,
                    suffixIcon: Icons.search,
                    bachgroundColor: AppColor.gray2,
                    onChanged: (value) {
                      context.read<PersonCubit>().getPeople(search: value);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PersonCubit, PersonState>(
              builder: (context, state) {
                if (state is PersonFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is PersonLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PersonLoaded) {
                  allPeople = state.people;
                  if (allPeople.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد أشخاص حتى الآن.'),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: allPeople.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final person = allPeople[index];
                      return ListTile(
                        leading: person.image != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(person.image!),
                                backgroundColor: Colors.grey[200],
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColor.primaryColor,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                        title: Text(person.fullName),
                        onLongPress: () {
                          _showOptions(context, index, person);
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext passContext, int index, person) {
    showModalBottomSheet(
      context: passContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('تعديل'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoute.addNewPerson,
                    arguments: BlocProvider.of<PersonCubit>(passContext)
                      ..setPerson(person));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف'),
              onTap: () async {
                Navigator.pop(context);
                await showDialog<bool>(
                  context: passContext,
                  builder: (context) => AlertDialog(
                    title: const Text('تأكيد الحذف'),
                    content: const Text('هل أنت متأكد أنك تريد حذف هذا الشخص؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, AppRoute.addNewPerson,
                            arguments: PersonDto(
                                personCubit:
                                    BlocProvider.of<PersonCubit>(context),
                                person: person)),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<PersonCubit>(context)
                              .deletePerson(person.id);
                        },
                        child: const Text('حذف',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
