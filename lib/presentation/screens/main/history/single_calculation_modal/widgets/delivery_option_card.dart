import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/common/enums/basis_filter_options.dart';
import '../../../../../../core/common/helpers/money_helper.dart';
import '../../../../../../data/models/delivery_option_model.dart';
import '../../../../../../data/models/route_segment_model.dart';
import '../../../../../themes/palette.dart';
import '../../../../../themes/styles/app_text_styles.dart';
import '../../../../../themes/styles/app_theme.dart';
import '../single_calculation_modal.dart';

class DeliveryOptionCard extends StatefulWidget {
  const DeliveryOptionCard(this.deliveryOption, this.index, {Key? key})
      : super(key: key);

  final DeliveryOptionModel deliveryOption;
  final int index;

  @override
  State<DeliveryOptionCard> createState() => _DeliveryOptionCardState();
}

class _DeliveryOptionCardState extends State<DeliveryOptionCard> {
  bool _isExpanded = false;
  final List<RouteSegment> _routeSegments = [];

  initRouteSegments(BasisFilterOptions filter) {
    final option = widget.deliveryOption;
    _routeSegments.clear();
    final foreignRouteDepth = filter.index + 1;
    _routeSegments
        .addAll(option.details1?.routeSegments.take(foreignRouteDepth) ?? []);
    _routeSegments.addAll(option.details2?.routeSegments ?? []);
  }

  double getTotalPrice(BasisFilterOptions filter) {
    //widget.deliveryOption.transshipment?.
    return _routeSegments.map((item) => item.tariff).reduce((a, b) => a + b);
  }

  int getTotalDuration(BasisFilterOptions filter) {
    return _routeSegments
        .map((item) => item.ladenDuration)
        .reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SingleCalculationModalViewModel>();
    initRouteSegments(vm.state.basisFilter);
    final option = widget.deliveryOption;
    final totalPrice = getTotalPrice(vm.state.basisFilter);
    final formatedPrice = '${MoneyHelper.format(totalPrice)} руб.';
    final totalDuration = getTotalDuration(vm.state.basisFilter);
    return Container(
      decoration: option.isFailed
          ? AppTheme.appCardDecoration.copyWith(
              border: Border.all(width: 1, color: AppPalette.redMuted))
          : AppTheme.appCardDecoration,
      child: Stack(
        children: [
          Positioned(top: 5, right: 5, child: buildIndex()),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              option.isFailed ? 16 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                option.isFailed
                    ? buildErrorLine()
                    : buildInfoLine('Итого:', formatedPrice, primary: true),
                buildInfoLine('Завод:', option.factory.name),
                buildInfoLine('Станция отп.:', option.departure.name),
                if (_isExpanded) ...[
                  buildInfoLine('Стоимость груза:', '%ЗНАЧЕНИЕ%'),
                  //buildInfoLine('Дата цены:', '%ЗНАЧЕНИЕ%'),
                  buildInfoLine(
                    'Станция перелома:',
                    option.transshipment?.name ?? 'Нет',
                  ),
                  buildInfoLine('Срок доставки:', '$totalDuration дней'),
                  buildInfoLine('Составляющие маршрута:', ''),
                  buildRoute(option, vm.state.basisFilter),
                ],
                if (!option.isFailed) buildExpandButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoute(DeliveryOptionModel option, BasisFilterOptions filter) {
    final foreignRouteDepth = filter.index + 1;
    final List<RouteSegment> routeSegments = [];
    routeSegments
        .addAll(option.details1?.routeSegments.take(foreignRouteDepth) ?? []);
    routeSegments.addAll(option.details2?.routeSegments ?? []);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: routeSegments
            .map((segment) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '${segment.country.name} (тариф: ${MoneyHelper.format(segment.tariff)} руб., ${segment.ladenDuration} дней)',
                    style: AppTextStyles.bodySM,
                  ),
                ))
            .toList());
  }

  Widget buildExpandButton() {
    return GestureDetector(
      onTap: () {
        _isExpanded = !_isExpanded;
        setState(() {});
      },
      child: SizedBox(
        height: 32,
        child: Center(
          child: _isExpanded
              ? const Icon(Icons.keyboard_arrow_up, color: AppPalette.gray2)
              : const Icon(Icons.keyboard_arrow_down, color: AppPalette.gray2),
        ),
      ),
    );
  }

  Widget buildErrorLine() {
    return Text(
      'Не удалось расчитать',
      style: AppTextStyles.bodySM.copyWith(color: AppPalette.red),
    );
  }

  Widget buildInfoLine(String title, String value, {bool primary = false}) {
    final titleStyle = primary
        ? AppTextStyles.body.copyWith(color: AppPalette.black)
        : AppTextStyles.bodySM.copyWith(color: AppPalette.gray1);

    final valueStyle = primary
        ? AppTextStyles.body
            .copyWith(color: AppPalette.black, fontWeight: FontWeight.w500)
        : AppTextStyles.bodySM.copyWith(color: AppPalette.black);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: '$title ', style: titleStyle),
            TextSpan(text: value, style: valueStyle),
          ],
        ),
      ),
    );
  }

  Widget buildIndex() {
    return Text(
      '${widget.index + 1}',
      style: const TextStyle(color: AppPalette.gray2, fontSize: 15, height: 1),
    );
  }
}
