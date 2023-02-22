import 'package:flutter/material.dart';

import '../../../../../core/common/helpers/date_helper.dart';
import '../../../../../data/models/delivery_model.dart';
import '../../../../shared/app_card.dart';
import '../../../../shared/delivery_status_indicator.dart';
import '../../../../themes/palette.dart';
import '../../../../themes/styles/app_text_styles.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;
  final Function onTap;

  const DeliveryCard(this.delivery, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductName(),
          buildStationName(),
          const SizedBox(height: 8),
          buildDetails()
        ],
      ),
    );
  }

  Text buildProductName() {
    return Text(delivery.product.publicName,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600));
  }

  Text buildStationName() {
    return Text(
      delivery.destinationStation.name,
      style: AppTextStyles.bodySM,
    );
  }

  Row buildDetails() {
    final style = AppTextStyles.bodySM.copyWith(color: AppPalette.gray1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateHelper.getShortFormatedDateWithTime(delivery.createdAt),
          style: style,
        ),
        DeliveryStatusIndicator(delivery),
      ],
    );
  }
}
