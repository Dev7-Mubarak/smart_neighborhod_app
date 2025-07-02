import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_negborhood_app/components/CustomDropdown.dart';
import 'package:smart_negborhood_app/components/constants/app_color.dart';
import 'package:smart_negborhood_app/components/constants/app_size.dart';
import 'package:smart_negborhood_app/components/constants/small_text.dart';
import 'package:smart_negborhood_app/components/custom_text_input_filed.dart';
import 'package:smart_negborhood_app/components/smallButton.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_cubit.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/models/enums/blood_type.dart';
import 'package:smart_negborhood_app/models/enums/gender.dart';
import 'package:smart_negborhood_app/models/enums/identity_type.dart';
import 'package:smart_negborhood_app/models/enums/marital_status.dart';
import 'package:smart_negborhood_app/models/enums/occupation_status.dart';

class AddFamilyMember extends StatefulWidget {
  final int familyId;
  const AddFamilyMember({super.key, required this.familyId});

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final _formKey = GlobalKey<FormState>();
  
  late FamilyCubit familyCubit;
  
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _thirdNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  // Form state variables
  String? selectedGender;
  String? selectedBloodType;
  String? selectedIdentityType;
  String? selectedMaritalStatus;
  String? selectedOccupationStatus;
  DateTime? selectedDate;
  bool isWhatsapp = false;
  bool isCall = false;

  @override
  void initState() {
    super.initState();
    familyCubit = context.read<FamilyCubit>();
    
    // Set default values
    selectedGender = GenderExtension.getDisplayNames().first;
    selectedBloodType = BloodType.values.first.toString().split('.').last;
    selectedIdentityType = IdentityType.values.first.toString().split('.').last;
    selectedMaritalStatus = MaritalStatus.values.first.toString().split('.').last;
    selectedOccupationStatus = OccupationStatus.values.first.toString().split('.').last;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _identityNumberController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilyCubit, FamilyState>(
      listener: (context, state) {
        if (state is FamilyMemberAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
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
              'إضافة فرد جديد',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Name
                const SmallText(text: 'الاسم الأول'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _firstNameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال الاسم الأول'
                      : null,
                ),
                const SizedBox(height: 20),

                // Second Name
                const SmallText(text: 'الاسم الثاني'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _secondNameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال الاسم الثاني'
                      : null,
                ),
                const SizedBox(height: 20),

                // Third Name
                const SmallText(text: 'الاسم الثالث'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _thirdNameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال الاسم الثالث'
                      : null,
                ),
                const SizedBox(height: 20),

                // Last Name
                const SmallText(text: 'اسم العائلة'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _lastNameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال اسم العائلة'
                      : null,
                ),
                const SizedBox(height: 20),

                // Phone Number
                const SmallText(text: 'رقم الجوال'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال رقم الجوال'
                      : null,
                ),
                const SizedBox(height: 20),

                // Email
                const SmallText(text: 'البريد الإلكتروني (اختياري)'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Identity Number
                const SmallText(text: 'رقم الهوية'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _identityNumberController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى إدخال رقم الهوية'
                      : null,
                ),
                const SizedBox(height: 20),

                // Birth Date
                const SmallText(text: 'تاريخ الميلاد'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) => value == null || value.isEmpty
                      ? 'يرجى اختيار تاريخ الميلاد'
                      : null,
                  suffixIcon: Icons.calendar_today,
                ),
                const SizedBox(height: 20),

                // Gender
                const SmallText(text: 'الجنس'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomDropdown<String>(
                  items: GenderExtension.getDisplayNames(),
                  selectedValue: selectedGender,
                  onChanged: (value) => setState(() => selectedGender = value),
                  validator: (value) => value == null ? 'يرجى اختيار الجنس' : null,
                ),
                const SizedBox(height: 20),

                // Blood Type
                const SmallText(text: 'فصيلة الدم'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomDropdown<String>(
                  items: BloodType.values.map((e) => e.toString().split('.').last).toList(),
                  selectedValue: selectedBloodType,
                  onChanged: (value) => setState(() => selectedBloodType = value),
                  validator: (value) => value == null ? 'يرجى اختيار فصيلة الدم' : null,
                ),
                const SizedBox(height: 20),

                // Identity Type
                const SmallText(text: 'نوع الهوية'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomDropdown<String>(
                  items: IdentityType.values.map((e) => e.toString().split('.').last).toList(),
                  selectedValue: selectedIdentityType,
                  onChanged: (value) => setState(() => selectedIdentityType = value),
                  validator: (value) => value == null ? 'يرجى اختيار نوع الهوية' : null,
                ),
                const SizedBox(height: 20),

                // Marital Status
                const SmallText(text: 'الحالة الاجتماعية'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomDropdown<String>(
                  items: MaritalStatus.values.map((e) => e.toString().split('.').last).toList(),
                  selectedValue: selectedMaritalStatus,
                  onChanged: (value) => setState(() => selectedMaritalStatus = value),
                  validator: (value) => value == null ? 'يرجى اختيار الحالة الاجتماعية' : null,
                ),
                const SizedBox(height: 20),

                // Occupation Status
                const SmallText(text: 'الحالة المهنية'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomDropdown<String>(
                  items: OccupationStatus.values.map((e) => e.toString().split('.').last).toList(),
                  selectedValue: selectedOccupationStatus,
                  onChanged: (value) => setState(() => selectedOccupationStatus = value),
                  validator: (value) => value == null ? 'يرجى اختيار الحالة المهنية' : null,
                ),
                const SizedBox(height: 20),

                // Job
                const SmallText(text: 'المهنة (اختياري)'),
                const SizedBox(height: AppSize.spasingBetweenInputsAndLabale),
                CustomTextFormField(
                  controller: _jobController,
                ),
                const SizedBox(height: 20),

                // Contact preferences
                Row(
                  children: [
                    Checkbox(
                      value: isWhatsapp,
                      onChanged: (value) => setState(() => isWhatsapp = value ?? false),
                    ),
                    const Text('واتساب'),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: isCall,
                      onChanged: (value) => setState(() => isCall = value ?? false),
                    ),
                    const Text('مكالمات'),
                  ],
                ),
                const SizedBox(height: 30),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallButton(
                      text: 'إلغاء',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    SmallButton(
                      text: 'إضافة',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          familyCubit.addFamilyMember(
                            familyId: widget.familyId,
                            firstName: _firstNameController.text,
                            secondName: _secondNameController.text,
                            thirdName: _thirdNameController.text,
                            lastName: _lastNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            identityNumber: _identityNumberController.text,
                            email: _emailController.text.isEmpty ? null : _emailController.text,
                            dateOfBirth: selectedDate!,
                            gender: GenderExtension.fromDisplayName(selectedGender!).toString().split('.').last,
                            bloodType: selectedBloodType!,
                            identityType: selectedIdentityType!,
                            maritalStatus: selectedMaritalStatus!,
                            occupationStatus: selectedOccupationStatus!,
                            isWhatsapp: isWhatsapp,
                            isCall: isCall,
                            job: _jobController.text.isEmpty ? null : _jobController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}