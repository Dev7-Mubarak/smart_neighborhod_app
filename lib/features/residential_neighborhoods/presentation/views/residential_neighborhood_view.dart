// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:smart_negborhood_app/core/config/generated/l10n.dart';
// import 'package:smart_negborhood_app/core/constants/app_color.dart';
// import 'package:smart_negborhood_app/core/constants/app_image.dart';
// import 'package:smart_negborhood_app/core/constants/app_route.dart';
// import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
// import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
// import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
// import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
// import '../../../../core/common/enums/app_role.dart';
// import '../../../../core/common/widgets/no_result_widget.dart';
// import '../../../../core/constants/app_size.dart';
// import '../../../../core/common/widgets/smallButton.dart';
// import '../../../../core/services/shared_preferences_service.dart';
// import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
// import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
// import '../../data/models/residential_neighborhood_model.dart';
// import '../widgets/change_neighborhood_name_widget.dart';

// class ResidentialNeighborhoodView extends StatefulWidget {
//   const ResidentialNeighborhoodView({super.key});

//   @override
//   State<ResidentialNeighborhoodView> createState() =>
//       _ResidentialNeighborhoodViewState();
// }

// class _ResidentialNeighborhoodViewState
//     extends State<ResidentialNeighborhoodView> {
//   List<ResidentialNeighborhoodModel> residentialList = [];
//   late final ResidentialNeighborhoodsCubit _residentialNeighborhoodsCubit;
//   late final ProfileModel? _profileModel;
//   late TextEditingController _searchingController;
//   Timer? _delay;

//   @override
//   void initState() {
//     super.initState();
//     _residentialNeighborhoodsCubit =
//         context.read<ResidentialNeighborhoodsCubit>()
//           ..getResidentialNeighborhoods();
//     _searchingController = TextEditingController();

//     _profileModel = SharedPreferencesService.getProfile();
//   }

//   @override
//   void dispose() {
//     _searchingController.dispose();
//     super.dispose();
//   }

