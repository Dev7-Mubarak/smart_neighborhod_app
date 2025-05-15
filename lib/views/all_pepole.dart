import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_route.dart';
import '../components/constants/app_color.dart';
import '../components/smallButton.dart';
import '../cubits/person_cubit/person_cubit.dart';

class AllPeople extends StatelessWidget {
  const AllPeople({super.key});

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
          SmallButton(
            text: 'أضافة شخص',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.AddNewPerson);
            },
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
                  if (state.people.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد أشخاص حتى الآن.'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<PersonCubit>()
                          .getPeople(); // Trigger refresh
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.people.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final person = state.people[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColor.primaryColor,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(person.fullName),
                        );
                      },
                    ),
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
}
