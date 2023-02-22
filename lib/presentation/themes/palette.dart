import 'package:flutter/material.dart';

abstract class AppPalette {
  static const MaterialColor swatchPalette = MaterialColor(
    0xFF006A6A, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFF00ABAB), //10%
      100: Color(0xFF009F9F), //20%
      200: Color(0xFF009191), //30%
      300: Color(0xFF008585), //40%
      400: Color(0xFF007878), //50%

      /// default shade
      500: Color(0xFF006A6A), //60%

      600: Color(0xFF005f5f), //70%
      700: Color(0xFF005151), //80%
      800: Color(0xFF004444), //90%
      900: Color(0xFF003838), //100%
    },
  );

  /// Base application colors
  static const accentGreen = Color.fromRGBO(0x00, 0x6A, 0x6A, 1);
  static const mutedGreen = Color.fromRGBO(0x00, 0x6A, 0x6A, 0.5);
  static const red = Color.fromRGBO(0xFF, 0x3D, 0x30, 1);
  static const redMuted = Color.fromRGBO(0xFF, 0x9D, 0x98, 1);
  static const black = Color.fromRGBO(0x1C, 0x1C, 0x1E, 1);
  static const white = Color.fromRGBO(0xFF, 0xFF, 0xFF, 1);

  static const gray1 = Color.fromRGBO(0x8E, 0x8E, 0x93, 1);
  static const gray2 = Color.fromRGBO(0xD3, 0xD3, 0xD6, 1);
  static const gray3 = Color.fromRGBO(0xE5, 0xE5, 0xEA, 1);
  static const gray4 = Color.fromRGBO(0xEE, 0xEE, 0xEF, 1);
  static const gray5 = Color.fromRGBO(0xF9, 0xF9, 0xF9, 1);

  static const appInvisible = Color.fromRGBO(0x00, 0x00, 0x00, 0);

  /// Delivery Status
  static const statusColorUnknown = Color.fromRGBO(0x88, 0x88, 0x88, 0.8);
  static const statusColorProcessing = Color.fromRGBO(0xFF, 0x95, 0x00, 0.8);
  static const statusColorInQueue = statusColorProcessing;
  static const statusColorCanceled = Color.fromRGBO(0x8e, 0x8e, 0x93, 0.8);
  static const statusColorDone = Color.fromRGBO(0x34, 0xC7, 0x59, 0.8);
  static const statusColorError = Color.fromRGBO(0xFF, 0x3B, 0x30, 0.8);
  static const statusColorWarning = statusColorError;

  /// Widget parts
  static const textLineTitle = gray1;
  static const textMain = Color.fromRGBO(0x1C, 0x1C, 0x1E, 1);
  static const widgetBorder = gray3;
}
