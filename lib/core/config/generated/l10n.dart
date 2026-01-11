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

  /// `:ُEmail`
  String get emailLabel {
    return Intl.message(
      ':ُEmail',
      name: 'emailLabel',
      desc: 'ُEmail',
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

  /// `Search for manager...`
  String get searchFamilyHead {
    return Intl.message(
      'Search for manager...',
      name: 'searchFamilyHead',
      desc: 'Search for family head hint',
      args: [],
    );
  }

  /// `Choose manager`
  String get chooseFamilyHead {
    return Intl.message(
      'Choose manager',
      name: 'chooseFamilyHead',
      desc: 'Choose family head label',
      args: [],
    );
  }

  /// `Please choose a manager for the block`
  String get pleaseChooseFamilyHead {
    return Intl.message(
      'Please choose a manager for the block',
      name: 'pleaseChooseFamilyHead',
      desc: 'Please choose family head validation',
      args: [],
    );
  }

  /// `No managers available`
  String get failedToLoadPeople {
    return Intl.message(
      'No managers available',
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

  /// `Change Block Manager`
  String get changeManager {
    return Intl.message(
      'Change Block Manager',
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

  /// `Block Manager`
  String get blockManager {
    return Intl.message(
      'Block Manager',
      name: 'blockManager',
      desc: '',
      args: [],
    );
  }

  /// `Verify the code`
  String get verifyCode {
    return Intl.message(
      'Verify the code',
      name: 'verifyCode',
      desc: 'The sub title of the CheckEmail page',
      args: [],
    );
  }

  /// `Please enter the code we just sent to the email you entered`
  String get enterverifyCode {
    return Intl.message(
      'Please enter the code we just sent to the email you entered',
      name: 'enterverifyCode',
      desc: 'The label of verifyCode in CheckEmail page',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: 'The next button',
      args: [],
    );
  }

  /// `Please enter the Verify code`
  String get warningVerifycodeEmpty {
    return Intl.message(
      'Please enter the Verify code',
      name: 'warningVerifycodeEmpty',
      desc: 'The warning of not entering the Verify code',
      args: [],
    );
  }

  /// `Please enter only numbers`
  String get warningVerifycodeType {
    return Intl.message(
      'Please enter only numbers',
      name: 'warningVerifycodeType',
      desc: 'The warning of entering  not number value for Verify code',
      args: [],
    );
  }

  /// `Resend code`
  String get resendVerifycode {
    return Intl.message(
      'Resend code',
      name: 'resendVerifycode',
      desc: 'Resend Verify code button',
      args: [],
    );
  }

  /// `Resend code at 00`
  String get resendVerifycodeAt {
    return Intl.message(
      'Resend code at 00',
      name: 'resendVerifycodeAt',
      desc: 'Resend Verify code Timer',
      args: [],
    );
  }

  /// `Create a new password`
  String get createNewPasswordTitle {
    return Intl.message(
      'Create a new password',
      name: 'createNewPasswordTitle',
      desc: 'Title for the create new password page',
      args: [],
    );
  }

  /// `Your new password must be different from the password previously used.`
  String get passwordDifferentHint {
    return Intl.message(
      'Your new password must be different from the password previously used.',
      name: 'passwordDifferentHint',
      desc: 'Hint for password creation',
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

  /// `Enter password`
  String get enterPasswordHint {
    return Intl.message(
      'Enter password',
      name: 'enterPasswordHint',
      desc: 'Hint for entering password',
      args: [],
    );
  }

  /// `Password must be at least 8 characters and contain an uppercase letter and a number`
  String get passwordValidationHint {
    return Intl.message(
      'Password must be at least 8 characters and contain an uppercase letter and a number',
      name: 'passwordValidationHint',
      desc: 'Password validation hint',
      args: [],
    );
  }

  /// `Re-enter password:`
  String get retypePasswordLabel {
    return Intl.message(
      'Re-enter password:',
      name: 'retypePasswordLabel',
      desc: 'Retype password label with colon',
      args: [],
    );
  }

  /// `Submit`
  String get sendButton {
    return Intl.message(
      'Submit',
      name: 'sendButton',
      desc: 'Send button text',
      args: [],
    );
  }

  /// `Password does not match the other one`
  String get passwordsMismatch {
    return Intl.message(
      'Password does not match the other one',
      name: 'passwordsMismatch',
      desc: 'Passwords mismatch error message',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordTitle',
      desc: 'Title for the forgot password page',
      args: [],
    );
  }

  /// `Don't worry! Please enter your email`
  String get forgotPasswordHint {
    return Intl.message(
      'Don\'t worry! Please enter your email',
      name: 'forgotPasswordHint',
      desc: 'Hint for forgot password page',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: 'Email label', args: []);
  }

  /// `Enter your email`
  String get enterEmailHint {
    return Intl.message(
      'Enter your email',
      name: 'enterEmailHint',
      desc: 'Hint for entering email',
      args: [],
    );
  }

  /// `Next`
  String get nextButton {
    return Intl.message(
      'Next',
      name: 'nextButton',
      desc: 'Next button text',
      args: [],
    );
  }

  /// `Email sent successfully, a confirmation code will be sent to your email address.`
  String get emailSentSuccess {
    return Intl.message(
      'Email sent successfully, a confirmation code will be sent to your email address.',
      name: 'emailSentSuccess',
      desc: 'Success message when email is sent',
      args: [],
    );
  }

  /// `An unknown error occurred`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred',
      name: 'unknownError',
      desc: 'General unknown error message',
      args: [],
    );
  }

  /// `Email has been confirmed`
  String get emailConfirmedSuccess {
    return Intl.message(
      'Email has been confirmed',
      name: 'emailConfirmedSuccess',
      desc: 'Success message when email is confirmed',
      args: [],
    );
  }

  /// `Password has been changed successfully`
  String get passwordChangedSuccess {
    return Intl.message(
      'Password has been changed successfully',
      name: 'passwordChangedSuccess',
      desc: 'Success message when password is changed',
      args: [],
    );
  }

  /// `Change Block Name`
  String get changeBlockName {
    return Intl.message(
      'Change Block Name',
      name: 'changeBlockName',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: 'Save button', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Confirm button',
      args: [],
    );
  }

  /// `Deletion is not allowed at this time`
  String get deleteNotAllowed {
    return Intl.message(
      'Deletion is not allowed at this time',
      name: 'deleteNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Add Family to Assistance`
  String get addFamilyToAssistanceTitle {
    return Intl.message(
      'Add Family to Assistance',
      name: 'addFamilyToAssistanceTitle',
      desc: 'Title for the AddFamilyToAssistance page',
      args: [],
    );
  }

  /// `Select Family`
  String get selectFamily {
    return Intl.message(
      'Select Family',
      name: 'selectFamily',
      desc: 'Label for selecting a family',
      args: [],
    );
  }

  /// `Search for a family...`
  String get searchFamilyHint {
    return Intl.message(
      'Search for a family...',
      name: 'searchFamilyHint',
      desc: 'Hint text for searching family',
      args: [],
    );
  }

  /// `No families found`
  String get noFamiliesFound {
    return Intl.message(
      'No families found',
      name: 'noFamiliesFound',
      desc: 'Message when no families are found',
      args: [],
    );
  }

  /// `If you want to create a new family, go to the residential blocks section here`
  String get createNewFamilyHint {
    return Intl.message(
      'If you want to create a new family, go to the residential blocks section here',
      name: 'createNewFamilyHint',
      desc: 'Hint text guiding to create a new family',
      args: [],
    );
  }

  /// `Create New Family`
  String get createNewFamilyButton {
    return Intl.message(
      'Create New Family',
      name: 'createNewFamilyButton',
      desc: 'Button text to create new family',
      args: [],
    );
  }

  /// `Add Team to Assistance Distribution`
  String get addTeamToAssistanceTitle {
    return Intl.message(
      'Add Team to Assistance Distribution',
      name: 'addTeamToAssistanceTitle',
      desc: 'Title of the Add Team to Assistance Distribution page',
      args: [],
    );
  }

  /// `Select Team`
  String get selectTeam {
    return Intl.message(
      'Select Team',
      name: 'selectTeam',
      desc: 'Label for selecting a team',
      args: [],
    );
  }

  /// `Search for a team...`
  String get searchTeamHint {
    return Intl.message(
      'Search for a team...',
      name: 'searchTeamHint',
      desc: 'Hint text for searching for a team',
      args: [],
    );
  }

  /// `No teams found`
  String get noTeamsFound {
    return Intl.message(
      'No teams found',
      name: 'noTeamsFound',
      desc: 'Message displayed when no teams are found',
      args: [],
    );
  }

  /// `If you want to create a new team, go to the teams section here`
  String get createNewTeamHint {
    return Intl.message(
      'If you want to create a new team, go to the teams section here',
      name: 'createNewTeamHint',
      desc: 'Hint text guiding to create a new team',
      args: [],
    );
  }

  /// `Team assigned successfully`
  String get teamAssignedSuccessfully {
    return Intl.message(
      'Team assigned successfully',
      name: 'teamAssignedSuccessfully',
      desc: 'Success message when team is assigned successfully',
      args: [],
    );
  }

  /// `Team assignment failed`
  String get teamAssignmentFailed {
    return Intl.message(
      'Team assignment failed',
      name: 'teamAssignmentFailed',
      desc: 'Error message when team assignment fails',
      args: [],
    );
  }

  /// `Add New Assistance Distribution Project`
  String get addAssistanceProjectTitle {
    return Intl.message(
      'Add New Assistance Distribution Project',
      name: 'addAssistanceProjectTitle',
      desc: 'Title for adding new assistance distribution project',
      args: [],
    );
  }

  /// `Edit Assistance Distribution Project`
  String get editAssistanceProjectTitle {
    return Intl.message(
      'Edit Assistance Distribution Project',
      name: 'editAssistanceProjectTitle',
      desc: 'Title for editing assistance distribution project',
      args: [],
    );
  }

  /// `Project Name`
  String get projectName {
    return Intl.message(
      'Project Name',
      name: 'projectName',
      desc: 'Project name label',
      args: [],
    );
  }

  /// `Project Description`
  String get projectDescription {
    return Intl.message(
      'Project Description',
      name: 'projectDescription',
      desc: 'Project description label',
      args: [],
    );
  }

  /// `Project Category`
  String get projectCategory {
    return Intl.message(
      'Project Category',
      name: 'projectCategory',
      desc: 'Project category label',
      args: [],
    );
  }

  /// `Search for category...`
  String get searchCategoryHint {
    return Intl.message(
      'Search for category...',
      name: 'searchCategoryHint',
      desc: 'Hint text for searching category',
      args: [],
    );
  }

  /// `Choose Category`
  String get chooseCategory {
    return Intl.message(
      'Choose Category',
      name: 'chooseCategory',
      desc: 'Choose category label',
      args: [],
    );
  }

  /// `No categories available`
  String get noCategoriesAvailable {
    return Intl.message(
      'No categories available',
      name: 'noCategoriesAvailable',
      desc: 'Message when no categories are available',
      args: [],
    );
  }

  /// `Manager Name`
  String get managerName {
    return Intl.message(
      'Manager Name',
      name: 'managerName',
      desc: 'Manager name label',
      args: [],
    );
  }

  /// `Search for manager...`
  String get searchManagerHint {
    return Intl.message(
      'Search for manager...',
      name: 'searchManagerHint',
      desc: 'Hint text for searching manager',
      args: [],
    );
  }

  /// `Choose Manager`
  String get chooseManager {
    return Intl.message(
      'Choose Manager',
      name: 'chooseManager',
      desc: 'Choose manager label',
      args: [],
    );
  }

  /// `No managers available`
  String get noManagersAvailable {
    return Intl.message(
      'No managers available',
      name: 'noManagersAvailable',
      desc: 'Message when no managers are available',
      args: [],
    );
  }

  /// `Distribution Start Date`
  String get distributionStartDate {
    return Intl.message(
      'Distribution Start Date',
      name: 'distributionStartDate',
      desc: 'Distribution start date label',
      args: [],
    );
  }

  /// `Distribution End Date`
  String get distributionEndDate {
    return Intl.message(
      'Distribution End Date',
      name: 'distributionEndDate',
      desc: 'Distribution end date label',
      args: [],
    );
  }

  /// `Project Status`
  String get projectStatus {
    return Intl.message(
      'Project Status',
      name: 'projectStatus',
      desc: 'Project status label',
      args: [],
    );
  }

  /// `Choose Project Status`
  String get chooseProjectStatus {
    return Intl.message(
      'Choose Project Status',
      name: 'chooseProjectStatus',
      desc: 'Choose project status label',
      args: [],
    );
  }

  /// `Project Priority`
  String get projectPriority {
    return Intl.message(
      'Project Priority',
      name: 'projectPriority',
      desc: 'Project priority label',
      args: [],
    );
  }

  /// `Choose Project Priority`
  String get chooseProjectPriority {
    return Intl.message(
      'Choose Project Priority',
      name: 'chooseProjectPriority',
      desc: 'Choose project priority label',
      args: [],
    );
  }

  /// `Budget`
  String get budget {
    return Intl.message(
      'Budget',
      name: 'budget',
      desc: 'Budget label',
      args: [],
    );
  }

  /// `Assistance added successfully`
  String get assistanceAddedSuccessfully {
    return Intl.message(
      'Assistance added successfully',
      name: 'assistanceAddedSuccessfully',
      desc: 'Success message when assistance is added',
      args: [],
    );
  }

  /// `Assistance updated successfully`
  String get assistanceUpdatedSuccessfully {
    return Intl.message(
      'Assistance updated successfully',
      name: 'assistanceUpdatedSuccessfully',
      desc: 'Success message when assistance is updated',
      args: [],
    );
  }

  /// `Assistance Distribution Projects`
  String get assistanceProjectsTitle {
    return Intl.message(
      'Assistance Distribution Projects',
      name: 'assistanceProjectsTitle',
      desc: 'Title for assistance distribution projects page',
      args: [],
    );
  }

  /// `Search for assistance project`
  String get searchAssistanceProjectHint {
    return Intl.message(
      'Search for assistance project',
      name: 'searchAssistanceProjectHint',
      desc: 'Hint text for searching assistance projects',
      args: [],
    );
  }

  /// `No data available for display currently`
  String get noDataAvailable {
    return Intl.message(
      'No data available for display currently',
      name: 'noDataAvailable',
      desc: 'Message when no data is available for display',
      args: [],
    );
  }

  /// `Priority`
  String get tableColumnPriority {
    return Intl.message(
      'Priority',
      name: 'tableColumnPriority',
      desc: 'Table column title for priority',
      args: [],
    );
  }

  /// `Project Name`
  String get tableColumnProjectName {
    return Intl.message(
      'Project Name',
      name: 'tableColumnProjectName',
      desc: 'Table column title for project name',
      args: [],
    );
  }

  /// `Number`
  String get tableColumnNumber {
    return Intl.message(
      'Number',
      name: 'tableColumnNumber',
      desc: 'Table column title for number/ID',
      args: [],
    );
  }

  /// `Are you sure you want to delete this assistance project?`
  String get deleteAssistanceConfirmation {
    return Intl.message(
      'Are you sure you want to delete this assistance project?',
      name: 'deleteAssistanceConfirmation',
      desc: 'Confirmation message for deleting assistance project',
      args: [],
    );
  }

  /// `Assistance Details`
  String get assistanceDetailsTitle {
    return Intl.message(
      'Assistance Details',
      name: 'assistanceDetailsTitle',
      desc: 'Title for assistance details page',
      args: [],
    );
  }

  /// `Distribution Teams`
  String get distributionTeams {
    return Intl.message(
      'Distribution Teams',
      name: 'distributionTeams',
      desc: 'Label for distribution teams section',
      args: [],
    );
  }

  /// `No teams available to display currently`
  String get noTeamsAvailable {
    return Intl.message(
      'No teams available to display currently',
      name: 'noTeamsAvailable',
      desc: 'Message when no teams are available to display',
      args: [],
    );
  }

  /// `Team Name`
  String get teamName {
    return Intl.message(
      'Team Name',
      name: 'teamName',
      desc: 'Label for team name',
      args: [],
    );
  }

  /// `Add Team`
  String get addTeam {
    return Intl.message(
      'Add Team',
      name: 'addTeam',
      desc: 'Button text to add team',
      args: [],
    );
  }

  /// `Residential Blocks and Distributed Families`
  String get residentialBlocksAndFamilies {
    return Intl.message(
      'Residential Blocks and Distributed Families',
      name: 'residentialBlocksAndFamilies',
      desc: 'Label for residential blocks and families section',
      args: [],
    );
  }

  /// `No families available to display currently`
  String get noFamiliesAvailable {
    return Intl.message(
      'No families available to display currently',
      name: 'noFamiliesAvailable',
      desc: 'Message when no families are available to display',
      args: [],
    );
  }

  /// `Residential Block Name`
  String get residentialBlockName {
    return Intl.message(
      'Residential Block Name',
      name: 'residentialBlockName',
      desc: 'Label for residential block name',
      args: [],
    );
  }

  /// `Add Family`
  String get addFamily {
    return Intl.message(
      'Add Family',
      name: 'addFamily',
      desc: 'Button text to add family',
      args: [],
    );
  }

  /// `Role`
  String get teamRole {
    return Intl.message(
      'Role',
      name: 'teamRole',
      desc: 'Table column for team role',
      args: [],
    );
  }

  /// `Join Date`
  String get joinDate {
    return Intl.message(
      'Join Date',
      name: 'joinDate',
      desc: 'Table column for join date',
      args: [],
    );
  }

  /// `Member Name`
  String get memberName {
    return Intl.message(
      'Member Name',
      name: 'memberName',
      desc: 'Table column for member name',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: 'Table column for number/ID',
      args: [],
    );
  }

  /// `Family Head Name`
  String get familyHeadName {
    return Intl.message(
      'Family Head Name',
      name: 'familyHeadName',
      desc: 'Table column for family head name',
      args: [],
    );
  }

  /// `Are you sure you want to delete this team?`
  String get deleteTeamConfirmation {
    return Intl.message(
      'Are you sure you want to delete this team?',
      name: 'deleteTeamConfirmation',
      desc: 'Confirmation message for deleting team',
      args: [],
    );
  }

  /// `Are you sure you want to delete this family?`
  String get deleteFamilyConfirmation {
    return Intl.message(
      'Are you sure you want to delete this family?',
      name: 'deleteFamilyConfirmation',
      desc: 'Confirmation message for deleting family',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: 'Label for description',
      args: [],
    );
  }

  /// `Project Manager`
  String get projectManager {
    return Intl.message(
      'Project Manager',
      name: 'projectManager',
      desc: 'Label for project manager',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message(
      'Priority',
      name: 'priority',
      desc: 'Label for priority',
      args: [],
    );
  }

  /// `No assistance projects`
  String get noAssistanceProjects {
    return Intl.message(
      'No assistance projects',
      name: 'noAssistanceProjects',
      desc: 'Message when there are no assistance projects',
      args: [],
    );
  }

  /// `No data received`
  String get noDataReceived {
    return Intl.message(
      'No data received',
      name: 'noDataReceived',
      desc: 'Message when no data is received from server',
      args: [],
    );
  }

  /// `Unknown error occurred`
  String get unknownErrorOccurred {
    return Intl.message(
      'Unknown error occurred',
      name: 'unknownErrorOccurred',
      desc: 'Generic unknown error message',
      args: [],
    );
  }

  /// `Team deleted successfully`
  String get teamDeletedSuccessfully {
    return Intl.message(
      'Team deleted successfully',
      name: 'teamDeletedSuccessfully',
      desc: 'Success message when team is deleted successfully',
      args: [],
    );
  }

  /// `Family deleted successfully`
  String get familyDeletedSuccessfully {
    return Intl.message(
      'Family deleted successfully',
      name: 'familyDeletedSuccessfully',
      desc: 'Success message when family is deleted successfully',
      args: [],
    );
  }

  /// `No teams available`
  String get noTeamsAvailableMessage {
    return Intl.message(
      'No teams available',
      name: 'noTeamsAvailableMessage',
      desc: 'Message when no teams are available',
      args: [],
    );
  }

  /// `No families available`
  String get noFamiliesAvailableMessage {
    return Intl.message(
      'No families available',
      name: 'noFamiliesAvailableMessage',
      desc: 'Message when no families are available',
      args: [],
    );
  }

  /// `Assigning team...`
  String get waitingForTeamAssignment {
    return Intl.message(
      'Assigning team...',
      name: 'waitingForTeamAssignment',
      desc: 'Loading message for team assignment',
      args: [],
    );
  }

  /// `Assigning family...`
  String get waitingForFamilyAssignment {
    return Intl.message(
      'Assigning family...',
      name: 'waitingForFamilyAssignment',
      desc: 'Loading message for family assignment',
      args: [],
    );
  }

  /// `Updating assistance...`
  String get waitingForAssistanceUpdate {
    return Intl.message(
      'Updating assistance...',
      name: 'waitingForAssistanceUpdate',
      desc: 'Loading message for assistance update',
      args: [],
    );
  }

  /// `Family assigned successfully`
  String get familyAssignedSuccessfully {
    return Intl.message(
      'Family assigned successfully',
      name: 'familyAssignedSuccessfully',
      desc: 'Success message when family is assigned successfully',
      args: [],
    );
  }

  /// `Assistance deleted successfully`
  String get assistanceDeletedSuccessfully {
    return Intl.message(
      'Assistance deleted successfully',
      name: 'assistanceDeletedSuccessfully',
      desc: 'Success message when assistance is deleted successfully',
      args: [],
    );
  }

  /// `Add Conflict`
  String get addConflictTitle {
    return Intl.message(
      'Add Conflict',
      name: 'addConflictTitle',
      desc: 'Title for adding a new conflict',
      args: [],
    );
  }

  /// `Edit Conflict`
  String get editConflictTitle {
    return Intl.message(
      'Edit Conflict',
      name: 'editConflictTitle',
      desc: 'Title for editing a conflict',
      args: [],
    );
  }

  /// `Conflict Title`
  String get conflictTitleLabel {
    return Intl.message(
      'Conflict Title',
      name: 'conflictTitleLabel',
      desc: 'Label for conflict title input field',
      args: [],
    );
  }

  /// `Conflict Type`
  String get conflictTypeLabel {
    return Intl.message(
      'Conflict Type',
      name: 'conflictTypeLabel',
      desc: 'Label for conflict type selection',
      args: [],
    );
  }

  /// `Search for conflict type...`
  String get searchConflictTypeHint {
    return Intl.message(
      'Search for conflict type...',
      name: 'searchConflictTypeHint',
      desc: 'Hint text for searching conflict types',
      args: [],
    );
  }

  /// `Choose Conflict Type`
  String get chooseConflictTypeLabel {
    return Intl.message(
      'Choose Conflict Type',
      name: 'chooseConflictTypeLabel',
      desc: 'Label for choosing conflict type',
      args: [],
    );
  }

  /// `No types available`
  String get noConflictTypesAvailable {
    return Intl.message(
      'No types available',
      name: 'noConflictTypesAvailable',
      desc: 'Message when no conflict types are available',
      args: [],
    );
  }

  /// `Notes`
  String get notesLabel {
    return Intl.message(
      'Notes',
      name: 'notesLabel',
      desc: 'Label for notes input field',
      args: [],
    );
  }

  /// `Conflict Date`
  String get conflictDateLabel {
    return Intl.message(
      'Conflict Date',
      name: 'conflictDateLabel',
      desc: 'Label for conflict date input field',
      args: [],
    );
  }

  /// `First Party`
  String get firstPartyLabel {
    return Intl.message(
      'First Party',
      name: 'firstPartyLabel',
      desc: 'Label for first party selection',
      args: [],
    );
  }

  /// `Search for first party...`
  String get searchFirstPartyHint {
    return Intl.message(
      'Search for first party...',
      name: 'searchFirstPartyHint',
      desc: 'Hint text for searching first party',
      args: [],
    );
  }

  /// `Choose First Party`
  String get chooseFirstPartyLabel {
    return Intl.message(
      'Choose First Party',
      name: 'chooseFirstPartyLabel',
      desc: 'Label for choosing first party',
      args: [],
    );
  }

  /// `No family members available`
  String get noFamilyMembersAvailable {
    return Intl.message(
      'No family members available',
      name: 'noFamilyMembersAvailable',
      desc: 'Message when no family members are available',
      args: [],
    );
  }

  /// `Second Party`
  String get secondPartyLabel {
    return Intl.message(
      'Second Party',
      name: 'secondPartyLabel',
      desc: 'Label for second party selection',
      args: [],
    );
  }

  /// `Search for second party...`
  String get searchSecondPartyHint {
    return Intl.message(
      'Search for second party...',
      name: 'searchSecondPartyHint',
      desc: 'Hint text for searching second party',
      args: [],
    );
  }

  /// `Choose Second Party`
  String get chooseSecondPartyLabel {
    return Intl.message(
      'Choose Second Party',
      name: 'chooseSecondPartyLabel',
      desc: 'Label for choosing second party',
      args: [],
    );
  }

  /// `Conflict Resolved`
  String get conflictResolvedLabel {
    return Intl.message(
      'Conflict Resolved',
      name: 'conflictResolvedLabel',
      desc: 'Label for conflict resolved checkbox',
      args: [],
    );
  }

  /// `Conflict added successfully`
  String get conflictAddedSuccessfully {
    return Intl.message(
      'Conflict added successfully',
      name: 'conflictAddedSuccessfully',
      desc: 'Success message when conflict is added',
      args: [],
    );
  }

  /// `Conflict updated successfully`
  String get conflictUpdatedSuccessfully {
    return Intl.message(
      'Conflict updated successfully',
      name: 'conflictUpdatedSuccessfully',
      desc: 'Success message when conflict is updated',
      args: [],
    );
  }

  /// `Please choose conflict type`
  String get pleaseChooseConflictType {
    return Intl.message(
      'Please choose conflict type',
      name: 'pleaseChooseConflictType',
      desc: 'Validation message for conflict type selection',
      args: [],
    );
  }

  /// `Conflict Management`
  String get conflictManagementTitle {
    return Intl.message(
      'Conflict Management',
      name: 'conflictManagementTitle',
      desc: 'Title for conflict management page',
      args: [],
    );
  }

  /// `No conflicts available to display currently`
  String get noConflictsAvailable {
    return Intl.message(
      'No conflicts available to display currently',
      name: 'noConflictsAvailable',
      desc: 'Message when no conflicts are available to display',
      args: [],
    );
  }

  /// `First Party:`
  String get firstPartyLabelWithColon {
    return Intl.message(
      'First Party:',
      name: 'firstPartyLabelWithColon',
      desc: 'Label for first party with colon',
      args: [],
    );
  }

  /// `Second Party:`
  String get secondPartyLabelWithColon {
    return Intl.message(
      'Second Party:',
      name: 'secondPartyLabelWithColon',
      desc: 'Label for second party with colon',
      args: [],
    );
  }

  /// `Session Date:`
  String get sessionDateLabel {
    return Intl.message(
      'Session Date:',
      name: 'sessionDateLabel',
      desc: 'Label for session date with colon',
      args: [],
    );
  }

  /// `Search for team name`
  String get searchConflictHint {
    return Intl.message(
      'Search for team name',
      name: 'searchConflictHint',
      desc: 'Hint text for searching conflicts',
      args: [],
    );
  }

  /// `Add`
  String get addButtonConflictList {
    return Intl.message(
      'Add',
      name: 'addButtonConflictList',
      desc: 'Add button text in conflict list page',
      args: [],
    );
  }

  /// `Edit`
  String get editOption {
    return Intl.message(
      'Edit',
      name: 'editOption',
      desc: 'Edit option in context menu',
      args: [],
    );
  }

  /// `Delete`
  String get deleteOption {
    return Intl.message(
      'Delete',
      name: 'deleteOption',
      desc: 'Delete option in context menu',
      args: [],
    );
  }

  /// `Are you sure you want to delete this document`
  String get deleteConflictConfirmation {
    return Intl.message(
      'Are you sure you want to delete this document',
      name: 'deleteConflictConfirmation',
      desc: 'Confirmation message for deleting conflict document',
      args: [],
    );
  }

  /// `No data available for display currently`
  String get noDataAvailableConflict {
    return Intl.message(
      'No data available for display currently',
      name: 'noDataAvailableConflict',
      desc: 'Message when no data is available for display in conflicts page',
      args: [],
    );
  }

  /// `Conflict Details`
  String get conflictDetailsTitle {
    return Intl.message(
      'Conflict Details',
      name: 'conflictDetailsTitle',
      desc: 'Title for conflict details page',
      args: [],
    );
  }

  /// `First Party:`
  String get firstPartyWithColon {
    return Intl.message(
      'First Party:',
      name: 'firstPartyWithColon',
      desc: 'Label for first party with colon',
      args: [],
    );
  }

  /// `Second Party:`
  String get secondPartyWithColon {
    return Intl.message(
      'Second Party:',
      name: 'secondPartyWithColon',
      desc: 'Label for second party with colon',
      args: [],
    );
  }

  /// `Treaty Supervisor:`
  String get treatySupervisor {
    return Intl.message(
      'Treaty Supervisor:',
      name: 'treatySupervisor',
      desc: 'Label for treaty supervisor with colon',
      args: [],
    );
  }

  /// `Session Date:`
  String get sessionDateWithColon {
    return Intl.message(
      'Session Date:',
      name: 'sessionDateWithColon',
      desc: 'Label for session date with colon',
      args: [],
    );
  }

  /// `Conflict Resolved`
  String get conflictResolvedStatus {
    return Intl.message(
      'Conflict Resolved',
      name: 'conflictResolvedStatus',
      desc: 'Status message when conflict is resolved',
      args: [],
    );
  }

  /// `Conflict Not Resolved`
  String get conflictNotResolvedStatus {
    return Intl.message(
      'Conflict Not Resolved',
      name: 'conflictNotResolvedStatus',
      desc: 'Status message when conflict is not resolved',
      args: [],
    );
  }

  /// `Notes:`
  String get notesWithColon {
    return Intl.message(
      'Notes:',
      name: 'notesWithColon',
      desc: 'Label for notes with colon',
      args: [],
    );
  }

  /// `No data received`
  String get no_data_received {
    return Intl.message(
      'No data received',
      name: 'no_data_received',
      desc: 'Error message when no data is received from the server',
      args: [],
    );
  }

  /// `No teams found`
  String get no_teams_found {
    return Intl.message(
      'No teams found',
      name: 'no_teams_found',
      desc: 'Error message when no teams are found',
      args: [],
    );
  }

  /// `Added successfully`
  String get added_successfully {
    return Intl.message(
      'Added successfully',
      name: 'added_successfully',
      desc: 'Success message for a new conflict',
      args: [],
    );
  }

  /// `An unknown error occurred`
  String get unknown_error_add {
    return Intl.message(
      'An unknown error occurred',
      name: 'unknown_error_add',
      desc: 'Generic unknown error message for adding a conflict',
      args: [],
    );
  }

  /// `Updated successfully`
  String get updated_successfully {
    return Intl.message(
      'Updated successfully',
      name: 'updated_successfully',
      desc: 'Success message for updating a conflict',
      args: [],
    );
  }

  /// `An unknown error occurred while updating the project`
  String get unknown_error_update {
    return Intl.message(
      'An unknown error occurred while updating the project',
      name: 'unknown_error_update',
      desc: 'Generic unknown error message for updating a conflict',
      args: [],
    );
  }

  /// `Deleted successfully`
  String get deleted_successfully {
    return Intl.message(
      'Deleted successfully',
      name: 'deleted_successfully',
      desc: 'Success message for deleting a conflict',
      args: [],
    );
  }

  /// `Team`
  String get team_page_title {
    return Intl.message(
      'Team',
      name: 'team_page_title',
      desc: 'The title for the team page or screen.',
      args: [],
    );
  }

  /// `Add New Member`
  String get add_new_member {
    return Intl.message(
      'Add New Member',
      name: 'add_new_member',
      desc: 'The title for adding a new team member.',
      args: [],
    );
  }

  /// `Update Member`
  String get update_member {
    return Intl.message(
      'Update Member',
      name: 'update_member',
      desc: 'The title for updating an existing team member.',
      args: [],
    );
  }

  /// `Member Name`
  String get member_name {
    return Intl.message(
      'Member Name',
      name: 'member_name',
      desc: 'Label for the team member\'s name.',
      args: [],
    );
  }

  /// `Search for a leader...`
  String get search_for_a_leader {
    return Intl.message(
      'Search for a leader...',
      name: 'search_for_a_leader',
      desc: 'Hint text for searching for a leader in a dropdown.',
      args: [],
    );
  }

  /// `No available people`
  String get no_available_people {
    return Intl.message(
      'No available people',
      name: 'no_available_people',
      desc: 'Message shown when there are no people available to select.',
      args: [],
    );
  }

  /// `Select Member`
  String get select_member {
    return Intl.message(
      'Select Member',
      name: 'select_member',
      desc: 'Label for selecting a team member.',
      args: [],
    );
  }

  /// `Join Date`
  String get join_date {
    return Intl.message(
      'Join Date',
      name: 'join_date',
      desc: 'Label for the date a member joined the team.',
      args: [],
    );
  }

  /// `Member Role`
  String get member_role {
    return Intl.message(
      'Member Role',
      name: 'member_role',
      desc: 'Label for the role of a team member.',
      args: [],
    );
  }

  /// `Search for a role...`
  String get search_for_a_role {
    return Intl.message(
      'Search for a role...',
      name: 'search_for_a_role',
      desc: 'Hint text for searching for a role in a dropdown.',
      args: [],
    );
  }

  /// `No available roles`
  String get no_available_roles {
    return Intl.message(
      'No available roles',
      name: 'no_available_roles',
      desc: 'Message shown when no roles are available to select.',
      args: [],
    );
  }

  /// `Select Role`
  String get select_role {
    return Intl.message(
      'Select Role',
      name: 'select_role',
      desc: 'Label for selecting a team role.',
      args: [],
    );
  }

  /// `Add New Team`
  String get add_new_team {
    return Intl.message(
      'Add New Team',
      name: 'add_new_team',
      desc: 'The title for adding a new team.',
      args: [],
    );
  }

  /// `Update Team`
  String get update_team {
    return Intl.message(
      'Update Team',
      name: 'update_team',
      desc: 'The title for updating an existing team.',
      args: [],
    );
  }

  /// `Team Name`
  String get team_name {
    return Intl.message(
      'Team Name',
      name: 'team_name',
      desc: 'Label for the team\'s name.',
      args: [],
    );
  }

  /// `Select Team Leader`
  String get select_team_leader {
    return Intl.message(
      'Select Team Leader',
      name: 'select_team_leader',
      desc: 'Label for selecting the team leader.',
      args: [],
    );
  }

  /// `Select Leader`
  String get select_leader_hint {
    return Intl.message(
      'Select Leader',
      name: 'select_leader_hint',
      desc: 'Hint text for the team leader dropdown.',
      args: [],
    );
  }

  /// `Teams`
  String get teams {
    return Intl.message(
      'Teams',
      name: 'teams',
      desc: 'The title for the teams page.',
      args: [],
    );
  }

  /// `No teams to display currently.`
  String get no_teams_to_display {
    return Intl.message(
      'No teams to display currently.',
      name: 'no_teams_to_display',
      desc: 'Message shown when there are no teams to display.',
      args: [],
    );
  }

  /// `Team Name:`
  String get team_name_label {
    return Intl.message(
      'Team Name:',
      name: 'team_name_label',
      desc: 'Label for the team\'s name in a list item.',
      args: [],
    );
  }

  /// `Search for a team name`
  String get search_team_hint {
    return Intl.message(
      'Search for a team name',
      name: 'search_team_hint',
      desc: 'Hint text for the search bar to find a team by name.',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirm_delete {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirm_delete',
      desc: 'Title for the delete confirmation dialog.',
      args: [],
    );
  }

  /// `Are you sure you want to delete this team?`
  String get confirm_delete_team_message {
    return Intl.message(
      'Are you sure you want to delete this team?',
      name: 'confirm_delete_team_message',
      desc: 'Message for the team deletion confirmation dialog.',
      args: [],
    );
  }

  /// `Are you sure you want to delete this member?`
  String get confirm_delete_member_message {
    return Intl.message(
      'Are you sure you want to delete this member?',
      name: 'confirm_delete_member_message',
      desc: 'Message for the team member deletion confirmation dialog.',
      args: [],
    );
  }

  /// `No data to display currently.`
  String get no_data_to_display {
    return Intl.message(
      'No data to display currently.',
      name: 'no_data_to_display',
      desc: 'Message shown when there is no data to display.',
      args: [],
    );
  }

  /// `No.`
  String get number_column {
    return Intl.message(
      'No.',
      name: 'number_column',
      desc: 'Column title for a numbered list.',
      args: [],
    );
  }

  /// `Team Details`
  String get team_details {
    return Intl.message(
      'Team Details',
      name: 'team_details',
      desc: 'The title for the team details page.',
      args: [],
    );
  }

  /// `No Leader`
  String get no_leader {
    return Intl.message(
      'No Leader',
      name: 'no_leader',
      desc: 'Text shown when there is no team leader.',
      args: [],
    );
  }

  /// `Team Leader Name: {teamLeaderName}`
  String team_leader_name(String teamLeaderName) {
    return Intl.message(
      'Team Leader Name: $teamLeaderName',
      name: 'team_leader_name',
      desc: 'Label for the team leader\'s name.',
      args: [teamLeaderName],
    );
  }

  /// `Number of Team Members: {count}`
  String number_of_team_members(int count) {
    return Intl.message(
      'Number of Team Members: $count',
      name: 'number_of_team_members',
      desc: 'Label for the number of team members.',
      args: [count],
    );
  }

  /// `: Team Members`
  String get team_members {
    return Intl.message(
      ': Team Members',
      name: 'team_members',
      desc: 'Title for the team members section.',
      args: [],
    );
  }

  /// `: Projects the team works on`
  String get projects_of_team {
    return Intl.message(
      ': Projects the team works on',
      name: 'projects_of_team',
      desc: 'Title for the projects of the team section.',
      args: [],
    );
  }

  /// `Status`
  String get project_status {
    return Intl.message(
      'Status',
      name: 'project_status',
      desc: 'Column title for the project\'s status.',
      args: [],
    );
  }

  /// `Project Category`
  String get project_category {
    return Intl.message(
      'Project Category',
      name: 'project_category',
      desc: 'Column title for the project\'s category.',
      args: [],
    );
  }

  /// `Project Name`
  String get project_name {
    return Intl.message(
      'Project Name',
      name: 'project_name',
      desc: 'Column title for the project\'s name.',
      args: [],
    );
  }

  /// `An unknown error occurred`
  String get unknown_error_occurred {
    return Intl.message(
      'An unknown error occurred',
      name: 'unknown_error_occurred',
      desc: 'General unknown error message.',
      args: [],
    );
  }

  /// `No teams available`
  String get no_teams {
    return Intl.message(
      'No teams available',
      name: 'no_teams',
      desc: 'Error message when there are no teams.',
      args: [],
    );
  }

  /// `An unknown error occurred while updating the project`
  String get unknown_error_updating_project {
    return Intl.message(
      'An unknown error occurred while updating the project',
      name: 'unknown_error_updating_project',
      desc: 'Unknown error message specifically for project updates.',
      args: [],
    );
  }

  /// `No projects for this team`
  String get no_projects_for_this_team {
    return Intl.message(
      'No projects for this team',
      name: 'no_projects_for_this_team',
      desc: 'Message shown when a team has no associated projects.',
      args: [],
    );
  }

  /// `An unknown error occurred while updating the team member`
  String get unknown_error_updating_team_member {
    return Intl.message(
      'An unknown error occurred while updating the team member',
      name: 'unknown_error_updating_team_member',
      desc: 'Unknown error message specifically for team member updates.',
      args: [],
    );
  }

  /// `No teams roles`
  String get no_teams_roles {
    return Intl.message(
      'No teams roles',
      name: 'no_teams_roles',
      desc: 'Error message when there are no team roles.',
      args: [],
    );
  }

  /// `Add a residential neighborhood`
  String get AddResidentialNeighborhood {
    return Intl.message(
      'Add a residential neighborhood',
      name: 'AddResidentialNeighborhood',
      desc: 'Adding a residential neighborhood',
      args: [],
    );
  }

  /// `Name of residential neighborhood`
  String get ResidentialNeighborhoodName {
    return Intl.message(
      'Name of residential neighborhood',
      name: 'ResidentialNeighborhoodName',
      desc: 'Name of residential neighborhood',
      args: [],
    );
  }

  /// `Name of residential neighborhood manager`
  String get ResidentialNeighborhoodManagerName {
    return Intl.message(
      'Name of residential neighborhood manager',
      name: 'ResidentialNeighborhoodManagerName',
      desc: 'Name of residential neighborhood manager',
      args: [],
    );
  }

  /// `residential Neighborhood Options`
  String get residentialNeighborhoodOptions {
    return Intl.message(
      'residential Neighborhood Options',
      name: 'residentialNeighborhoodOptions',
      desc: 'residential neighborhood options',
      args: [],
    );
  }

  /// `Change Neighborhood Name`
  String get ChangeNeighborhoodName {
    return Intl.message(
      'Change Neighborhood Name',
      name: 'ChangeNeighborhoodName',
      desc: 'Change Neighborhood Name',
      args: [],
    );
  }

  /// `Change Neighborhood Manager Name`
  String get ChangeNeighborhoodManagerName {
    return Intl.message(
      'Change Neighborhood Manager Name',
      name: 'ChangeNeighborhoodManagerName',
      desc: 'Change Neighborhood Manager Name',
      args: [],
    );
  }

  /// `Neighborhoods`
  String get Neighborhoods {
    return Intl.message(
      'Neighborhoods',
      name: 'Neighborhoods',
      desc: 'Neighborhoods',
      args: [],
    );
  }

  /// `Units`
  String get Units {
    return Intl.message('Units', name: 'Units', desc: 'Units', args: []);
  }

  /// `Unit`
  String get Unit {
    return Intl.message('Unit', name: 'Unit', desc: 'Unit', args: []);
  }

  /// `Block`
  String get Block {
    return Intl.message('Block', name: 'Block', desc: 'Block', args: []);
  }

  /// `Blocks`
  String get Blocks {
    return Intl.message('Blocks', name: 'Blocks', desc: 'Blocks', args: []);
  }

  /// `residential units`
  String get residentialUnits {
    return Intl.message(
      'residential units',
      name: 'residentialUnits',
      desc: 'residential units',
      args: [],
    );
  }

  /// `There is no manager`
  String get noManager {
    return Intl.message(
      'There is no manager',
      name: 'noManager',
      desc: 'There is no manager',
      args: [],
    );
  }

  /// `...looking for a residential neighborhood`
  String get lookingNeighborhood {
    return Intl.message(
      '...looking for a residential neighborhood',
      name: 'lookingNeighborhood',
      desc: '...looking for a residential neighborhood',
      args: [],
    );
  }

  /// `...looking for a residential unit`
  String get lookingunit {
    return Intl.message(
      '...looking for a residential unit',
      name: 'lookingunit',
      desc: '...looking for a residential unit',
      args: [],
    );
  }

  /// `Add a residential unit`
  String get AddResidentialUnit {
    return Intl.message(
      'Add a residential unit',
      name: 'AddResidentialUnit',
      desc: 'Adding a residential unit',
      args: [],
    );
  }

  /// `Name of residential unit`
  String get ResidentialUnitName {
    return Intl.message(
      'Name of residential unit',
      name: 'ResidentialUnitName',
      desc: 'Name of residential unit',
      args: [],
    );
  }

  /// `Choose Neighborhood`
  String get chooseNeighborhood {
    return Intl.message(
      'Choose Neighborhood',
      name: 'chooseNeighborhood',
      desc: 'Choose neighborhood label',
      args: [],
    );
  }

  /// `Search for a neighborhood...`
  String get searchNeighborhoodHint {
    return Intl.message(
      'Search for a neighborhood...',
      name: 'searchNeighborhoodHint',
      desc: 'Search neighborhood hint',
      args: [],
    );
  }

  /// `residential units options`
  String get residentialUnitsOptions {
    return Intl.message(
      'residential units options',
      name: 'residentialUnitsOptions',
      desc: 'residential units options',
      args: [],
    );
  }

  /// `Change Unit Name`
  String get ChangeUnitName {
    return Intl.message(
      'Change Unit Name',
      name: 'ChangeUnitName',
      desc: 'Change Unit Name',
      args: [],
    );
  }

  /// `Change Unit Manager Name`
  String get ChangeUnitManagerName {
    return Intl.message(
      'Change Unit Manager Name',
      name: 'ChangeUnitManagerName',
      desc: 'Change Unit Manager Name',
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
