import 'package:flutter/material.dart';

import '../../core/common/const/text_constants.dart';

class LegalsScreen extends StatelessWidget {
  static const routeName = "/legals";
  const LegalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_left, size: 32),
          ),
          title: const Text("Конфиденциальность"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(child: Text(TextConstants.legalsText)),
        ),
      ),
    );
  }
}
