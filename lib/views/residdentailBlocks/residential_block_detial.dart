import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/BlockStatsSection.dart';
import 'package:smart_negborhood_app/components/FamilyListTable.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import 'package:smart_negborhood_app/components/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/models/BlockDetails.dart';
import 'package:smart_negborhood_app/models/family.dart';
import '../../components/custom_navigation_bar.dart';
import '../../components/constants/app_color.dart';
import '../../components/constants/app_image.dart';

//Edit Searching and use pagination
class ResiddentialBlocksDetail extends StatefulWidget {
  final int blockId;

  const ResiddentialBlocksDetail({super.key, required this.blockId});

  @override
  State<ResiddentialBlocksDetail> createState() =>
      _ResiddentialBlocksDetailState();
}

class _ResiddentialBlocksDetailState extends State<ResiddentialBlocksDetail> {
  late BlockDetails blockDetails;
  List<Family> searchedFamilies = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BlockCubit>(context).getBlockDetailes(widget.blockId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = value.trim().toLowerCase();
      setState(() {
        searchedFamilies = blockDetails.families
            .where(
              (family) => family.familyHeadName.toLowerCase().contains(query),
            )
            .toList();
      });
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      searchedFamilies = blockDetails.families;
    });
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlocksDetailesLoaded) {
              blockDetails = state.blockDetailes;

              if (_searchController.text.isEmpty) {
                searchedFamilies = blockDetails.families;
              }

              return Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
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
                      BlockStatsSection(details: blockDetails),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            SmallButton(
                              text: 'أضافة',
                              onPressed: () {
                                var familyCubit = BlocProvider.of<FamilyCubit>(
                                  context,
                                )..setBlockId(widget.blockId);
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.addNewFamily,
                                  arguments: familyCubit,
                                );
                              },
                            ),
                            const SizedBox(
                              width: AppSize.spasingBetweenInputsAndLabale,
                            ),
                            Expanded(
                              child: SearchableTextFormField(
                                controller: _searchController,
                                hintText: 'بحث باسم رب الأسرة',
                                prefixIcon: IconButton(
                                  onPressed: _onClearSearch,
                                  icon: const Icon(Icons.close),
                                ),
                                suffixIcon: Icons.search,
                                bachgroundColor: AppColor.gray2,
                                onChanged: _onSearchChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      FamilyListTable(families: searchedFamilies),
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
