import 'package:flutter/material.dart';

import '../palette.dart';

abstract class AppTextStyles {
  static const title2 = TextStyle(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w400,
    color: AppPalette.black,
  );

  static const body = TextStyle(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    color: AppPalette.black,
  );

  static const bodySM = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
    color: AppPalette.black,
  );

  static const bodySx = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: AppPalette.black,
  );
}
