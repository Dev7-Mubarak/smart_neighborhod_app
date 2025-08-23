import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/common/widgets/smallButton.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_cubit.dart';

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
              // familyCubit.setBlockId(blockId);
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateFamily,
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
