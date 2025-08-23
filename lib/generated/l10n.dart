// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `الحارة الذكية`
  String get appTitle {
    return Intl.message(
      'الحارة الذكية',
      name: 'appTitle',
      desc: 'The title of the application',
      locale: localeName,
    );
  }

  /// `إسم المستخدم`
  String get username {
    return Intl.message(
      'إسم المستخدم',
      name: 'username',
      desc: 'Username label',
      locale: localeName,
    );
  }

  /// `:إسم المستخدم`
  String get usernameLabel {
    return Intl.message(
      ':إسم المستخدم',
      name: 'usernameLabel',
      desc: 'Username label with colon',
      locale: localeName,
    );
  }

  /// `كلمة المرور`
  String get password {
    return Intl.message(
      'كلمة المرور',
      name: 'password',
      desc: 'Password label',
      locale: localeName,
    );
  }

  /// `:كلمة المرور`
  String get passwordLabel {
    return Intl.message(
      ':كلمة المرور',
      name: 'passwordLabel',
      desc: 'Password label with colon',
      locale: localeName,
    );
  }

  /// `قم بإدخال اسم المستخدم`
  String get enterUsername {
    return Intl.message(
      'قم بإدخال اسم المستخدم',
      name: 'enterUsername',
      desc: 'Enter username hint',
      locale: localeName,
    );
  }

  /// `قم بإدخال كلمة المرور`
  String get enterPassword {
    return Intl.message(
      'قم بإدخال كلمة المرور',
      name: 'enterPassword',
      desc: 'Enter password hint',
      locale: localeName,
    );
  }

  /// `الرجاء إدخال إسم المستخدم`
  String get pleaseEnterUsername {
    return Intl.message(
      'الرجاء إدخال إسم المستخدم',
      name: 'pleaseEnterUsername',
      desc: 'Please enter username validation',
      locale: localeName,
    );
  }

  /// `الرجاء إدخال كلمة المرور`
  String get pleaseEnterPassword {
    return Intl.message(
      'الرجاء إدخال كلمة المرور',
      name: 'pleaseEnterPassword',
      desc: 'Please enter password validation',
      locale: localeName,
    );
  }

  /// `هل نسيت كلمة السر؟`
  String get forgotPassword {
    return Intl.message(
      'هل نسيت كلمة السر؟',
      name: 'forgotPassword',
      desc: 'Forgot password text',
      locale: localeName,
    );
  }

  /// `تسجيل الدخول`
  String get login {
    return Intl.message(
      'تسجيل الدخول',
      name: 'login',
      desc: 'Login button text',
      locale: localeName,
    );
  }

  /// `اسم الأسرة`
  String get familyName {
    return Intl.message(
      'اسم الأسرة',
      name: 'familyName',
      desc: 'Family name label',
      locale: localeName,
    );
  }

  /// `يرجى إدخال اسم الأسرة`
  String get pleaseEnterFamilyName {
    return Intl.message(
      'يرجى إدخال اسم الأسرة',
      name: 'pleaseEnterFamilyName',
      desc: 'Please enter family name validation',
      locale: localeName,
    );
  }

  /// `رب الأسرة`
  String get familyHead {
    return Intl.message(
      'رب الأسرة',
      name: 'familyHead',
      desc: 'Family head label',
      locale: localeName,
    );
  }

  /// `ابحث عن رب الأسرة...`
  String get searchFamilyHead {
    return Intl.message(
      'ابحث عن رب الأسرة...',
      name: 'searchFamilyHead',
      desc: 'Search for family head hint',
      locale: localeName,
    );
  }

  /// `أختر رب الأسرة`
  String get chooseFamilyHead {
    return Intl.message(
      'أختر رب الأسرة',
      name: 'chooseFamilyHead',
      desc: 'Choose family head label',
      locale: localeName,
    );
  }

  /// `يرجى اختيار رب الأسرة`
  String get pleaseChooseFamilyHead {
    return Intl.message(
      'يرجى اختيار رب الأسرة',
      name: 'pleaseChooseFamilyHead',
      desc: 'Please choose family head validation',
      locale: localeName,
    );
  }

  /// `فشل تحميل الأشخاص`
  String get failedToLoadPeople {
    return Intl.message(
      'فشل تحميل الأشخاص',
      name: 'failedToLoadPeople',
      desc: 'Failed to load people error',
      locale: localeName,
    );
  }

  /// `تصنيف الأسرة`
  String get familyCategory {
    return Intl.message(
      'تصنيف الأسرة',
      name: 'familyCategory',
      desc: 'Family category label',
      locale: localeName,
    );
  }

  /// `اختيار تصنيف الأسرة`
  String get chooseFamilyCategory {
    return Intl.message(
      'اختيار تصنيف الأسرة',
      name: 'chooseFamilyCategory',
      desc: 'Choose family category label',
      locale: localeName,
    );
  }

  /// `يرجى اختيار تصنيف الأسرة`
  String get pleaseChooseFamilyCategory {
    return Intl.message(
      'يرجى اختيار تصنيف الأسرة',
      name: 'pleaseChooseFamilyCategory',
      desc: 'Please choose family category validation',
      locale: localeName,
    );
  }

  /// `فشل تحميل التصنيفات`
  String get failedToLoadCategories {
    return Intl.message(
      'فشل تحميل التصنيفات',
      name: 'failedToLoadCategories',
      desc: 'Failed to load categories error',
      locale: localeName,
    );
  }

  /// `الموقع`
  String get location {
    return Intl.message(
      'الموقع',
      name: 'location',
      desc: 'Location label',
      locale: localeName,
    );
  }

  /// `يرجى إدخال الموقع`
  String get pleaseEnterLocation {
    return Intl.message(
      'يرجى إدخال الموقع',
      name: 'pleaseEnterLocation',
      desc: 'Please enter location validation',
      locale: localeName,
    );
  }

  /// `ملاحظات`
  String get notes {
    return Intl.message(
      'ملاحظات',
      name: 'notes',
      desc: 'Notes label',
      locale: localeName,
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message(
      'إلغاء',
      name: 'cancel',
      desc: 'Cancel button',
      locale: localeName,
    );
  }

  /// `إضافة`
  String get add {
    return Intl.message(
      'إضافة',
      name: 'add',
      desc: 'Add button',
      locale: localeName,
    );
  }

  /// `تحديث`
  String get update {
    return Intl.message(
      'تحديث',
      name: 'update',
      desc: 'Update button',
      locale: localeName,
    );
  }

  /// `الاسم الثالث`
  String get thirdName {
    return Intl.message(
      'الاسم الثالث',
      name: 'thirdName',
      desc: 'Third name label',
      locale: localeName,
    );
  }

  /// `الاسم الثالث مطلوب`
  String get thirdNameRequired {
    return Intl.message(
      'الاسم الثالث مطلوب',
      name: 'thirdNameRequired',
      desc: 'Third name required validation',
      locale: localeName,
    );
  }

  /// `الاسم الربع`
  String get fourthName {
    return Intl.message(
      'الاسم الربع',
      name: 'fourthName',
      desc: 'Fourth name label',
      locale: localeName,
    );
  }

  /// `الاسم الرابع مطلوب`
  String get fourthNameRequired {
    return Intl.message(
      'الاسم الرابع مطلوب',
      name: 'fourthNameRequired',
      desc: 'Fourth name required validation',
      locale: localeName,
    );
  }

  /// `رقم الهوية`
  String get identityNumber {
    return Intl.message(
      'رقم الهوية',
      name: 'identityNumber',
      desc: 'Identity number label',
      locale: localeName,
    );
  }

  /// `نوع الهوية`
  String get identityType {
    return Intl.message(
      'نوع الهوية',
      name: 'identityType',
      desc: 'Identity type label',
      locale: localeName,
    );
  }

  /// `اختيار نوع الهوية`
  String get chooseIdentityType {
    return Intl.message(
      'اختيار نوع الهوية',
      name: 'chooseIdentityType',
      desc: 'Choose identity type label',
      locale: localeName,
    );
  }

  /// `يرجى اختيار نوع الهوية`
  String get pleaseChooseIdentityType {
    return Intl.message(
      'يرجى اختيار نوع الهوية',
      name: 'pleaseChooseIdentityType',
      desc: 'Please choose identity type validation',
      locale: localeName,
    );
  }

  /// `رقم الجوال`
  String get phoneNumber {
    return Intl.message(
      'رقم الجوال',
      name: 'phoneNumber',
      desc: 'Phone number label',
      locale: localeName,
    );
  }

  /// `رقم التواصل`
  String get contactNumber {
    return Intl.message(
      'رقم التواصل',
      name: 'contactNumber',
      desc: 'Contact number label',
      locale: localeName,
    );
  }

  /// `الجنس`
  String get gender {
    return Intl.message(
      'الجنس',
      name: 'gender',
      desc: 'Gender label',
      locale: localeName,
    );
  }

  /// `ذكر`
  String get male {
    return Intl.message(
      'ذكر',
      name: 'male',
      desc: 'Male gender',
      locale: localeName,
    );
  }

  /// `أنثى`
  String get female {
    return Intl.message(
      'أنثى',
      name: 'female',
      desc: 'Female gender',
      locale: localeName,
    );
  }

  /// `تاريخ الميلاد`
  String get birthDate {
    return Intl.message(
      'تاريخ الميلاد',
      name: 'birthDate',
      desc: 'Birth date label',
      locale: localeName,
    );
  }

  /// `تاريخ الميلاد مطلوب`
  String get birthDateRequired {
    return Intl.message(
      'تاريخ الميلاد مطلوب',
      name: 'birthDateRequired',
      desc: 'Birth date required validation',
      locale: localeName,
    );
  }

  /// `فصيلة الدم`
  String get bloodType {
    return Intl.message(
      'فصيلة الدم',
      name: 'bloodType',
      desc: 'Blood type label',
      locale: localeName,
    );
  }

  /// `اختبار فصيلة الدم`
  String get chooseBloodType {
    return Intl.message(
      'اختبار فصيلة الدم',
      name: 'chooseBloodType',
      desc: 'Choose blood type label',
      locale: localeName,
    );
  }

  /// `يرجى اختيار فصيلة الدم`
  String get pleaseChooseBloodType {
    return Intl.message(
      'يرجى اختيار فصيلة الدم',
      name: 'pleaseChooseBloodType',
      desc: 'Please choose blood type validation',
      locale: localeName,
    );
  }

  /// `الحالة الاجتماعية`
  String get maritalStatus {
    return Intl.message(
      'الحالة الاجتماعية',
      name: 'maritalStatus',
      desc: 'Marital status label',
      locale: localeName,
    );
  }

  /// `المهنة`
  String get job {
    return Intl.message(
      'المهنة',
      name: 'job',
      desc: 'Job label',
      locale: localeName,
    );
  }

  /// `غير محدد`
  String get notSpecified {
    return Intl.message(
      'غير محدد',
      name: 'notSpecified',
      desc: 'Not specified text',
      locale: localeName,
    );
  }

  /// `اضغط للمزيد من التفاصيل`
  String get clickForMoreDetails {
    return Intl.message(
      'اضغط للمزيد من التفاصيل',
      name: 'clickForMoreDetails',
      desc: 'Click for more details text',
      locale: localeName,
    );
  }

  /// `الأيميل`
  String get email {
    return Intl.message(
      'الأيميل',
      name: 'email',
      desc: 'Email label',
      locale: localeName,
    );
  }

  /// `نوع الأسرة`
  String get familyType {
    return Intl.message(
      'نوع الأسرة',
      name: 'familyType',
      desc: 'Family type label',
      locale: localeName,
    );
  }

  /// `إضافة شخص جديد`
  String get addNewPerson {
    return Intl.message(
      'إضافة شخص جديد',
      name: 'addNewPerson',
      desc: 'Add new person title',
      locale: localeName,
    );
  }

  /// `تعديل بيانات الشخص`
  String get editPersonData {
    return Intl.message(
      'تعديل بيانات الشخص',
      name: 'editPersonData',
      desc: 'Edit person data title',
      locale: localeName,
    );
  }

  /// `الاسم الاول`
  String get firstName {
    return Intl.message(
      'الاسم الاول',
      name: 'firstName',
      desc: 'First name label',
      locale: localeName,
    );
  }

  /// `الاسم الاول مطلوب`
  String get firstNameRequired {
    return Intl.message(
      'الاسم الاول مطلوب',
      name: 'firstNameRequired',
      desc: 'First name required validation',
      locale: localeName,
    );
  }

  /// `الاسم الثاني`
  String get secondName {
    return Intl.message(
      'الاسم الثاني',
      name: 'secondName',
      desc: 'Second name label',
      locale: localeName,
    );
  }

  /// `الاسم الثاني مطلوب`
  String get secondNameRequired {
    return Intl.message(
      'الاسم الثاني مطلوب',
      name: 'secondNameRequired',
      desc: 'Second name required validation',
      locale: localeName,
    );
  }

  /// `رقم الهوية مطلوب`
  String get identityNumberRequired {
    return Intl.message(
      'رقم الهوية مطلوب',
      name: 'identityNumberRequired',
      desc: 'Identity number required validation',
      locale: localeName,
    );
  }

  String get localeName => Intl.getCurrentLocale();
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
