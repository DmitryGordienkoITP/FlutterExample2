import 'package:flutter/material.dart';

import '../../../../../../core/common/enums/delivery_status_type.dart';

class DeliveryStatusPlaceholder extends StatelessWidget {
  final DeliveryStatusType status;
  const DeliveryStatusPlaceholder(
    this.status, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox.shrink();
    final iconSize = MediaQuery.of(context).size.width / 3;

    switch (status) {
      case DeliveryStatusType.inQueue:
      case DeliveryStatusType.processing:
        body = Icon(Icons.hourglass_top_rounded, size: iconSize);
        break;
      case DeliveryStatusType.canceled:
        body = Icon(Icons.cancel_outlined, size: iconSize);
        break;
      case DeliveryStatusType.done:
        // Ignore case
        break;
      case DeliveryStatusType.warning:
        // Ignore case
        break;
      case DeliveryStatusType.error:
        body = Icon(Icons.error_outline, size: iconSize);
        break;
      default:
    }

    return Expanded(
      child: Center(
        child: Opacity(
          opacity: 0.05,
          child: body,
        ),
      ),
    );
  }
}
