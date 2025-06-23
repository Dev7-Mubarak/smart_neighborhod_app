import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_neighborhod_app/cubits/family_cubit/family_state.dart';
import 'package:smart_neighborhod_app/models/family.dart';
import '../../components/constants/app_route.dart';
import '../../components/constants/app_size.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/app_image.dart';
import '../../components/searcable_text_input_filed.dart';
import '../../components/smallButton.dart';
import '../../components/table.dart';
import '../../models/Block.dart';

class ResiddentialBlocksDetail extends StatefulWidget {
  final Block block;

  const ResiddentialBlocksDetail({super.key, required this.block});

  @override
  State<ResiddentialBlocksDetail> createState() =>
      _ResiddentialBlocksDetailState();
}

class _ResiddentialBlocksDetailState extends State<ResiddentialBlocksDetail> {
  List<Family> FamilysListSearch = [];
  List<Family> FamilysList = [];
  final ScrollController _scrollController = ScrollController();
  void updateSearchResults(List<Family> filteredList) {
    setState(() {
      FamilysListSearch = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();

    final familyCubit = BlocProvider.of<FamilyCubit>(context);
    familyCubit.getBlockFamiliesByBlockId(widget.block.id);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          familyCubit.state is! FamilyLoading) {
        familyCubit.getBlockFamiliesByBlockId(widget.block.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<FamilyCubit, FamilyState>(
      builder: (context, state) {
        if (state is FamilyLoaded) {
          FamilysList = state.families;
          FamilysListSearch = FamilysList;
          return buildLoadedListFamilys();
        } else if (state is FamilyLoading) {
          return showLoadingIndicator();
        } else if (state is FamilyFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else {
          return const Center(
            child: Text("لا توجد بيانات للعرض حاليًا."),
          );
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListFamilys() {
    return CustomTableWidget(
      columnTitles: const ['رقم التواصل', 'التصنيف', 'رب الأسرة', 'رقم'],
      columnFlexes: const [3, 2, 3, 1],
      rowData: FamilysList.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [family.name, family.name, family.familyNotes, '${index + 1}'];
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          bottomOpacity: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: Text(
                widget.block.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 205,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage(AppImage.residentailimage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.block.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مدير المربع:  ${widget.block.fullName}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'عدد الأسر: 200',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'عدد الأرامل: 50',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'عدد الأيتام: 110',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                    color: Color.fromARGB(255, 44, 44, 44), thickness: 1.5),
                const SizedBox(height: 10),
                const Text(
                  'الأسر في المربع السكني',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTopBar(context, widget.block.id),
                const SizedBox(height: 8),
                buildBlocWidget(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavigationBar());
  }
}

Widget _buildTopBar(BuildContext context, int blockId) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        SmallButton(
          text: 'أضافة',
          onPressed: () {
            var familyCubit = BlocProvider.of<FamilyCubit>(context);
            familyCubit.setBlockId(blockId);
            Navigator.pushNamed(context, AppRoute.addNewFamily,
                arguments: familyCubit);
          },
        ),
        const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
        Expanded(
          child: SearchableTextFormField(
            // controller: _searchingController,
            hintText: 'بحث',
            prefixIcon: IconButton(
                onPressed: () {
                  // _searchingController.clear();
                  // _personCubit.getPeople();
                },
                icon: const Icon(Icons.close)),
            suffixIcon: Icons.search,
            bachgroundColor: AppColor.gray2,
            // onChanged: (value) {
            //   _delay?.cancel();
            //   _delay = Timer(const Duration(milliseconds: 400), () {
            //     _personCubit.getPeople(search: value.trim());
            //   });
            // } ,
          ),
        )
      ],
    ),
  );
}
