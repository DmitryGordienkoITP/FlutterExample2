import 'package:flutter/material.dart';

import '../../core/common/extensions/delivery_status_type_extension.dart';
import '../../data/models/delivery_model.dart';

class DeliveryStatusIndicator extends StatelessWidget {
  final DeliveryModel item;
  const DeliveryStatusIndicator(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final foregroundColor = item.deliveryStatus.color;
    final backgroundColor = item.deliveryStatus.color.withOpacity(0.2);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          item.deliveryStatus.ruString,
          style: TextStyle(color: foregroundColor, fontSize: 12),
        ),
      ),
    );
  }
}
