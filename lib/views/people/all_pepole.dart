import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:skeletons/skeletons.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import '../../components/constants/app_color.dart';
import '../../components/searcable_text_input_filed.dart';
import '../../components/smallButton.dart';
import '../../cubits/person_cubit/person_cubit.dart';

class AllPeople extends StatefulWidget {
  const AllPeople({super.key});

  @override
  State<AllPeople> createState() => _AllPeopleState();
}

class _AllPeopleState extends State<AllPeople> {
  late PersonCubit _personCubit;
  late TextEditingController _searchingController;
  late ScrollController _scrollController;
  Timer? _delay;

  @override
  void initState() {
    _personCubit = context.read<PersonCubit>()..getPeople();
    _searchingController = TextEditingController();
    _scrollController = ScrollController();

    _setListener();
    super.initState();
  }

  /// Adds a listener to the [_scrollController] that triggers loading the next page of people
  /// when the user scrolls within 200 pixels of the bottom of the scrollable area.
  ///
  /// When the scroll position reaches or exceeds the maximum scroll extent minus 200 pixels,
  /// the [_personCubit.loadNextPage()] method is called to fetch more data.
  void _setListener() {
    return _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _personCubit.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _scrollController.dispose();
    _delay?.cancel();
    super.dispose();
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
      body: Column(children: [_buildTopBar(context), _peopleListView()]),
    );
  }

  /// Builds the paginated, searchable people list.
  /// Handles loading, error, and loaded states, and shows a skeleton loader on first fetch.
  Widget _peopleListView() {
    return Expanded(
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

          // if (state is PersonLoading && state.isFirstFetch) {
          //   return const _SkeletonList();
          // }

          if (state is PersonLoaded ||
              (state is PersonLoading && !state.isFirstFetch)) {
            final people = _personCubit.people;
            final isLoadingMore = state is PersonLoading && !state.isFirstFetch;

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: isLoadingMore ? people.length + 1 : people.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index >= people.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final person = people[index];
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
                    _showOptions(context, person);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SmallButton(
            text: 'أضافة',
            onPressed: () {
              BlocProvider.of<PersonCubit>(context).person = null;
              Navigator.pushNamed(
                context,
                AppRoute.addUpdatePerson,
                arguments: BlocProvider.of<PersonCubit>(context),
              );
            },
          ),
          const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: 'بحث',
              prefixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _personCubit.getPeople();
                },
                icon: const Icon(Icons.close),
              ),
              suffixIcon: Icons.search,
              bachgroundColor: AppColor.gray2,
              onChanged: (value) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 400), () {
                  _personCubit.getPeople(search: value.trim());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext passContext, person) {
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
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdatePerson,
                  arguments: BlocProvider.of<PersonCubit>(passContext)
                    ..setPersonForUpdate(person),
                );
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<PersonCubit>(
                            passContext,
                          ).deletePerson(person.id);
                        },
                        child: const Text(
                          'حذف',
                          style: TextStyle(color: Colors.red),
                        ),
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

// class _SkeletonList extends StatelessWidget {
//   const _SkeletonList();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SkeletonListView(
//         itemCount: 10,
//         itemBuilder: (context, index) => const ListTile(
//           leading: SkeletonAvatar(
//             style: SkeletonAvatarStyle(
//               shape: BoxShape.circle,
//               width: 40,
//               height: 40,
//             ),
//           ),
//           title: SkeletonLine(style: SkeletonLineStyle(height: 16, width: 240)),
//           subtitle: SkeletonLine(
//             style: SkeletonLineStyle(height: 12, width: 100),
//           ),
//         ),
//       ),
//     );
//   }
// }
