import 'package:flutter/material.dart';

import '../../data/models/station_model.dart';
import '../themes/palette.dart';
import '../themes/styles/app_text_styles.dart';

class StationListItem extends StatelessWidget {
  const StationListItem(
    this.station, {
    Key? key,
  }) : super(key: key);

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(station.name, style: AppTextStyles.bodySM),
          const SizedBox(height: 2),
          Text(
            station.country!.name,
            style: AppTextStyles.bodySM.copyWith(
              color: AppPalette.gray1,
            ),
          ),
        ],
      ),
    );
  }
}
