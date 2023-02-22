import 'package:flutter/material.dart';

import '../themes/palette.dart';

class AppLabel extends StatelessWidget {
  final bool marked;
  final String text;
  const AppLabel(this.text, {this.marked = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: const TextStyle(color: AppPalette.gray1)),
        if (marked) buildMark(),
      ],
    );
  }

  Row buildMark() {
    return Row(children: const [
      SizedBox(width: 5),
      Text('*', style: TextStyle(color: AppPalette.red)),
    ]);
  }
}
