import 'package:flutter/material.dart';

class CustomTitledControl extends StatefulWidget {
  final Widget ctrl;
  final String title;
  final int flexTitle;
  final int flexCtrl;
  const CustomTitledControl({
    super.key,
    required this.title,
    required this.ctrl,
    this.flexTitle = 1,
    this.flexCtrl = 1,
  });

  @override
  State<CustomTitledControl> createState() => _CustomTitledControlState();
}

class _CustomTitledControlState extends State<CustomTitledControl> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: widget.flexTitle,
          child: Text(
            widget.title,
          ),
        ),
        Expanded(
          flex: widget.flexCtrl,
          child: widget.ctrl,
        ),
      ],
    );
  }
}
