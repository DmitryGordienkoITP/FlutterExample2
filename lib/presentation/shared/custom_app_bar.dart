import 'package:flutter/material.dart';

import '../themes/palette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  const CustomAppBar(
      {this.title, this.centerTitle = false, super.key, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      title: title,
      centerTitle: centerTitle,
      elevation: 0,
      foregroundColor: AppPalette.white,
    );
  }
}
