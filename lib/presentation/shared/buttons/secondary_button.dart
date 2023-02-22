import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Widget title;
  final Function? onPressed;
  const SecondaryButton({
    required this.title,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) onPressed!();
      },
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
      )),
      child: title,
    );
  }
}
