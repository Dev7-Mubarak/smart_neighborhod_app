import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/BlockStatsSection.dart';
import 'package:smart_negborhood_app/core/common/widgets/FamilyListTable.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/data/models/BlockDetails.dart';
import 'package:smart_negborhood_app/features/families/data/models/family.dart';
import 'package:smart_negborhood_app/features/residdentailBlocks/data/models/bind_cubit.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_image.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../auth/data/models/login_model.dart';
import '../../cubits/BlockDetailCubit/block_detail_cubit.dart';
import '../../cubits/BlockDetailCubit/block_detail_state.dart';

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
  late final ProfileModel _profileModel;

  @override
  void initState() {
    _getBlockDetailes();
    _profileModel = SharedPreferencesService.getProfile()!;
    super.initState();
  }

  Future<void> _getBlockDetailes() async {
    await context.read<BlockDetailCubit>().getBlockDetailes(widget.blockId);
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
              (family) =>
                  (family.familyHeadName?.toLowerCase() ?? '').contains(query),
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
        child: BlocBuilder<BlockDetailCubit, BlockDetailState>(
          builder: (context, state) {
            if (state is BlockDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlockDetailLoaded) {
              blockDetails = state.blockDetails;

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
                      const Divider(color: AppColor.gray2, thickness: 1.5),
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
                            if (_profileModel.role == AppRole.Admin.name)
                              SmallButton(
                                text: 'أضافة',
                                onPressed: () {
                                  FamilyCubit familyCubit = context
                                      .read<FamilyCubit>();
                                  familyCubit.setFamily(null);

                                  BlockDetailCubit blockDetailCubit = context
                                      .read<BlockDetailCubit>();

                                  final bindCubit = BindCubit(
                                    familyCubit: familyCubit,
                                    blockDetailCubit: blockDetailCubit,
                                  );

                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.addUpdateFamily,
                                    arguments: bindCubit,
                                  );
                                },
                              ),
                            if (_profileModel.role == AppRole.Admin.name)
                              const SizedBox(
                                width: AppSize.spasingBetweenInputsAndLabale,
                              ),
                            Expanded(
                              child: SearchableTextFormField(
                                controller: _searchController,
                                hintText: 'بحث باسم رب الأسرة',
                                suffixIcon: IconButton(
                                  onPressed: _onClearSearch,
                                  icon: const Icon(Icons.close),
                                ),
                                prefixIcon: Icons.search,
                                bachgroundColor: AppColor.gray2,
                                onChanged: _onSearchChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      FamilyListTable(
                        families: searchedFamilies,
                        familyCubit: context.read<FamilyCubit>(),
                        blockDetailCubit: context.read<BlockDetailCubit>(),
                        profileModel: _profileModel,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is BlockDetailFailure) {
              return Center(child: Text(state.errorMessage));
            }

            return const Center(child: Text("حدث خطأ غير متوقع"));
          },
        ),
      ),
    );
  }
}
