import 'package:flutter/material.dart';

import '../../../../../themes/palette.dart';
import '../../../../../themes/styles/app_text_styles.dart';

class OptionsAmountLabel extends StatelessWidget {
  final int amount;
  const OptionsAmountLabel(
    this.amount, {
    Key? key,
  }) : super(key: key);

  String buildString(int n) {
    var result = '';
    if (n == 1) {
      result = 'Найден 1 вариант';
    } else if (n > 1 && n < 5) {
      result = 'Найдено $n варианта';
    } else {
      result = 'Найдено $n вариантов';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          buildString(amount),
          style: AppTextStyles.bodySx.copyWith(color: AppPalette.gray1),
        ),
      ),
    );
  }
}
