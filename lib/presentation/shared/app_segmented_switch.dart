import 'package:flutter/cupertino.dart';

import '../themes/palette.dart';
import '../themes/styles/app_text_styles.dart';

class AppSegmentedSwitch<T> extends StatelessWidget {
  final T? groupValue;
  final bool enabled;
  final List<T> values;
  final List<String> titles;
  final Function(T?) onValueChanged;
  const AppSegmentedSwitch({
    super.key,
    this.groupValue,
    this.enabled = true,
    required this.titles,
    required this.onValueChanged,
    required this.values,
  }) : assert(titles.length == values.length);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: CupertinoSlidingSegmentedControl(
        backgroundColor: AppPalette.gray4,
        //thumbColor: CupertinoColors.activeGreen,
        thumbColor: enabled ? AppPalette.accentGreen : AppPalette.gray4,
        //padding: const EdgeInsets.all(8),
        groupValue: groupValue,
        children: buildValues(),
        onValueChanged: onValueChanged,
      ),
    );
  }

  Map<T, Widget> buildValues() {
    final Map<T, Widget> result = {};
    for (var i = 0; i < values.length; i++) {
      result[values[i]] = buildSegment(
        titles[i],
        groupValue == values[i],
      );
    }
    return result;
  }

  Widget buildSegment(String text, bool active) {
    final textStyle = active
        ? AppTextStyles.bodySM
            .copyWith(color: enabled ? AppPalette.white : AppPalette.gray2)
        : AppTextStyles.bodySM
            .copyWith(color: enabled ? AppPalette.black : AppPalette.gray2);
    return SizedBox(
      width: double.maxFinite,
      height: 32,
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
