import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_image.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/constants/small_text.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_state.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/common/widgets/custom_navigation_bar.dart';
import '../../../../core/common/widgets/smallButton.dart';

class AllConflict extends StatefulWidget {
  const AllConflict({super.key});
  @override
  State<AllConflict> createState() => _AllConflictState();
}

class _AllConflictState extends State<AllConflict> {
  List<Conflict> _conflictListDisplay = [];
  // late TeamCubit _teamsCubit;
  late ConflictCubit _conflictCubit;
  late TextEditingController _searchingController;

  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _conflictCubit = context.read<ConflictCubit>()..getAllConflicts();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'إدارة الخلافات',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildToBar(context),
              const SizedBox(height: 15),
              BlocBuilder<ConflictCubit, ConflictState>(
                builder: (context, state) {
                  if (state is ConflictLoaded) {
                    _conflictListDisplay = state.filteredConflicts;
                    if (_conflictListDisplay.isEmpty) {
                      return const Center(
                        child: Text("لا توجد خلافات لعرضها حاليًا."),
                      );
                    }
                    return GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: _conflictListDisplay
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.conflictDetiles,
                                  arguments: e,
                                ).then((_) {
                                  _conflictCubit.getAllConflicts(
                                    search: _searchingController.text.trim(),
                                  );
                                });
                              },
                              onLongPress: () {
                                _showOptions(context, e);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0x80636AE8),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: AppImage.load,
                                          image: e.imageUrl,
                                          fit: BoxFit.contain,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                                return Image.asset(
                                                  AppImage.admin,
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width: 170,
                                    //   height: 100,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(15),
                                    //     image: DecorationImage(
                                    //       image: AssetImage(AppImage.ReconciliationCouncil),
                                    //       fit: BoxFit.fill,
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: SmallText(
                                        text: e.title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: SmallText(
                                        text:
                                            'الطرف الأول: ${e.firstPartyName}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: SmallText(
                                        text:
                                            'الطرف الثاني: ${e.secondPartyName}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: SmallText(
                                        text:
                                            ' تاريخ الجلسة: ${DateFormat('yyyy-MM-dd').format(e.sessionDate!)}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  } else if (state is ConflictLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ConflictFailure) {
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _buildToBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SmallButton(
            text: 'أضافة',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.addUpdateConflict,
                arguments: BlocProvider.of<ConflictCubit>(context),
              ).then((_) {
                _conflictCubit.getAllConflicts(
                  search: _searchingController.text.trim(),
                );
              });
            },
          ),
          const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
          Expanded(
            child: SearchableTextFormField(
              controller: _searchingController,
              hintText: 'ابحث عن اسم الفريق',
              bachgroundColor: AppColor.gray2,
              prefixIcon: IconButton(
                onPressed: () {
                  _searchingController.clear();
                  _conflictCubit.filterTeams('');
                },
                icon: const Icon(Icons.close),
              ),
              suffixIcon: Icons.search,
              onChanged: (String query) {
                _delay?.cancel();
                _delay = Timer(const Duration(milliseconds: 300), () {
                  _conflictCubit.filterTeams(query.trim());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext passContext, Conflict conflict) {
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
                Navigator.pushNamed(
                  context,
                  AppRoute.addUpdateConflict,
                  arguments: BlocProvider.of<ConflictCubit>(passContext)
                    ..setConflictForUpdate(conflict),
                ).then((_) {
                  _conflictCubit.getAllConflicts(
                    search: _searchingController.text.trim(),
                  );
                });
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
                    content: const Text(
                      'هل أنت متأكد أنك تريد حذف هذه الوثيقة ',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _conflictCubit.deleteConflict(conflict.id);
                        },
                        child: const Text(
                          'حذف',
                          style: TextStyle(color: Colors.red),
                        ),
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
