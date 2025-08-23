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

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Smart Neighborhood`
  String get appTitle {
    return Intl.message(
      'Smart Neighborhood',
      name: 'appTitle',
      desc: 'The title of the application',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: 'Username label',
      args: [],
    );
  }

  /// `Username:`
  String get usernameLabel {
    return Intl.message(
      'Username:',
      name: 'usernameLabel',
      desc: 'Username label with colon',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password label',
      args: [],
    );
  }

  /// `Password:`
  String get passwordLabel {
    return Intl.message(
      'Password:',
      name: 'passwordLabel',
      desc: 'Password label with colon',
      args: [],
    );
  }

  /// `Enter username`
  String get enterUsername {
    return Intl.message(
      'Enter username',
      name: 'enterUsername',
      desc: 'Enter username hint',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: 'Enter password hint',
      args: [],
    );
  }

  /// `Please enter username`
  String get pleaseEnterUsername {
    return Intl.message(
      'Please enter username',
      name: 'pleaseEnterUsername',
      desc: 'Please enter username validation',
      args: [],
    );
  }

  /// `Please enter password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter password',
      name: 'pleaseEnterPassword',
      desc: 'Please enter password validation',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: 'Forgot password text',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Login button text',
      args: [],
    );
  }

  /// `Family Name`
  String get familyName {
    return Intl.message(
      'Family Name',
      name: 'familyName',
      desc: 'Family name label',
      args: [],
    );
  }

  /// `Please enter family name`
  String get pleaseEnterFamilyName {
    return Intl.message(
      'Please enter family name',
      name: 'pleaseEnterFamilyName',
      desc: 'Please enter family name validation',
      args: [],
    );
  }

  /// `Family Head`
  String get familyHead {
    return Intl.message(
      'Family Head',
      name: 'familyHead',
      desc: 'Family head label',
      args: [],
    );
  }

  /// `Search for family head...`
  String get searchFamilyHead {
    return Intl.message(
      'Search for family head...',
      name: 'searchFamilyHead',
      desc: 'Search for family head hint',
      args: [],
    );
  }

  /// `Choose Family Head`
  String get chooseFamilyHead {
    return Intl.message(
      'Choose Family Head',
      name: 'chooseFamilyHead',
      desc: 'Choose family head label',
      args: [],
    );
  }

  /// `Please choose family head`
  String get pleaseChooseFamilyHead {
    return Intl.message(
      'Please choose family head',
      name: 'pleaseChooseFamilyHead',
      desc: 'Please choose family head validation',
      args: [],
    );
  }

  /// `Failed to load people`
  String get failedToLoadPeople {
    return Intl.message(
      'Failed to load people',
      name: 'failedToLoadPeople',
      desc: 'Failed to load people error',
      args: [],
    );
  }

  /// `Family Category`
  String get familyCategory {
    return Intl.message(
      'Family Category',
      name: 'familyCategory',
      desc: 'Family category label',
      args: [],
    );
  }

  /// `Choose Family Category`
  String get chooseFamilyCategory {
    return Intl.message(
      'Choose Family Category',
      name: 'chooseFamilyCategory',
      desc: 'Choose family category label',
      args: [],
    );
  }

  /// `Please choose family category`
  String get pleaseChooseFamilyCategory {
    return Intl.message(
      'Please choose family category',
      name: 'pleaseChooseFamilyCategory',
      desc: 'Please choose family category validation',
      args: [],
    );
  }

  /// `Failed to load categories`
  String get failedToLoadCategories {
    return Intl.message(
      'Failed to load categories',
      name: 'failedToLoadCategories',
      desc: 'Failed to load categories error',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: 'Location label',
      args: [],
    );
  }

  /// `Please enter location`
  String get pleaseEnterLocation {
    return Intl.message(
      'Please enter location',
      name: 'pleaseEnterLocation',
      desc: 'Please enter location validation',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: 'Notes label', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel button',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: 'Add button', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: 'Edit button', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: 'Delete button',
      args: [],
    );
  }

  /// `Change Manager`
  String get changeManager {
    return Intl.message(
      'Change Manager',
      name: 'changeManager',
      desc: 'Change manager label',
      args: [],
    );
  }

  /// `Here you can implement the logic to change the manager.`
  String get changeManagerLogic {
    return Intl.message(
      'Here you can implement the logic to change the manager.',
      name: 'changeManagerLogic',
      desc: 'Change manager logic text',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: 'Close button', args: []);
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: 'Confirm delete text',
      args: [],
    );
  }

  /// `Are you sure you want to delete this block?`
  String get confirmDeleteBlock {
    return Intl.message(
      'Are you sure you want to delete this block?',
      name: 'confirmDeleteBlock',
      desc: 'Confirm delete block text',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: 'Update button',
      args: [],
    );
  }

  /// `Third Name`
  String get thirdName {
    return Intl.message(
      'Third Name',
      name: 'thirdName',
      desc: 'Third name label',
      args: [],
    );
  }

  /// `Third name is required`
  String get thirdNameRequired {
    return Intl.message(
      'Third name is required',
      name: 'thirdNameRequired',
      desc: 'Third name required validation',
      args: [],
    );
  }

  /// `Fourth Name`
  String get fourthName {
    return Intl.message(
      'Fourth Name',
      name: 'fourthName',
      desc: 'Fourth name label',
      args: [],
    );
  }

  /// `Fourth name is required`
  String get fourthNameRequired {
    return Intl.message(
      'Fourth name is required',
      name: 'fourthNameRequired',
      desc: 'Fourth name required validation',
      args: [],
    );
  }

  /// `Identity Number`
  String get identityNumber {
    return Intl.message(
      'Identity Number',
      name: 'identityNumber',
      desc: 'Identity number label',
      args: [],
    );
  }

  /// `Identity Type`
  String get identityType {
    return Intl.message(
      'Identity Type',
      name: 'identityType',
      desc: 'Identity type label',
      args: [],
    );
  }

  /// `Choose Identity Type`
  String get chooseIdentityType {
    return Intl.message(
      'Choose Identity Type',
      name: 'chooseIdentityType',
      desc: 'Choose identity type label',
      args: [],
    );
  }

  /// `Please choose identity type`
  String get pleaseChooseIdentityType {
    return Intl.message(
      'Please choose identity type',
      name: 'pleaseChooseIdentityType',
      desc: 'Please choose identity type validation',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: 'Phone number label',
      args: [],
    );
  }

  /// `Contact Number`
  String get contactNumber {
    return Intl.message(
      'Contact Number',
      name: 'contactNumber',
      desc: 'Contact number label',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: 'Gender label',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: 'Male gender', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: 'Female gender',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message(
      'Birth Date',
      name: 'birthDate',
      desc: 'Birth date label',
      args: [],
    );
  }

  /// `Birth date is required`
  String get birthDateRequired {
    return Intl.message(
      'Birth date is required',
      name: 'birthDateRequired',
      desc: 'Birth date required validation',
      args: [],
    );
  }

  /// `Blood Type`
  String get bloodType {
    return Intl.message(
      'Blood Type',
      name: 'bloodType',
      desc: 'Blood type label',
      args: [],
    );
  }

  /// `Choose Blood Type`
  String get chooseBloodType {
    return Intl.message(
      'Choose Blood Type',
      name: 'chooseBloodType',
      desc: 'Choose blood type label',
      args: [],
    );
  }

  /// `Please choose blood type`
  String get pleaseChooseBloodType {
    return Intl.message(
      'Please choose blood type',
      name: 'pleaseChooseBloodType',
      desc: 'Please choose blood type validation',
      args: [],
    );
  }

  /// `Marital Status`
  String get maritalStatus {
    return Intl.message(
      'Marital Status',
      name: 'maritalStatus',
      desc: 'Marital status label',
      args: [],
    );
  }

  /// `Job`
  String get job {
    return Intl.message('Job', name: 'job', desc: 'Job label', args: []);
  }

  /// `Not specified`
  String get notSpecified {
    return Intl.message(
      'Not specified',
      name: 'notSpecified',
      desc: 'Not specified text',
      args: [],
    );
  }

  /// `Click for more details`
  String get clickForMoreDetails {
    return Intl.message(
      'Click for more details',
      name: 'clickForMoreDetails',
      desc: 'Click for more details text',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: 'Email label', args: []);
  }

  /// `Family Type`
  String get familyType {
    return Intl.message(
      'Family Type',
      name: 'familyType',
      desc: 'Family type label',
      args: [],
    );
  }

  /// `Add New Person`
  String get addNewPerson {
    return Intl.message(
      'Add New Person',
      name: 'addNewPerson',
      desc: 'Add new person title',
      args: [],
    );
  }

  /// `Edit Person Data`
  String get editPersonData {
    return Intl.message(
      'Edit Person Data',
      name: 'editPersonData',
      desc: 'Edit person data title',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: 'First name label',
      args: [],
    );
  }

  /// `First name is required`
  String get firstNameRequired {
    return Intl.message(
      'First name is required',
      name: 'firstNameRequired',
      desc: 'First name required validation',
      args: [],
    );
  }

  /// `Second Name`
  String get secondName {
    return Intl.message(
      'Second Name',
      name: 'secondName',
      desc: 'Second name label',
      args: [],
    );
  }

  /// `Second name is required`
  String get secondNameRequired {
    return Intl.message(
      'Second name is required',
      name: 'secondNameRequired',
      desc: 'Second name required validation',
      args: [],
    );
  }

  /// `Identity number is required`
  String get identityNumberRequired {
    return Intl.message(
      'Identity number is required',
      name: 'identityNumberRequired',
      desc: 'Identity number required validation',
      args: [],
    );
  }

  /// `Add New Member`
  String get addNewMember {
    return Intl.message(
      'Add New Member',
      name: 'addNewMember',
      desc: 'Add new member button',
      args: [],
    );
  }

  /// `Residential Block`
  String get residentialBlock {
    return Intl.message(
      'Residential Block',
      name: 'residentialBlock',
      desc: 'Residential block label',
      args: [],
    );
  }

  /// `Identity number must be 6 digits or more`
  String get identityNumberMinLength {
    return Intl.message(
      'Identity number must be 6 digits or more',
      name: 'identityNumberMinLength',
      desc: 'Identity number minimum length validation',
      args: [],
    );
  }

  /// `All People`
  String get allPeople {
    return Intl.message('All People', name: 'allPeople', desc: '', args: []);
  }

  /// `General Unit Report`
  String get generalUnitReport {
    return Intl.message(
      'General Unit Report',
      name: 'generalUnitReport',
      desc: '',
      args: [],
    );
  }

  /// `Assistance Section`
  String get assistanceSection {
    return Intl.message(
      'Assistance Section',
      name: 'assistanceSection',
      desc: '',
      args: [],
    );
  }

  /// `Conflict Section`
  String get conflictSection {
    return Intl.message(
      'Conflict Section',
      name: 'conflictSection',
      desc: '',
      args: [],
    );
  }

  /// `Teams Section`
  String get teamsSection {
    return Intl.message(
      'Teams Section',
      name: 'teamsSection',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get main {
    return Intl.message('Home', name: 'main', desc: '', args: []);
  }

  /// `Residential Blocks`
  String get residentialBlocks {
    return Intl.message(
      'Residential Blocks',
      name: 'residentialBlocks',
      desc: '',
      args: [],
    );
  }

  /// `Search for a residential block...`
  String get searchResidentialBlock {
    return Intl.message(
      'Search for a residential block...',
      name: 'searchResidentialBlock',
      desc: 'Search for a residential block hint',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
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
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
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
