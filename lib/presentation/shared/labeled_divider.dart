import 'package:flutter/material.dart';

import '../themes/palette.dart';

class LabeledDivider extends StatelessWidget {
  final String label;
  const LabeledDivider(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        const _Line(),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const _Line(),
        const Spacer(),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 1,
        width: 24,
        color: AppPalette.black,
      ),
    );
  }
}
