import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
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
  const AddNewFamily({super.key, required this.blockId});
  @override
  State<AddNewFamily> createState() => _AddNewFamilyState();
}

class _AddNewFamilyState extends State<AddNewFamily> {
  final _formKey = GlobalKey<FormState>(); // Add this line
  int? _blockId;
  FamilyCategory? selectedFamilyCategory;
  int? _familyTypeId;
  int? _personId;
  Person? selectedFamilyHead;
  late PersonCubit personCubit;
  late FamilyCubit familyCubit;
  late FamilyCategoryCubit familyCategoryCubit;
  late FamilyTypeCubit familyTypeCubit;

  bool isCall = false;
  bool isWhatsApp = false;
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    personCubit = context.read<PersonCubit>()..getPeople();
    familyCubit = context.read<FamilyCubit>();
    familyCategoryCubit = context.read<FamilyCategoryCubit>()
      ..getFamilyCategories();
    familyTypeCubit = context.read<FamilyTypeCubit>()..getFamilyTypies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _blockId = widget.blockId;
    return BlocListener<FamilyCubit, FamilyState>(
      listener: (context, state) {
        if (state is FamilyAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Center(
            child: Text(
              'إضافة أسرة جديدة',
              style: TextStyle(
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
            // <-- Wrap with Form
            key: _formKey, // <-- Assign key
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
                      const SizedBox(height: 20),
                      const SmallText(text: 'اسم الأسرة'),
                      const SizedBox(
                        height: AppSize.spasingBetweenInputsAndLabale,
                      ),
                      CustomTextFormField(
                        controller: _familyNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الاسم الاول مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      const SmallText(text: 'رب الأسرة'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          BlocBuilder<PersonCubit, PersonState>(
                            builder: (context, state) {
                              if (state is PersonLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is PersonLoaded) {
                                if (state.people.isEmpty) {
                                  return const Center(
                                    child: Text('لا يوجد أشخاص متاحين'),
                                  );
                                }

                                if (selectedFamilyHead == null &&
                                    state.people.isNotEmpty) {
                                  selectedFamilyHead = state.people.first;
                                }

                                return DropdownSearch<Person>(
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: "ابحث عن مدير...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    menuProps: MenuProps(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    itemBuilder: (context, person, isSelected) {
                                      return ListTile(
                                        title: Text(
                                          person.fullName,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        selected: isSelected,
                                      );
                                    },
                                    fit: FlexFit.loose,
                                  ),
                                  items: state.people,
                                  itemAsString: (Person? u) =>
                                      u?.fullName ?? '',
                                  onChanged: (Person? data) {
                                    selectedFamilyHead = data;
                                    familyCubit.changeSelectedFamilyHaed(data);
                                  },
                                  selectedItem: selectedFamilyHead,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              labelText: "أختر رب الأسرة ",
                                              hintText: "أختر رب الأسرة",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                            ),
                                      ),
                                  validator: (Person? item) {
                                    if (item == null) {
                                      return "الرجاء اختيار رب الأسرة";
                                    }
                                    return null;
                                  },
                                );
                              }

                              return Container();
                            },
                          ),
                          const SizedBox(
                            height: AppSize.spasingBetweenInputBloc,
                          ),
                          const SmallText(text: 'تصنيف الأسرة'),
                          const SizedBox(
                            height: AppSize.spasingBetweenInputsAndLabale,
                          ),
                          BlocBuilder<FamilyCategoryCubit, FamilyCategoryState>(
                            builder: (context, state) {
                              List<FamilyCategory> categories = [];
                              if (state is FamilyCategoryLoaded) {
                                categories = state.familyCategories;
                                selectedFamilyCategory = categories.isNotEmpty
                                    ? categories.first
                                    : null;
                              }

                              return CustomDropdown<FamilyCategory>(
                                items: categories,
                                selectedValue: selectedFamilyCategory,
                                itemLabel: (category) => category.name,
                                onChanged: (newValue) {
                                  selectedFamilyCategory = newValue;
                                  familyCubit.changeSelectedFamilyCategory(
                                    newValue,
                                  );
                                },
                                text: 'اختيار تصنيف الأسرة',
                                validator: (value) {
                                  if (value == null) {
                                    return 'يرجى اختيار تصنيف الأسرة';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),

                          const SizedBox(
                            height: AppSize.spasingBetweenInputBloc,
                          ),
                          const SmallText(text: 'نوع الأسرة'),
                          const SizedBox(
                            height: AppSize.spasingBetweenInputsAndLabale,
                          ),
                          BlocBuilder<FamilyTypeCubit, FamilyTypeState>(
                            builder: (context, state) {
                              List<FamilyType> familyTypes = [];
                              if (state is FamilyTypeLoaded) {
                                familyTypes = state.familyTypes;
                                _familyTypeId = familyTypes.isNotEmpty
                                    ? familyTypes.first.id
                                    : null;
                              }

                              return CustomDropdown<FamilyType>(
                                items: familyTypes,
                                selectedValue: familyTypes.isNotEmpty
                                    ? familyTypes.first
                                    : null,
                                itemLabel: (type) => type.name,
                                onChanged: (newValue) {
                                  _familyTypeId = newValue?.id;
                                },
                                text: 'اختيار نوع الأسرة',
                                validator: (value) {
                                  if (value == null) {
                                    return 'يرجى اختيار نوع الأسرة';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const SmallText(text: 'الموقع'),
                          const SizedBox(
                            height: AppSize.spasingBetweenInputsAndLabale,
                          ),
                          CustomTextFormField(
                            controller: _locationController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الاسم الاول مطلوب';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const SmallText(text: 'ملاحظات'),
                          const SizedBox(
                            height: AppSize.spasingBetweenInputsAndLabale,
                          ),
                          CustomTextFormField(controller: _notesController),

                          const SizedBox(height: 25),
                          // أزرار الإضافة والإلغاء
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SmallButton(
                                text: 'إلغاء',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 10),
                              SmallButton(
                                text: 'إضافة',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Family family = Family(
                                      name: _familyNameController.text,
                                      location: _locationController.text,
                                      familyNotes: _notesController.text,
                                      familyCatgoryId:
                                          selectedFamilyCategory?.id ?? 0,
                                      familyTypeId: _familyTypeId ?? 0,
                                      blockId: _blockId!,
                                      familyHeadId: selectedFamilyHead?.id ?? 0,
                                    );
                                    familyCubit.addNewFamily(family);
                                  }
                                },
                              ),
                            ],
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