//   Widget buildBlocWidget(int crossAxisCount, AppLocalizations locale) {
//     return BlocBuilder<
//       ResidentialNeighborhoodsCubit,
//       ResidentialNeighborhoodsState
//     >(
//       buildWhen: (previous, current) {
//         if (current is FailureForUpdateOrAddResidentialNeighborhood) {
//           return false;
//         }
//         if (current is WaitingForUpdateOrAddResidentialNeighborhood) {
//           return false;
//         }
//         return true;
//       },
//       builder: (context, state) {
//         if (state is ResidentialNeighborhoodsLoaded) {
//           return buildLoadedListWidgets(
//             state.allFilteredNeighborhoods,
//             crossAxisCount,
//             locale,
//           );
//         } else if (state is ResidentialNeighborhoodsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is ResidentialNeighborhoodsFailure) {
//           return OnFailureWidget(
//             onRetry: () =>
//                 _residentialNeighborhoodsCubit.getResidentialNeighborhoods(),
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   Widget buildLoadedListWidgets(
//     List<ResidentialNeighborhoodModel> residentialNeighborhoods,
//     int crossAxisCount,
//     AppLocalizations locale,
//   ) {
//     if (residentialNeighborhoods.isEmpty) {
//       return Center(child: NoResultWidget());
//     }
//     return SingleChildScrollView(
//       child: StaggeredGrid.count(
//         crossAxisCount: crossAxisCount,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         children: residentialNeighborhoods.map((e) {
//           return StaggeredGridTile.fit(
//             crossAxisCellCount: 1,
//             child: InkWell(
//               onTap: () {},
//               onLongPress: () {
//                 if (_profileModel?.role == AppRole.Admin.name) {
//                   _showOptions(e);
//                 }
//               },
//               child: Container(
//                 // padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: AppColor.gray,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 70,
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(16),
//                           topRight: Radius.circular(16),
//                         ),
//                         child: AppImage.residentailimage.isNotEmpty
//                             ? Image.asset(
//                                 AppImage.residentailimage,
//                                 height: MediaQuery.of(context).size.width * 0.7,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               )
//                             : FadeInImage.assetNetwork(
//                                 height: MediaQuery.of(context).size.width * 0.7,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 placeholder: AppImage.loadingimage,
//                                 image: AppImage.residentailimage,
//                                 imageErrorBuilder:
//                                     (context, error, stackTrace) {
//                                       return Image.asset(
//                                         AppImage.residentailimage,
//                                       );
//                                     },
//                               ),
//                         // fit: BoxFit.scaleDown,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       child: Text(
//                         e.name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(height: 4),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       child: Text(
//                         '${locale.blockManager}: ${e.neighborhoodManagerName}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//     //  ListView.builder(
//     //   itemCount: residentialNeighborhoods.length,
//     //   itemBuilder: (context, index) {
//     // return ResidentialNeighborhoodCardWidget(
//     //       onTapCallback: (ctx, residentialNeighborhood) {
//     //         Navigator.pushNamed(
//     //           context,
//     //           AppRoute.residentialBlockDetial,
//     //           arguments: residentialNeighborhoods[index].id,
//     //         );
//     //       },
//     //       residentialNeighborhood: residentialNeighborhoods[index],
//     //       onLongPressCallback: (ctx, residentialNeighborhood) {
//     //         if (_profileModel?.role == AppRole.Admin.name) {
//     //           _showOptions(residentialNeighborhoods[index]);
//     //         }
//     //       },
//     //     );
//     //   },
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locale = context.locale;
//     final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;

//     return BlocListener<
//       ResidentialNeighborhoodsCubit,
//       ResidentialNeighborhoodsState
//     >(
//       listener: (context, state) {
//         if (state is WaitingForUpdateOrAddResidentialNeighborhood) {
//           context.showLoadingDialog();
//         } else if (state is ResidentialNeighborhoodAddedSuccessfully) {
//           Navigator.of(context, rootNavigator: true).pop();
//           context.showSuccessSnackBar(state.message);
//           Navigator.pop(context);
//         } else if (state is ResidentialNeighborhoodDeletedSuccessfully) {
//           Navigator.of(context, rootNavigator: true).pop();
//           context.showSuccessSnackBar(state.message);
//         } else if (state is ResidentialNeighborhoodsFailure ||
//             state is FailureForUpdateOrAddResidentialNeighborhood) {
//           Navigator.of(context, rootNavigator: true).pop();
//           context.showErrorSnackBar(
//             state is ResidentialNeighborhoodsFailure
//                 ? state.errorMessage
//                 : (state as FailureForUpdateOrAddResidentialNeighborhood)
//                       .errorMessage,
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,

//         body: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (_profileModel?.role == AppRole.Admin.name)
//                       SmallButton(
//                         text: locale.add,
//                         onPressed: () {
//                           Navigator.pushNamed(
//                             context,
//                             AppRoute.addResidentialNeighborhood,
//                             arguments:
//                                 BlocProvider.of<ResidentialNeighborhoodsCubit>(
//                                   context,
//                                 ),
//                           ).then((_) {
//                             _residentialNeighborhoodsCubit
//                                 .getResidentialNeighborhoods(
//                                   // search: _searchingController.text
//                                   //     .trim(),
//                                 );
//                           });
//                           ;
//                         },
//                       ),
//                     if (_profileModel?.role == AppRole.Admin.name)
//                       const SizedBox(
//                         width: AppSize.spasingBetweenInputsAndLabale,
//                       ),
//                     Expanded(
//                       child: SearchableTextFormField(
//                         controller: _searchingController,
//                         hintText: locale.searchResidentialBlock,
//                         bachgroundColor: AppColor.gray2,
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             _searchingController.clear();
//                             _residentialNeighborhoodsCubit.filterNeighborhoods(
//                               '',
//                             );
//                           },
//                           icon: const Icon(Icons.close),
//                         ),
//                         prefixIcon: Icons.search,
//                         onChanged: (String query) {
//                           _delay?.cancel();
//                           _delay = Timer(const Duration(milliseconds: 300), () {
//                             _residentialNeighborhoodsCubit.filterNeighborhoods(
//                               query.trim(),
//                             );
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: buildBlocWidget(crossAxisCount, locale),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showOptions(ResidentialNeighborhoodModel residentialNeighborhood) {
//     final locale = context.locale;

//     context.showBottomSheet(
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               locale.residentialNeighborhoodOptions,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),

//             ElevatedButton.icon(
//               icon: const Icon(Icons.edit),
//               label: Text(locale.ChangeNeighborhoodName),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.white,
//                 foregroundColor: AppColor.primaryColor,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _residentialNeighborhoodsCubit.setResidentialNeighborhood(
//                   residentialNeighborhood,
//                 );
//                 context.showBottomSheet(
//                   BlocProvider.value(
//                     value: _residentialNeighborhoodsCubit,
//                     child: ChangeNeighborhoodNameWidget(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.person),
//               label: Text(locale.ChangeNeighborhoodManagerName),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.white,
//                 foregroundColor: AppColor.primaryColor,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(
//                   context,
//                   AppRoute.changeBlockManager,
//                   arguments: context.read<ResidentialNeighborhoodsCubit>()
//                     ..setResidentialNeighborhood(residentialNeighborhood),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.delete),
//               label: Text(locale.delete),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: AppColor.white,
//               ),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await showDialog<bool>(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text(locale.confirmDelete),
//                     content: Text(locale.deleteNotAllowed),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text(locale.cancel),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           _residentialNeighborhoodsCubit
//                               .deleteResidentialNeighborhood(
//                                 residentialNeighborhood.id,
//                               );
//                         },
//                         child: Text(
//                           locale.delete,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_negborhood_app/core/config/generated/l10n.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_image.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/features/auth/data/models/login_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/data/models/residential_neighborhood_Dashboard_model.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/dashboard_stats_widget.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/neighborhood_card_widget.dart';
import 'package:smart_negborhood_app/features/residential_neighborhoods/presentation/widgets/neighborhood_options_sheet.dart';
import '../../../../core/common/enums/app_role.dart';
import '../../../../core/common/widgets/no_result_widget.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/smallButton.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_cubit.dart';
import '../../cubits/residential_neighborhoods_cubit/residential_neighborhoods_state.dart';
import '../../data/models/residential_neighborhood_model.dart';
import '../widgets/change_neighborhood_name_widget.dart';

// class ResidentialNeighborhoodView extends StatefulWidget {
//   const ResidentialNeighborhoodView({super.key});

//   @override
//   State<ResidentialNeighborhoodView> createState() =>
//       _ResidentialNeighborhoodViewState();
// }

// class _ResidentialNeighborhoodViewState
//     extends State<ResidentialNeighborhoodView> {
//   List<ResidentialNeighborhoodModel> residentialList = [];
//   late final ResidentialNeighborhoodsCubit _residentialNeighborhoodsCubit;
//   late final ProfileModel? _profileModel;
//   late TextEditingController _searchingController;
//   Timer? _delay;

//   @override
//   void initState() {
//     super.initState();
//     _residentialNeighborhoodsCubit =
//         context.read<ResidentialNeighborhoodsCubit>()
//           ..getResidentialNeighborhoodsDashboard();
//     _searchingController = TextEditingController();

//     _profileModel = SharedPreferencesService.getProfile();
//   }

//   @override
//   void dispose() {
//     _searchingController.dispose();
//     super.dispose();
//   }

//   Widget buildBlocWidget(int crossAxisCount, AppLocalizations locale) {
//     return BlocBuilder<
//       ResidentialNeighborhoodsCubit,
//       ResidentialNeighborhoodsState
//     >(
//       buildWhen: (previous, current) =>
//           current is ResidentialNeighborhoodsLoaded ||
//           current is ResidentialNeighborhoodsLoading ||
//           current is ResidentialNeighborhoodsFailure,
//       builder: (context, state) {
//         if (state is ResidentialNeighborhoodsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is ResidentialNeighborhoodsFailure) {
//           return OnFailureWidget(
//             onRetry: () => _residentialNeighborhoodsCubit
//                 .getResidentialNeighborhoodsDashboard(),
//           );
//         } else if (state is ResidentialNeighborhoodsLoaded) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             child: Column(
//               children: [
//                 _buildDashboardStats(state.dashboardData, locale),

//                 const SizedBox(height: 20),

//                 if (state.filteredNeighborhoods.isEmpty)
//                   SizedBox(height: 200, child: Center(child: NoResultWidget()))
//                 else
//                   StaggeredGrid.count(
//                     crossAxisCount: crossAxisCount,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     children: state.filteredNeighborhoods.map((neighborhood) {
//                       return StaggeredGridTile.fit(
//                         crossAxisCellCount: 1,
//                         child: _buildNeighborhoodCard(
//                           neighborhood,
//                           context,
//                           locale,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         } else {
//           return Container();
//         }
//       },

//     );
//   }

//   Widget _buildDashboardStats(
//     ResidentialNeighborhoodDashboardModel data,
//     var locale,
//   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatItem(
//             title: "الأحياء", // locale.neighborhoods
//             count: data.totalNeighborhoods,
//             icon: Icons.location_city,
//             color: AppColor.primaryColor,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _buildStatItem(
//             title: "الوحدات", // locale.units
//             count: data.totalUnits,
//             icon: Icons.home,
//             color: const Color(0xFFEFA98D),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _buildStatItem(
//             title: "المربعات", // locale.blocks
//             count: data.totalBlocks,
//             icon: Icons.grid_view,
//             color: Color(0xFFE8618C),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatItem({
//     required String title,
//     required int count,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(255, 222, 222, 222),
//             blurRadius: 8,
//             offset: const Offset(3, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 4),
//           Text(
//             count.toString(),
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNeighborhoodCard(
//     ResidentialNeighborhoodModel neighborhood,
//     BuildContext context,
//     var locale,
//   ) {
//     return InkWell(
//       onTap: () {},
//       onLongPress: () {
//         if (_profileModel?.role == AppRole.Admin.name) {
//           _showOptions(neighborhood);
//         }
//       },
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(251, 255, 255, 255),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(2, 2),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColor.primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.location_city,
//                     color: AppColor.primaryColor,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     neighborhood.neighborhoodName,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 24),

//             Row(
//               children: [
//                 const Icon(Icons.person_outline, size: 16, color: Colors.grey),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     neighborhood.managerName,
//                     style: const TextStyle(fontSize: 12, color: Colors.black87),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildMiniStat(
//                   Icons.home_work_outlined,
//                   "${neighborhood.unitsCount} وحدة",
//                 ),
//                 _buildMiniStat(
//                   Icons.layers_outlined,
//                   "${neighborhood.blocksCount} مربع",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMiniStat(IconData icon, String label) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: Colors.grey[600]),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey[700],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locale = context.locale;
//     final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;

//     return BlocListener<
//       ResidentialNeighborhoodsCubit,
//       ResidentialNeighborhoodsState
//     >(
//       listener: (context, state) {
//         if (state is WaitingForUpdateOrAddResidentialNeighborhood) {
//           context.showLoadingDialog();
//         } else if (state is ResidentialNeighborhoodAddedSuccessfully) {
//           Navigator.of(context, rootNavigator: true).pop();
//           context.showSuccessSnackBar(state.message);
//           Navigator.pop(context);
//         } else if (state is ResidentialNeighborhoodDeletedSuccessfully) {
//           Navigator.of(context, rootNavigator: true).pop();
//           context.showSuccessSnackBar(state.message);
//         } else if (state is ResidentialNeighborhoodsFailure ||
//             state is FailureForUpdateOrAddResidentialNeighborhood) {
//           Navigator.of(context, rootNavigator: true).pop();
//           context.showErrorSnackBar(
//             state is ResidentialNeighborhoodsFailure
//                 ? state.errorMessage
//                 : (state as FailureForUpdateOrAddResidentialNeighborhood)
//                       .errorMessage,
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,

//         body: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (_profileModel?.role == AppRole.Admin.name)
//                       SmallButton(
//                         text: locale.add,
//                         onPressed: () {
//                           Navigator.pushNamed(
//                             context,
//                             AppRoute.addResidentialNeighborhood,
//                             arguments:
//                                 BlocProvider.of<ResidentialNeighborhoodsCubit>(
//                                   context,
//                                 ),
//                           ).then((_) {
//                             _residentialNeighborhoodsCubit
//                                 .getResidentialNeighborhoodsDashboard(
//                                   search: _searchingController.text.trim(),
//                                 );
//                           });
//                           ;
//                         },
//                       ),
//                     if (_profileModel?.role == AppRole.Admin.name)
//                       const SizedBox(
//                         width: AppSize.spasingBetweenInputsAndLabale,
//                       ),
//                     Expanded(
//                       child: SearchableTextFormField(
//                         controller: _searchingController,
//                         hintText: locale.searchResidentialBlock,
//                         bachgroundColor: AppColor.gray2,
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             _searchingController.clear();
//                             _residentialNeighborhoodsCubit.filterNeighborhoods(
//                               '',
//                             );
//                           },
//                           icon: const Icon(Icons.close),
//                         ),
//                         prefixIcon: Icons.search,
//                         onChanged: (String query) {
//                           _delay?.cancel();
//                           _delay = Timer(const Duration(milliseconds: 300), () {
//                             _residentialNeighborhoodsCubit.filterNeighborhoods(
//                               query.trim(),
//                             );
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: buildBlocWidget(crossAxisCount, locale),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showOptions(ResidentialNeighborhoodModel residentialNeighborhood) {
//     final locale = context.locale;

//     context.showBottomSheet(
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               locale.residentialNeighborhoodOptions,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),

//             ElevatedButton.icon(
//               icon: const Icon(Icons.edit),
//               label: Text(locale.ChangeNeighborhoodName),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.white,
//                 foregroundColor: AppColor.primaryColor,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _residentialNeighborhoodsCubit.setResidentialNeighborhood(
//                   residentialNeighborhood,
//                 );
//                 context.showBottomSheet(
//                   BlocProvider.value(
//                     value: _residentialNeighborhoodsCubit,
//                     child: ChangeNeighborhoodNameWidget(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.person),
//               label: Text(locale.ChangeNeighborhoodManagerName),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.white,
//                 foregroundColor: AppColor.primaryColor,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(
//                   context,
//                   AppRoute.changeBlockManager,
//                   arguments: context.read<ResidentialNeighborhoodsCubit>()
//                     ..setResidentialNeighborhood(residentialNeighborhood),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.delete),
//               label: Text(locale.delete),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: AppColor.white,
//               ),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await showDialog<bool>(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text(locale.confirmDelete),
//                     content: Text(locale.deleteNotAllowed),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text(locale.cancel),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           _residentialNeighborhoodsCubit
//                               .deleteResidentialNeighborhood(
//                                 residentialNeighborhood.neighborhoodId,
//                               );
//                         },
//                         child: Text(
//                           locale.delete,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ResidentialNeighborhoodView extends StatefulWidget {
  const ResidentialNeighborhoodView({super.key});

  @override
  State<ResidentialNeighborhoodView> createState() =>
      _ResidentialNeighborhoodViewState();
}

class _ResidentialNeighborhoodViewState
    extends State<ResidentialNeighborhoodView> {
  late final ResidentialNeighborhoodsCubit _residentialNeighborhoodsCubit;
  late final ProfileModel? _profileModel;
  late TextEditingController _searchingController;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _residentialNeighborhoodsCubit =
        context.read<ResidentialNeighborhoodsCubit>()
          ..getResidentialNeighborhoodsDashboard();
    _searchingController = TextEditingController();
    _profileModel = SharedPreferencesService.getProfile();
  }

  @override
  void dispose() {
    _searchingController.dispose();
    _delay?.cancel();
    super.dispose();
  }

  void _showOptions(
    ResidentialNeighborhoodModel neighborhood,
    AppLocalizations locale,
  ) {
    context.showBottomSheet(
      NeighborhoodOptionsSheet(
        neighborhood: neighborhood,
        cubit: _residentialNeighborhoodsCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final int crossAxisCount = context.screenSize.width > 600 ? 3 : 2;

    return BlocListener<
      ResidentialNeighborhoodsCubit,
      ResidentialNeighborhoodsState
    >(
      listener: (context, state) {
        if (state is WaitingForUpdateOrAddResidentialNeighborhood) {
          context.showLoadingDialog();
        } else if (state is ResidentialNeighborhoodAddedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.pop(context);
        } else if (state is ResidentialNeighborhoodDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is ResidentialNeighborhoodsFailure ||
            state is FailureForUpdateOrAddResidentialNeighborhood) {
          Navigator.of(context, rootNavigator: true).pop();
          final errorMsg = state is ResidentialNeighborhoodsFailure
              ? state.errorMessage
              : (state as FailureForUpdateOrAddResidentialNeighborhood)
                    .errorMessage;
          context.showErrorSnackBar(errorMsg);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header & Search Section
              _buildHeaderSection(context, locale),

              // 2. Main Content (Stats & Grid)
              Expanded(child: _buildContentBody(crossAxisCount, locale)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_profileModel?.role == AppRole.Admin.name)
            SmallButton(
              text: locale.add,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoute.addResidentialNeighborhood,
                  arguments: BlocProvider.of<ResidentialNeighborhoodsCubit>(
                    context,
                  ),
                );
                // .then((_) {
                //   _residentialNeighborhoodsCubit
                //       .getResidentialNeighborhoodsDashboard(
                //         search: _searchingController.text.trim(),
                //       );
                // });
              },
            ),
          if (_profileModel?.role == AppRole.Admin.name)
            const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: locale.lookingNeighborhood,
              bachgroundColor: AppColor.gray2,
              suffixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _residentialNeighborhoodsCubit.filterNeighborhoods('');
                },
                icon: const Icon(Icons.close),
              ),
              prefixIcon: Icons.search,
              onChanged: (String query) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 300), () {
                  _residentialNeighborhoodsCubit.filterNeighborhoods(
                    query.trim(),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBody(int crossAxisCount, AppLocalizations locale) {
    return BlocBuilder<
      ResidentialNeighborhoodsCubit,
      ResidentialNeighborhoodsState
    >(
      buildWhen: (previous, current) =>
          current is ResidentialNeighborhoodsLoaded ||
          current is ResidentialNeighborhoodsLoading ||
          current is ResidentialNeighborhoodsFailure,
      builder: (context, state) {
        if (state is ResidentialNeighborhoodsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ResidentialNeighborhoodsFailure) {
          return OnFailureWidget(
            onRetry: () => _residentialNeighborhoodsCubit
                .getResidentialNeighborhoodsDashboard(),
          );
        } else if (state is ResidentialNeighborhoodsLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                DashboardStatsWidget(data: state.dashboardData),
                const SizedBox(height: 20),
                if (state.filteredNeighborhoods.isEmpty)
                  SizedBox(height: 200, child: Center(child: NoResultWidget()))
                else
                  StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: state.filteredNeighborhoods.map((neighborhood) {
                      return StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: NeighborhoodCardWidget(
                          neighborhood: neighborhood,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.residentialNeighborhoodUnits,
                              arguments:
                                  BlocProvider.of<
                                      ResidentialNeighborhoodsCubit
                                    >(context)
                                    ..getResidentialNeighborhoodUnits(
                                      neighborhood.neighborhoodId,
                                    ),
                            );
                          },
                          onLongPress: () {
                            if (_profileModel?.role == AppRole.Admin.name) {
                              _showOptions(neighborhood, locale);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
