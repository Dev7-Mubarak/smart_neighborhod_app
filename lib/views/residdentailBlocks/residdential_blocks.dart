import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/constants/app_route.dart';
import 'package:smart_neighborhod_app/models/Block.dart';

import '../../components/residential_card.dart';
import '../../components/searcharea.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import '../../cubits/ResiddentialBlocks_cubit/cubit/block_state.dart';
import '../../cubits/person_cubit/person_cubit.dart';
import 'addNewBlock.dart';

class ResidentialBlock extends StatefulWidget {
  const ResidentialBlock({super.key});

  @override
  State<ResidentialBlock> createState() => _ResidentialBlockState();
}

class _ResidentialBlockState extends State<ResidentialBlock> {
  List<Block> residentialListSearch = [];
  List<Block> residentialList = [];

  @override
  void initState() {
    super.initState();
  }

  void updateSearchResults(List<Block> filteredList) {
    setState(() {
      residentialListSearch = filteredList;
    });
  }

  Widget buildBlocWidget() {
    return BlocBuilder<BlockCubit, BlockState>(
      builder: (context, state) {
        if (state is BlocksLoaded) {
          residentialList = state.allBlocks;
          residentialListSearch = residentialList;
          return buildLoadedListWidgets();
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
          return const Center(
            child: Text("لا توجد بيانات للعرض حاليًا."),
          );
        }
      },
    );
  }

  Widget showLoadingIndicator(){
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListWidgets() {
    return ListView.builder(
      itemCount: residentialListSearch.length,
      itemBuilder: (context, index) {
        return BuildHousingUnitCard(block: residentialListSearch[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                Navigator.pushNamed(context, AppRoute.addNewBlock);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MultiBlocProvider(
                  //       providers:[
                  //         BlocProvider<PersonCubit>.value(
                  //             value: context.read<PersonCubit>()),
                  //         BlocProvider<BlockCubit>.value(
                  //         value: context.read<BlockCubit>(),
                  //         ),
                  //       ],
                  //       child: const AddNewBlock(),
                  //     ),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "إضافة",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SearchWidget<Block>(
                originalList: residentialList,
                onSearch: updateSearchResults,
                searchCriteria: (block) => block.name, // البحث بالاسم
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: buildBlocWidget(),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../components/constants/app_color.dart';
// import '../components/constants/app_route.dart';
// import '../components/residential_card.dart';
// import '../components/searcharea.dart';
// import '../core/API/api_consumer.dart';
// import '../cubits/ResiddentialBlocks_cubit/cubit/residdential_blocks_cubit.dart';
// import '../models/Block.dart';

// class ResidentialBlock extends StatefulWidget {
//   const ResidentialBlock({super.key});

//   @override
//   State<ResidentialBlock> createState() => _ResidentialBlockState();
// }

// class _ResidentialBlockState extends State<ResidentialBlock> {

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<BlockCubit>(context).getBlocks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<BlockCubit, BlockState>(
//       listener: (context, state) {
//         if (state is BlocksFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.errorMessage)),
//           );
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<BlockCubit>();
//         List<Block> residentialListSearch = cubit.allBlocks;
        
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, AppRoute.AddNewBlock);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColor.primaryColor,
//                       minimumSize: const Size(40, 40),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       "إضافة",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SearchWidget<Block>(
//                     originalList: cubit.allBlocks,
//                     onSearch: (filteredList) {
//                       residentialListSearch = filteredList;
//                     },
//                     searchCriteria: (block) => block.name,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: _buildContent(state, residentialListSearch, cubit),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildContent(ResiddentialBlocksState state, List<Block> residentialListSearch, ResiddentialBlocksCubit cubit) {
//     if (state is ResiddentialBlocksLoading && residentialListSearch.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
    
//     if (state is ResiddentialBlocksFailure && residentialListSearch.isEmpty) {
//       return Center(child: Text(state.errorMessage));
//     }
    
//     return RefreshIndicator(
//       onRefresh: cubit.refresh,
//       child: ListView.builder(
//         itemCount: residentialListSearch.length + (cubit.hasmore ? 1 : 0),
//         itemBuilder: (context, index){
//           if (index < residentialListSearch.length) {
//             return InkWell(
//               onTap: () {
//                 Navigator.pushNamed(
//                   context, 
//                   AppRoute.residentialBlockDetial,
//                   arguments: residentialListSearch[index],
//                 );
//               },
//               child: BuildHousingUnitCard(block: residentialListSearch[index]),
//             );
//           } else {
//             if (cubit.hasmore && !cubit.isloading) {
//               cubit.getResidentialBlocks();
//             }
//             return Padding(
//               padding: const EdgeInsets.all(8),
//               child: Center(
//                 child: cubit.hasmore 
//                     ? const CircularProgressIndicator()
//                     : const Text("No more data to load"),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
