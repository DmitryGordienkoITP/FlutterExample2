import 'package:flutter/material.dart';

import '../../../presentation/themes/palette.dart';
import '../enums/delivery_status_type.dart';

extension DeliveryStatusTypeExtension on DeliveryStatusType {
  static const Map<DeliveryStatusType, String> _ruLabels = {
    DeliveryStatusType.inQueue: 'В очереди',
    DeliveryStatusType.processing: 'Выполняется',
    DeliveryStatusType.canceled: 'Отменен',
    DeliveryStatusType.done: 'Выполнен',
    DeliveryStatusType.warning: 'Внимание',
    DeliveryStatusType.error: 'Ошибка',
  };

  static const Map<DeliveryStatusType, Color> _colors = {
    DeliveryStatusType.inQueue: AppPalette.statusColorInQueue,
    DeliveryStatusType.processing: AppPalette.statusColorProcessing,
    DeliveryStatusType.canceled: AppPalette.statusColorCanceled,
    DeliveryStatusType.done: AppPalette.statusColorDone,
    DeliveryStatusType.warning: AppPalette.statusColorWarning,
    DeliveryStatusType.error: AppPalette.statusColorError,
  };

  DeliveryStatusType _overrideStatus(DeliveryStatusType status) {
    var value = status;
    if (index == DeliveryStatusType.inQueue.index) {
      value = DeliveryStatusType.processing;
    } else if (index == DeliveryStatusType.warning.index) {
      value = DeliveryStatusType.error;
    }
    return value;
  }

  String get ruString {
    var value = _overrideStatus(this);
    return _ruLabels[value] ?? 'Ошибка';
  }

  Color get color {
    var value = _overrideStatus(this);
    return _colors[value] ?? const Color.fromRGBO(0x88, 0x88, 0x88, 0.8);
  }

  bool get isMuted {
    switch (this) {
      case DeliveryStatusType.inQueue:
      case DeliveryStatusType.processing:
      case DeliveryStatusType.canceled:
        return true;
      case DeliveryStatusType.done:
      case DeliveryStatusType.warning:
      case DeliveryStatusType.error:
        return false;
    }
  }
}
