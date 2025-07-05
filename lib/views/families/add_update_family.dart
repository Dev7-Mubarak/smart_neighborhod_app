import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/ResiddentialBlocks_cubit/cubit/block_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_catgory_cubit/family_catgory_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_catgory_cubit/family_catgory_state.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/models/family.dart';
import 'package:smart_negborhood_app/models/family_category.dart';
import '../../components/CustomDropdownGeneric.dart';
import '../../components/constants/app_size.dart';
import '../../components/constants/small_text.dart';
import '../../components/custom_text_input_filed.dart';
import '../../cubits/family_cubit/family_state.dart';
import '../../cubits/family_type/family_type_cubit.dart';
import '../../cubits/family_type/family_type_state.dart';
import '../../cubits/person_cubit/person_cubit.dart';
import '../../models/Person.dart';
import '../../models/family_type.dart';

class AddUpdateFamily extends StatefulWidget {
  final int blockId;
  final Family? family;

  const AddUpdateFamily({super.key, required this.blockId, this.family});

  @override
  State<AddUpdateFamily> createState() => _AddUpdateFamilyState();
}

class _AddUpdateFamilyState extends State<AddUpdateFamily> {
  final _formKey = GlobalKey<FormState>();

  FamilyCategory? selectedFamilyCategory;
  FamilyType? selectedFamilyType;
  Person? selectedFamilyHead;

  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late PersonCubit personCubit;
  late FamilyCubit familyCubit;
  late FamilyCategoryCubit familyCategoryCubit;
  late FamilyTypeCubit familyTypeCubit;
  late BlockCubit blockCubit;

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>();
    familyCubit = context.read<FamilyCubit>();
    familyCategoryCubit = context.read<FamilyCategoryCubit>();
    familyTypeCubit = context.read<FamilyTypeCubit>();
    blockCubit = context.read<BlockCubit>();

    _initializeData();
  }

  Future<void> _initializeData() async {
    await familyCategoryCubit.getFamilyCategories();
    await familyTypeCubit.getFamilyTypies();
    await personCubit.getPeople();

    if (widget.family != null) {
      _familyNameController.text = widget.family!.name;
      _locationController.text = widget.family!.location;
      _notesController.text = widget.family!.familyNotes;

      selectedFamilyCategory = familyCategoryCubit.familyCategories.firstWhere(
        (category) => category.id == widget.family!.familyCatgoryId,
        orElse: () => familyCategoryCubit.familyCategories.first,
      );

      selectedFamilyType = familyTypeCubit.familyTypes.firstWhere(
        (type) => type.id == widget.family!.familyTypeId,
        orElse: () => familyTypeCubit.familyTypes.first,
      );

      selectedFamilyHead = personCubit.people.firstWhere(
        (person) => person.id == widget.family!.familyHeadId,
        orElse: () => personCubit.people.first,
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Family _buildFamilyPayload() {
    return Family(
      id: widget.family?.id ?? 0,
      name: _familyNameController.text,
      location: _locationController.text,
      familyNotes: _notesController.text,
      familyCatgoryId: selectedFamilyCategory?.id ?? 0,
      familyTypeId: selectedFamilyType?.id ?? 0,
      blockId: widget.blockId,
      familyHeadId: selectedFamilyHead?.id ?? 0,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final family = _buildFamilyPayload();
      final future = widget.family == null
          ? familyCubit.addNewFamily(family)
          : familyCubit.updateFamily(family);
      future.then((_) => blockCubit.getBlockDetailes(widget.blockId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FamilyCubit, FamilyState>(
          listener: (context, state) {
            if (state is FamilyAddedSuccessfully ||
                state is FamilyUpdatedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text((state as dynamic).message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is FamilyFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              widget.family == null
                  ? 'إضافة أسرة جديدة'
                  : 'تحديث بيانات الأسرة',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: AppColor.gray,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SmallText(text: 'اسم الأسرة'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: _familyNameController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'يرجى إدخال اسم الأسرة'
                            : null,
                      ),
                      const SizedBox(height: 30),
                      const SmallText(text: 'رب الأسرة'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<PersonCubit, PersonState>(
                        builder: (context, state) {
                          if (state is PersonLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is PersonLoaded) {
                            return DropdownSearch<Person>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: "ابحث عن رب الأسرة...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                itemBuilder: (context, person, isSelected) =>
                                    ListTile(
                                      title: Text(
                                        person.fullName,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      selected: isSelected,
                                    ),
                              ),
                              items: state.people,
                              selectedItem: selectedFamilyHead,
                              itemAsString: (p) => p.fullName,
                              onChanged: (value) =>
                                  familyCubit.changeSelectedFamilyHaed(value),
                              validator: (value) => value == null
                                  ? 'يرجى اختيار رب الأسرة'
                                  : null,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "أختر رب الأسرة",
                                  hintText: "أختر رب الأسرة",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Text("فشل تحميل الأشخاص");
                          }
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),

                      /// Family Category
                      const SmallText(text: 'تصنيف الأسرة'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<FamilyCategoryCubit, FamilyCategoryState>(
                        builder: (context, state) {
                          if (state is FamilyCategoryLoaded) {
                            return CustomDropdown<FamilyCategory>(
                              items: state.familyCategories,
                              selectedValue: selectedFamilyCategory,
                              itemLabel: (item) => item.name,
                              onChanged: (value) => familyCubit
                                  .changeSelectedFamilyCategory(value),
                              text: 'اختيار تصنيف الأسرة',
                              validator: (value) => value == null
                                  ? 'يرجى اختيار تصنيف الأسرة'
                                  : null,
                            );
                          } else if (state is FamilyCategoryLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Text("فشل تحميل التصنيفات");
                          }
                        },
                      ),
                      const SizedBox(height: AppSize.spasingBetweenInputBloc),

                      /// Family Type
                      const SmallText(text: 'نوع الأسرة'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      BlocBuilder<FamilyTypeCubit, FamilyTypeState>(
                        builder: (context, state) {
                          if (state is FamilyTypeLoaded) {
                            return CustomDropdown<FamilyType>(
                              items: state.familyTypes,
                              selectedValue: selectedFamilyType,
                              itemLabel: (item) => item.name,
                              onChanged: (value) =>
                                  familyCubit.changeSelectedFamilyType(value),
                              text: 'اختيار نوع الأسرة',
                              validator: (value) => value == null
                                  ? 'يرجى اختيار نوع الأسرة'
                                  : null,
                            );
                          } else if (state is FamilyTypeLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Text("فشل تحميل أنواع الأسرة");
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Location
                      const SmallText(text: 'الموقع'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: _locationController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'يرجى إدخال الموقع'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      /// Notes
                      const SmallText(text: 'ملاحظات'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(controller: _notesController),
                      const SizedBox(height: 25),

                      /// Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmallButton(
                            text: 'إلغاء',
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 10),
                          SmallButton(
                            text: widget.family == null ? 'إضافة' : 'تحديث',
                            onPressed: _submitForm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
