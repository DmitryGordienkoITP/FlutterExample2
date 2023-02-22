import 'package:flutter/material.dart';

import '../../themes/palette.dart';

class PrimaryButton extends StatelessWidget {
  final Widget title;
  final Function? onPressed;
  final bool disabled;
  const PrimaryButton({
    required this.title,
    this.onPressed,
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              if (disabled) return;
              if (onPressed != null) onPressed!();
            },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppPalette.white,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        minimumSize: const Size.fromHeight(48),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
      child: title,
    );
  }
}
