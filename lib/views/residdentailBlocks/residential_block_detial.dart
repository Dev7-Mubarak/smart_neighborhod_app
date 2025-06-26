import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/models/BlockDetails.dart';
import 'package:smart_negborhood_app/models/family.dart';
import '../../components/constants/app_route.dart';
import '../../components/constants/app_size.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/app_image.dart';
import '../../components/searcable_text_input_filed.dart';
import '../../components/smallButton.dart';
import '../../components/table.dart';

class ResiddentialBlocksDetail extends StatefulWidget {
  final int blockId;

  const ResiddentialBlocksDetail({super.key, required this.blockId});

  @override
  State<ResiddentialBlocksDetail> createState() =>
      _ResiddentialBlocksDetailState();
}

class _ResiddentialBlocksDetailState extends State<ResiddentialBlocksDetail> {
  List<Family> FamilysListSearch = [];
  final ScrollController _scrollController = ScrollController();
  late BlockCubit blockCubit;
  @override
  void initState() {
    super.initState();

    blockCubit = BlocProvider.of<BlockCubit>(context)
      ..getBlockDetailes(widget.blockId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<BlockCubit, BlockState>(
      builder: (context, state) {
        if (state is BlocksDetailesLoaded) {
          return buildLoadedListFamilys(state.blockDetailes);
        } else if (state is BlocksLoading) {
          return showLoadingIndicator();
        } else if (state is BlocksFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else {
          return const Center(child: Text("لا توجد بيانات للعرض حاليًا."));
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListFamilys(BlockDetails blockDetailes) {
    return CustomTableWidget(
      columnTitles: const ['رقم التواصل', 'التصنيف', 'رب الأسرة', 'رقم'],
      columnFlexes: const [4, 2, 3, 1],
      rowData: blockDetailes.families.asMap().entries.map((entry) {
        int index = entry.key;
        var family = entry.value;
        return [
          family.familyHeadPhoneNumber,
          family.familyTypeName,
          family.familyHeadName,
          '${index + 1}',
        ];
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
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Center(
            child: Text(
              'تفاصيل المربع',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<BlockCubit, BlockState>(
          builder: (context, state) {
            if (state is BlocksLoading) {
              return showLoadingIndicator();
            }

            if (state is BlocksDetailesLoaded) {
              final details = state.blockDetailes;

              return Padding(
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
                            'مدير المربع:  ${details.managerName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'عدد الأسر: ${details.familyCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'عدد الأرامل: ${details.widowsCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'عدد الأيتام: ${details.orphansCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Color.fromARGB(255, 44, 44, 44),
                        thickness: 1.5,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'الأسر في المربع السكني',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTopBar(context, widget.blockId),
                      const SizedBox(height: 8),
                      buildBlocWidget(),
                    ],
                  ),
                ),
              );
            }

            if (state is BlocksFailure) {
              return Center(child: Text(state.errorMessage));
            }

            return const Center(child: Text("حدث خطأ غير متوقع"));
          },
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
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
            Navigator.pushNamed(
              context,
              AppRoute.addNewFamily,
              arguments: familyCubit,
            );
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
              icon: const Icon(Icons.close),
            ),
            suffixIcon: Icons.search,
            bachgroundColor: AppColor.gray2,
            // onChanged: (value) {
            //   _delay?.cancel();
            //   _delay = Timer(const Duration(milliseconds: 400), () {
            //     _personCubit.getPeople(search: value.trim());
            //   });
            // } ,
          ),
        ),
      ],
    ),
  );
}
