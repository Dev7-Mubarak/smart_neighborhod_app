import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/table.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/residential_blocks/cubits/residential_blocks_cubit/residential_blocks_cubit.dart';
import 'package:smart_negborhood_app/features/residential_blocks/cubits/residential_blocks_cubit/residential_blocks_state.dart';

class ResidentialBlockFamiliesView extends StatefulWidget {
  const ResidentialBlockFamiliesView({super.key});

  @override
  State<ResidentialBlockFamiliesView> createState() =>
      _ResidentialBlockFamiliesViewState();
}

class _ResidentialBlockFamiliesViewState
    extends State<ResidentialBlockFamiliesView> {
  late ResidentialBlocksCubit _residentialBlocksCubit;
  late TextEditingController _searchingController;
  Timer? _delay;
  @override
  void initState() {
    super.initState();
    _residentialBlocksCubit = context.read<ResidentialBlocksCubit>();
    _searchingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;
    return BlocBuilder<ResidentialBlocksCubit, ResidentialBlocksState>(
      buildWhen: (previous, current) =>
          current is ResidentialBlockFamiliesLoaded ||
          current is ResidentialBlockFamiliesLoading ||
          current is FailureForUpdateOrAddResidentialBlock,
      builder: (context, state) {
        String title = locale.Families;

        if (state is ResidentialBlockFamiliesLoaded) {
          title =
              "${locale.familiesInBlock} (${state.blockWithFamilies.name}) ";
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SearchableTextFormField(
                    controller: _searchingController,
                    hintText: locale.lookingFamily,
                    bachgroundColor: AppColor.gray2,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchingController.clear();
                        _residentialBlocksCubit.filterBlockfamilies('');
                      },
                      icon: const Icon(Icons.close),
                    ),
                    prefixIcon: Icons.search,
                    onChanged: (String query) {
                      _delay?.cancel();
                      _delay = Timer(const Duration(milliseconds: 300), () {
                        _residentialBlocksCubit.filterBlockfamilies(
                          query.trim(),
                        );
                      });
                    },
                  ),

                  SizedBox(height: 5),
                  Expanded(child: _buildBody(state, crossAxisCount, locale)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ResidentialBlocksState state, int crossAxisCount, locale) {
    if (state is ResidentialBlockFamiliesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FailureForUpdateOrAddResidentialBlock) {
      return OnFailureWidget(onRetry: () {});
    }

    if (state is ResidentialBlockFamiliesLoaded) {
      if (state.allBlockFamilies.isEmpty) {
        return Center(child: NoResultWidget());
      }

      return SingleChildScrollView(
        child: CustomTableWidget(
          columnTitles: const ["رقم", "إسم العائلة", "التصنيف", "الموقع"],
          columnFlexes: const [1, 3, 2, 3],
          rowData: state.allBlockFamilies.asMap().entries.map((entry) {
            int index = entry.key;
            var family = entry.value;
            return [
              '${index + 1}',
              family.name,
              family.familyCategoryName,
              family.location,
            ];
          }).toList(),
          onRowTap: (rowIndex) {
            Navigator.pushNamed(
              context,
              AppRoute.residentialBlockFamilyMembers,
              arguments: state.allBlockFamilies[rowIndex].id,
            );
          },
          originalObjects: state.allBlockFamilies,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
