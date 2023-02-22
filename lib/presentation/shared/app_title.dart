import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final double textSize;
  const AppTitle({
    required this.title,
    this.textAlign = TextAlign.start,
    this.textSize = 22,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
