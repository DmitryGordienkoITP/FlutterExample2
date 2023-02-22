import 'package:flutter/material.dart';

import '../palette.dart';

abstract class AppTheme {
  static ThemeData get main => ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 0xF9, 0xF9, 0xF9),
        primarySwatch: AppPalette.swatchPalette,
      );

  static RoundedRectangleBorder get cardShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          width: 0.5,
          color: Color.fromRGBO(0xE5, 0xE5, 0xE5, 1),
        ),
      );

  static BoxDecoration get appCardDecoration => BoxDecoration(
        color: AppPalette.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: AppPalette.gray4,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0x8E, 0x8E, 0x93, 0.12),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      );
}
