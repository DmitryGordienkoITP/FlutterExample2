import 'package:flutter/material.dart';

import '../themes/palette.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 1,
      color: AppPalette.gray3,
    );
  }
}
