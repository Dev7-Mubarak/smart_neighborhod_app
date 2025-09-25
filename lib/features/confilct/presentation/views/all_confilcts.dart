import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/core/common/widgets/no_result_widget.dart';
import 'package:smart_negborhood_app/core/common/widgets/on_failure_widget.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import 'package:smart_negborhood_app/core/constants/app_image.dart';
import 'package:smart_negborhood_app/core/constants/app_route.dart';
import 'package:smart_negborhood_app/core/common/widgets/searcable_text_input_filed.dart';
import 'package:smart_negborhood_app/core/extensions/context_extension.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_cubit.dart';
import 'package:smart_negborhood_app/features/confilct/cubits/conflict/conflict_state.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import '../../../../core/constants/app_size.dart';
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
    return BlocListener<ConflictCubit, ConflictState>(
      listener: (context, state) {
        if (state is ConfllictDeletedSuccessfully) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
        } else if (state is DeleteConflictFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is WiateDeleteConflict) {
          context.showLoadingDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.white,
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
          padding: const EdgeInsets.all(AppSize.paddingOfPage),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildToBar(context),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<ConflictCubit, ConflictState>(
                  buildWhen: (previousState, currentState) {
                    return currentState is ConflictLoading ||
                        currentState is ConflictLoaded ||
                        currentState is ConflictFailure;
                  },
                  builder: (context, state) {
                    if (state is ConflictLoaded) {
                      _conflictListDisplay = state.filteredConflicts;
                      if (_conflictListDisplay.isEmpty) {
                        return NoResultWidget();
                      }
                      return SingleChildScrollView(
                        child: StaggeredGrid.count(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: _conflictListDisplay.map((e) {
                            return StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: InkWell(
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
                                onLongPress: () => _showOptions(context, e),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0x80636AE8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: AppImage.load,
                                            image: e.imageUrl,
                                            fit: BoxFit.scaleDown,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 60,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        e.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'الطرف الأول: ${e.firstPartyName}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'الطرف الثاني: ${e.secondPartyName}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        e.sessionDate != null
                                            ? 'تاريخ الجلسة: ${DateFormat('yyyy-MM-dd').format(e.sessionDate!)}'
                                            : 'تاريخ غير محدد',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is ConflictLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('جاري تحميل الخلافات...'),
                          ],
                        ),
                      );
                    } else if (state is ConflictFailure) {
                      return OnFailureWidget(
                        onRetry: () => _conflictCubit.getAllConflicts(),
                      );
                    } else {
                      return Center(child: Text("حدث خطأ غير معروف"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SmallButton(
          text: 'إضافة إتفاقية',
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoute.addUpdateConflict,
              arguments: BlocProvider.of<ConflictCubit>(context),
            ).then((_) {
              _conflictCubit.getAllConflicts(
                search: _searchingController.text.trim(),
              );
              _conflictCubit.resetInputs();
            });
          },
        ),
        const SizedBox(width: AppSize.spasingBetweenInputsAndLabale),
        Expanded(
          child: SearchableTextFormField(
            controller: _searchingController,
            hintText: 'ابحث عن اسم الفريق',
            bachgroundColor: AppColor.gray2,
            prefixIcon: Icons.search,
            suffixIcon: IconButton(
              onPressed: () {
                _searchingController.clear();
                _conflictCubit.filterTeams('');
              },
              icon: const Icon(Icons.close),
            ),
            onChanged: (String query) {
              _delay?.cancel();
              _delay = Timer(const Duration(milliseconds: 300), () {
                _conflictCubit.filterTeams(query.trim());
              });
            },
          ),
        ),
      ],
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
                  _conflictCubit.resetInputs();
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
