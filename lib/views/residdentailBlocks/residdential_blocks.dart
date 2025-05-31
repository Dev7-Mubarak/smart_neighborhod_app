import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/constants/app_route.dart';
import 'package:smart_neighborhod_app/models/Block.dart';
import 'package:smart_neighborhod_app/views/residdentailBlocks/residential_block_detial.dart';

import '../../components/constants/app_image.dart';
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
  late BlockCubit _BlockCubit;

  @override
  void initState() {
    super.initState();
    _BlockCubit = context.read<BlockCubit>()..getBlocks();
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

  Widget showLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildLoadedListWidgets() {
    return ListView.builder(
      itemCount: residentialListSearch.length,
      itemBuilder: (context, index) {
        return _buildHousingUnitCard(
          block: residentialListSearch[index],
          // تمرير الدالة _showOptions كـ onLongPressCallback
          onLongPressCallback: (ctx, block) {
            _showOptions(ctx, block);
          },
        );
      },
    );
  }
  // الدالة التي تحل محل BuildHousingUnitCard Widget
  Widget _buildHousingUnitCard({
    required Block block,
    required void Function(BuildContext context, Block block) onLongPressCallback,
  }) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResiddentialBlocksDetail(block: block)),
      ),
      onLongPress: () {
        onLongPressCallback(context, block);
      },
      borderRadius: BorderRadius.circular(16), // نفس الانحناء للكرت
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // مسافة بين الكروت
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.gray,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              // هنا تأكد أن AppImage.residentailimage ليس فارغًا أو null
              // وإذا كان فارغًا/null، يمكنك عرض صورة بديلة أو معالجة ذلك.
              // أضفت بعض المنطق الأساسي هنا.
              child: AppImage.residentailimage.isNotEmpty
                  ? Image.asset(
                      AppImage.residentailimage,
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: AppImage.loadingimage, // تأكد من وجود هذه الصورة كأصل
                      image: AppImage.residentailimage, // إذا كان لديك URL للصورة في البلوك، استخدمه
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(AppImage.residentailimage); // صورة في حالة فشل التحميل
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    block.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "مدير المربع: ${block.managerName}",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                     Navigator.pop(context);
                Navigator.pushNamed(context, AppRoute.addNewBlock,
                    arguments: BlocProvider.of<BlockCubit>(context)
                  );
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

  void _showOptions(BuildContext passContext, bloc) {
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
                Navigator.pushNamed(context, AppRoute.addNewBlock,
                    arguments: BlocProvider.of<BlockCubit>(passContext)
                      ..setBlockForUpdate(bloc));
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
                          _BlockCubit.deleteBlock(bloc.id);
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
