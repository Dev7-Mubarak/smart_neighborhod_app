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

class AddNewFamily extends StatefulWidget {
  final int blockId;
  final Family? family;
  const AddNewFamily({super.key, required this.blockId, this.family});

  @override
  State<AddNewFamily> createState() => _AddNewFamilyState();
}

class _AddNewFamilyState extends State<AddNewFamily> {
  final _formKey = GlobalKey<FormState>();

  FamilyCategory? selectedFamilyCategory;
  FamilyType? selectedFamilyType;
  Person? selectedFamilyHead;

  late PersonCubit personCubit;
  late FamilyCubit familyCubit;
  late FamilyCategoryCubit familyCategoryCubit;
  late FamilyTypeCubit familyTypeCubit;
  late BlockCubit blockCubit;

  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    personCubit = context.read<PersonCubit>()..getPeople();
    familyCubit = context.read<FamilyCubit>();
    familyCategoryCubit = context.read<FamilyCategoryCubit>()
      ..getFamilyCategories();
    familyTypeCubit = context.read<FamilyTypeCubit>()..getFamilyTypies();
    blockCubit = context.read<BlockCubit>();
    
    // Pre-populate form fields if editing
    if (widget.family != null) {
      _familyNameController.text = widget.family!.name;
      _locationController.text = widget.family!.location;
      _notesController.text = widget.family!.familyNotes;
    }
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FamilyCubit, FamilyState>(
          listener: (context, state) {
            if (state is FamilyAddedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is FamilyUpdatedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh the family details if we're editing
              if (widget.family != null) {
                familyCubit.getFamilyDetilesById(widget.family!.id);
              }
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
        BlocListener<PersonCubit, PersonState>(
          listener: (context, state) {
            if (state is PersonLoaded && selectedFamilyHead == null) {
              if (widget.family != null) {
                // When editing, if we have a family head ID, use it
                if (widget.family!.familyHeadId > 0) {
                  final familyHead = state.people.firstWhere(
                    (person) => person.id == widget.family!.familyHeadId,
                    orElse: () => state.people.first,
                  );
                  setState(() => selectedFamilyHead = familyHead);
                } else if (state.people.isNotEmpty) {
                  // If no family head ID, default to first person
                  setState(() => selectedFamilyHead = state.people.first);
                }
              } else if (state.people.isNotEmpty) {
                setState(() => selectedFamilyHead = state.people.first);
              }
            }
          },
        ),
        BlocListener<FamilyCategoryCubit, FamilyCategoryState>(
          listener: (context, state) {
            if (state is FamilyCategoryLoaded && selectedFamilyCategory == null) {
              if (widget.family != null) {
                // Find the family category by ID when editing
                final familyCategory = state.familyCategories.firstWhere(
                  (category) => category.id == widget.family!.familyCatgoryId,
                  orElse: () => state.familyCategories.first,
                );
                setState(() => selectedFamilyCategory = familyCategory);
              } else if (state.familyCategories.isNotEmpty) {
                setState(() => selectedFamilyCategory = state.familyCategories.first);
              }
            }
          },
        ),
        BlocListener<FamilyTypeCubit, FamilyTypeState>(
          listener: (context, state) {
            if (state is FamilyTypeLoaded && selectedFamilyType == null) {
              if (widget.family != null) {
                // Find the family type by ID when editing
                final familyType = state.familyTypes.firstWhere(
                  (type) => type.id == widget.family!.familyTypeId,
                  orElse: () => state.familyTypes.first,
                );
                setState(() => selectedFamilyType = familyType);
              } else if (state.familyTypes.isNotEmpty) {
                setState(() => selectedFamilyType = state.familyTypes.first);
              }
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
              widget.family == null ? 'إضافة أسرة' : 'تعديل معلومات الأسرة',
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
                              onChanged: (value) {
                                selectedFamilyHead = value;
                                // setState(() => selectedFamilyHead = value);
                                familyCubit.changeSelectedFamilyHaed(value);
                              },
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
                              onChanged: (value) {
                                setState(() => selectedFamilyCategory = value);
                                familyCubit.changeSelectedFamilyCategory(value);
                              },
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
                              onChanged: (value) {
                                setState(() => selectedFamilyType = value);
                                familyCubit.changeSelectedFamilyType(value);
                              },
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
                            text: widget.family == null ? 'إضافة' : 'تعديل',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (widget.family == null) {
                                  // Add new family
                                  final newFamily = Family(
                                    name: _familyNameController.text,
                                    location: _locationController.text,
                                    familyNotes: _notesController.text,
                                    familyCatgoryId:
                                        selectedFamilyCategory?.id ?? 0,
                                    familyTypeId: selectedFamilyType?.id ?? 0,
                                    blockId: widget.blockId,
                                    familyHeadId: selectedFamilyHead?.id ?? 0,
                                  );
                                  familyCubit.addNewFamily(newFamily).then((_) {
                                    blockCubit.getBlockDetailes(widget.blockId);
                                  });
                                } else {
                                  // Update existing family
                                  final updatedFamily = Family(
                                    name: _familyNameController.text,
                                    location: _locationController.text,
                                    familyNotes: _notesController.text,
                                    familyCatgoryId:
                                        selectedFamilyCategory?.id ?? 0,
                                    familyTypeId: selectedFamilyType?.id ?? 0,
                                    blockId: widget.blockId,
                                    familyHeadId: selectedFamilyHead?.id ?? 0,
                                  );
                                  updatedFamily.id = widget.family!.id;
                                  familyCubit.updateFamily(updatedFamily);
                                }
                              }
                            },
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
