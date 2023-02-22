import 'package:oktoast/oktoast.dart';

import '../../../presentation/themes/palette.dart';

abstract class ToastHelper {
  static showAppToast(
    String msg, {
    ToastPosition position = ToastPosition.bottom,
  }) {
    showToast(
      msg,
      position: position,
      duration: const Duration(seconds: 3),
      backgroundColor: AppPalette.accentGreen,
    );
  }

  static showErrorToast(String msg) {
    showToast(
      msg,
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
      backgroundColor: AppPalette.red,
    );
  }
}
