import 'package:flutter/material.dart';

import '../themes/palette.dart';
import '../themes/styles/app_text_styles.dart';

class EmptyListPlaceholder extends StatelessWidget {
  final String message;

  const EmptyListPlaceholder(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.disabled_by_default_outlined,
            size: width / 4,
            color: AppPalette.gray4,
          ),
          const SizedBox(height: 32),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: AppPalette.gray2,
            ),
          ),
        ],
      ),
    );
  }
}
