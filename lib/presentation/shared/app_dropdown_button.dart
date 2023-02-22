import 'package:flutter/material.dart';

import '../themes/palette.dart';
import '../themes/styles/app_text_styles.dart';

class AppDropdownButton<T> extends StatefulWidget {
  T value;
  final List<T> values;
  final List<String> titles;
  final Function onChanged;

  AppDropdownButton({
    super.key,
    required this.titles,
    required this.onChanged,
    required this.values,
    required this.value,
  }) : assert(titles.length == values.length);

  @override
  State<AppDropdownButton<T>> createState() => _AppDropdownButtonState<T>();
}

class _AppDropdownButtonState<T> extends State<AppDropdownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      //margin: const EdgeInsets.only(bottom: 16),
      height: 33,
      decoration: BoxDecoration(
          color: AppPalette.gray4, borderRadius: BorderRadius.circular(4)),
      child: DropdownButton(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppPalette.gray2,
          size: 24,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        underline: const SizedBox.shrink(),
        items: buildMenuItems(),
        value: widget.value,
        onChanged: (value) {
          widget.value = value;
          widget.onChanged(value);
          setState(() {});
        },
      ),
    );
  }

  List<DropdownMenuItem> buildMenuItems() {
    final List<DropdownMenuItem> result = [];

    for (var i = 0; i < widget.values.length; i++) {
      final buttonWidget = DropdownMenuItem(
        value: widget.values[i],
        child: Text(widget.titles[i],
            style: widget.value == widget.values[i]
                ? AppTextStyles.bodySM
                : AppTextStyles.bodySM.copyWith(fontWeight: FontWeight.w300)),
      );
      result.add(buttonWidget);
    }
    return result;
  }
}
