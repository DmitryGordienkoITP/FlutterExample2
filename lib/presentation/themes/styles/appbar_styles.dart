import 'package:flutter/material.dart';

abstract class AppBarStyles {
  static TextStyle mainScreenTitle() => const TextStyle(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle subScreenTitle() => const TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontWeight: FontWeight.w600,
      );
}
