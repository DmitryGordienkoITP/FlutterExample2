import 'package:flutter/material.dart';

import '../themes/palette.dart';

class ScreenElement extends StatelessWidget {
  final Widget child;
  const ScreenElement({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppPalette.widgetBorder),
        ),
      ),
      child: child,
    );
  }
}
