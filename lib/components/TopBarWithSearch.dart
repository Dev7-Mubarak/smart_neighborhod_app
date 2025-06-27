import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_route.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import 'package:smart_negborhood_app/components/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';

class TopBarWithSearch extends StatelessWidget {
  final int blockId;
  final TextEditingController searchController;
  const TopBarWithSearch({
    super.key,
    required this.blockId,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
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
              hintText: 'بحث',
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
              suffixIcon: Icons.search,
              bachgroundColor: AppColor.gray2,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
