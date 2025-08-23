import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';
import '../../generated/l10n.dart';

extension ContextExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  Orientation get screenOrientation => MediaQuery.orientationOf(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  AppLocalizations get locale => AppLocalizations.of(this);

  Object? get routeArguments => ModalRoute.of(this)?.settings.arguments;

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showErrorSnackBar(String error) {
    _showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1000),
        content: Text(error),
        backgroundColor: AppColor.danger,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    _showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColor.success),
    );
  }

  static bool _isLoading = false;

  void showLoadingDialog([bool isDismissible = true]) {
    if (_isLoading) return;
    showAdaptiveDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: isDismissible,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              _isLoading = false;
            }
          },
          // onPopInvoked: (didPop) {
          //   if (didPop) _isLoading = false;
          // },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
    _isLoading = true;
  }

  void showErrorDialog(void Function() providerInvalidated) {
    showAdaptiveDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog.adaptive(
        // title: Text(
        //   locale.error,
        //   style: const TextStyle(fontFamily: FontFamily.expoArabic),
        // ),
        content: Text(
          'locale.somethingWentWrong',
          // style: const TextStyle(fontFamily: FontFamily.expoArabic),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'locale.retry',
              style: const TextStyle(color: Color(0xff007AFF)),
            ),
            onPressed: () {
              providerInvalidated();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showBottomSheet(Widget widget) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(child: widget),
      ),
    );
  }

  void showCustomDialog(Widget widget, {bool isDismissible = true}) {
    showAdaptiveDialog(
      context: this,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(padding: const EdgeInsets.all(16.0), child: widget),
      ),
    );
  }

  Future<bool?> showAlertDialog() {
    return showAdaptiveDialog<bool?>(
      context: this,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog.adaptive(
        title: const SizedBox.shrink(),
        content: Text(
          'هل أنت متأكد من القيام بهذه العملية؟',
          style: const TextStyle(fontFamily: 'Expo Arabic'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'الغاء',
              style: const TextStyle(color: Color(0xff007AFF)),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(
              'نعم',
              style: const TextStyle(color: Color(0xff007AFF)),
            ),
            onPressed: () {
              Navigator.of(context).pop(true); // Return 'true' when signed out
            },
          ),
        ],
      ),
    );
  }

  void showMaterialBanner(String message) {
    ScaffoldMessenger.of(this).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        actions: [
          TextButton(
            child: Text(
              'this.locale.yes',
              style: const TextStyle(color: Color(0xff007AFF)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(this).hideCurrentMaterialBanner();
            },
          ),
        ],
      ),
    );
  }
}
