import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_route.dart';
import '../../components/constants/app_color.dart';
import '../../components/smallButton.dart';
import '../../cubits/person_cubit/person_cubit.dart';

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
              Navigator.pushNamed(context, AppRoute.addNewPerson,
                  arguments: BlocProvider.of<PersonCubit>(context));
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
                      context.read<PersonCubit>().getPeople();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.people.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final person = state.people[index];
                        return ListTile(
                          leading: person.image != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(person.image!),
                                  backgroundColor: Colors.grey[200],
                                )
                              : const CircleAvatar(
                                  backgroundColor: AppColor.primaryColor,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                          title: Text(person.fullName),
                          onLongPress: () {
                            _showOptions(context, index, person);
                          },
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
                // Navigate to edit screen or handle edit
                // Example:
                // Navigator.pushNamed(context, AppRoute.editPerson, arguments: person);
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
                        onPressed: () => Navigator.of(context).pop(),
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
