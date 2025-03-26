import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/models/Block.dart';

import '../components/constants/app_route.dart';
import '../components/residential_card.dart';
import '../components/searcharea.dart';
import '../core/API/dio_consumer.dart';
import '../cubits/ResiddentialBlocks_cubit/cubit/residdential_blocks_cubit.dart';
class ResidentialBlock extends StatefulWidget {
  const ResidentialBlock({super.key});

  @override
  State<ResidentialBlock> createState() => _ResidentialBlockState();
}

class _ResidentialBlockState extends State<ResidentialBlock> {
   List<Block> residentialListSearch = [];
   List<Block> residentialList=[];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ResiddentialBlocksCubit>(context).get_ResiddentialBlocks();
  }

  void updateSearchResults(List<Block> filteredList) {
    setState(() {
      residentialListSearch = filteredList;
    });
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ResiddentialBlocksCubit, ResiddentialBlocksState>(
      builder: (context, state) {
        if (state is get_ResiddentialBlocks_Success) {
          residentialList = state.AllResiddentialBlocks;
          residentialListSearch = residentialList; // عرض القائمة الأصلية
            //       print("reeeeeeeeeeemmmmmmmm${state.AllResiddentialBlocks[0].managerId}22222222");
            // print("reeeeeeeeeeemmmmmmmm${state.AllResiddentialBlocks[0].name}22222222");
            // print("reeeeeeeeeeemmmmmmmm${state.AllResiddentialBlocks[0].id}22222222");

          return buildLoadedListWidgets();
        } else if (state is get_ResiddentialBlocks_Loading){
          return showLoadingIndicator();
        } else if (state is get_ResiddentialBlocks_Failure){
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
    return const Center(
      child: CircularProgressIndicator());
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
                   Navigator.pushNamed(
                   context,
                    AppRoute.AddNewBlock,
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
}

// class ResidentialBlock extends StatefulWidget {
//   const ResidentialBlock({super.key});

//   @override
//   State<ResidentialBlock> createState() => _ResidentialBlockState();
// }

// class _ResidentialBlockState extends State<ResidentialBlock> {
//  late List<Block> residentialListSearch;
//  late  List<Block> residentialList ;
//   final _searchTextController = TextEditingController();
//   bool _isSearching = false;

// @override
// void initState() {
//   super.initState();
//   BlocProvider.of<ResiddentialBlocksCubit>(context).get_ResiddentialBlocks();
// }

//   // الكود الخاص بالبحث
//   Widget _buildSearchField() {
//     return Expanded(
//       child: Container(
//         height: 40, // التحكم في ارتفاع الحاوية الكاملة
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 243, 244, 246),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 8.0), // تقليل الحشو حول الحقل
//           child: TextField(
//             textAlign: TextAlign.right,
//             controller: _searchTextController,
//             cursorColor: AppColor.primaryColor,
//             decoration: const InputDecoration(
//               hintText: 'بحث',
//               border: InputBorder.none,
//               hintStyle: TextStyle(
//                 color: Color.fromARGB(255, 133, 134, 137),
//                 fontSize: 18,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                   vertical: 5.0), // التحكم في ارتفاع النص داخل الحقل
//             ),
//             style: const TextStyle(color: Colors.black, fontSize: 18),
//             onChanged: (searcheResidental) {
//               addSearchedForItemsToSearchedList(searcheResidental);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//    void addSearchedForItemsToSearchedList(String searcheResidental) {
//     residentialListSearch = residentialList
//         .where((residental) => residental.name
//             .toLowerCase()
//             .contains(searcheResidental.toLowerCase()))
//         .toList();
//     setState(() {});
//   }

//   Widget _buildAppBarActions() {
//     return IconButton(
//       onPressed: _isSearching ? _stopSearching : _startSearch,
//       icon: Icon(
//         _isSearching ? Icons.clear : Icons.search,
//         color: Colors.black,
//         size: 28,
//       ),
//     );
//   }

//   void _startSearch() {
//     setState(() {
//       _isSearching = true;
//     });
//   }

//   void _stopSearching() {
//     setState(() {
//       _searchTextController.clear();
//       _isSearching = false;
//       residentialListSearch = []; // لإلغاء الفلترة وإظهار القائمة الكاملة
//     });
//   }


// // الكود الخاص باللسته من المربعات السكنية
// Widget buildBlocWidget() {
//   return BlocBuilder<ResiddentialBlocksCubit, ResiddentialBlocksState>(
//     builder: (context, state) {
//       if (state is get_ResiddentialBlocks_Success) {
//         residentialList = state.AllResiddentialBlocks;
//         return buildLoadedListWidgets();
//       } else if (state is get_ResiddentialBlocks_Loading) {
//         return showLoadingIndicator();
//       } else if (state is get_ResiddentialBlocks_Failure) {
//         return Center(
//           child: Text(
//             state.errorMessage,
//             style: const TextStyle(color: Colors.red, fontSize: 18),
//           ),
//         );
//       } else {
//         return const Center(
//           child: Text("لا توجد بيانات للعرض حاليًا."),
//         );
//       }
//     },
//   );
// }

//   Widget showLoadingIndicator() {
//     return const Center(
//       child: CircularProgressIndicator(
//       ),
//     );
//   }

//   Widget buildLoadedListWidgets() {
//     return ListView.builder(
//           itemCount:  _searchTextController.text.isEmpty
//           ? residentialList.length
//           : residentialListSearch.length, // عدد العناصر التي سيتم عرضها
//           itemBuilder: (context, index) {
//             return BuildHousingUnitCard(
//           block: _searchTextController.text.isEmpty
//               ? residentialList[index]
//               : residentialListSearch[index],
//         ); // بناء ودجت لكل عنصر
//           },
//         );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return
//     //  BlocProvider(
//     //   create: (context) =>
//     //       ResiddentialBlocksCubit(api: DioConsumer(dio: Dio())),
//     //   child:
//            Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColor.primaryColor,
//                         minimumSize: const Size(40, 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: const Text(
//                         "أضافة",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     if (_isSearching) _buildSearchField(),
//                     _buildAppBarActions(),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child:buildBlocWidget()
//                 ),
//               ),
//             ],
//           );
        
      
    
//   }
  
// }
