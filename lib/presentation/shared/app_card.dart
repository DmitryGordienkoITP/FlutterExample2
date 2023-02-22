import 'package:flutter/material.dart';

import '../themes/styles/app_theme.dart';

// ignore: must_be_immutable
class AppCard extends StatelessWidget {
  Function? onTap;
  Widget child;
  BoxDecoration? cardDecoration;

  AppCard({required this.child, this.cardDecoration, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration ?? AppTheme.appCardDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap != null ? () => onTap!() : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
      ),
    );
  }
}
