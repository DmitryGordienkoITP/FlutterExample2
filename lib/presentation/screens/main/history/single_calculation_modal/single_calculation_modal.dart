import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/common/enums/basis_filter_options.dart';
import '../../../../../core/common/enums/delivery_status_type.dart';
import '../../../../../core/common/helpers/date_helper.dart';
import '../../../../../core/common/helpers/toast_helper.dart';
import '../../../../../core/services/delivery_service.dart';
import '../../../../../data/models/delivery_model.dart';
import '../../../../shared/app_divider.dart';
import '../../../../shared/app_dropdown_button.dart';
import '../../../../shared/custom_app_bar.dart';
import '../../../../shared/delivery_status_indicator.dart';
import '../../../../shared/loading_indicator.dart';
import '../../../../themes/palette.dart';
import '../../../../themes/styles/app_text_styles.dart';
import '../../../../themes/styles/appbar_styles.dart';
import 'widgets/delivery_option_card.dart';
import 'widgets/delivery_status_placeholder.dart';
import 'widgets/options_amount_label.dart';

part 'single_calculation_modal_view_model.dart';

class SingleCalculationModal extends StatelessWidget {
  const SingleCalculationModal({Key? key}) : super(key: key);

  static Widget create(void Function(DeliveryModel) repeateCalculationHandler,
      DeliveryModel delivery) {
    return ChangeNotifierProvider(
      create: (_) =>
          SingleCalculationModalViewModel(repeateCalculationHandler, delivery),
      child: const SingleCalculationModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final delivery =
        context.read<SingleCalculationModalViewModel>().state.delivery;
    final deliveryCreatedAt =
        DateHelper.getShortFormatedDateWithTime(delivery.createdAt);

    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          await context
              .read<SingleCalculationModalViewModel>()
              .deliveriesSub
              .cancel();
          return true;
        },
        child: Scaffold(
          backgroundColor: AppPalette.gray5,
          appBar: CustomAppBar(
            centerTitle: true,
            title: Text('Расчет от $deliveryCreatedAt',
                style: AppBarStyles.subScreenTitle()),
            actions: [
              if (delivery.deliveryStatus != DeliveryStatusType.error)
                const _PopupMenuWidget(),
            ],
          ),
          body: Consumer<SingleCalculationModalViewModel>(
            builder: (context, vm, _) => vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: const [
                      _Header(),
                      AppDivider(),
                      _Details(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final delivery =
        context.watch<SingleCalculationModalViewModel>().state.delivery;
    final status = delivery.deliveryStatus;
    final hasNoOptions = status != DeliveryStatusType.done &&
        status != DeliveryStatusType.warning;

    return Expanded(
      child: hasNoOptions
          ? buildShortDetails(delivery)
          : buildFullDetails(delivery),
    );
  }

  Widget buildShortDetails(DeliveryModel delivery) {
    return Column(
      children: [
        const _BaseInfo(),
        const AppDivider(),
        if (delivery.deliveryStatus == DeliveryStatusType.error)
          _ErrorMessage(delivery.errorDescription),
        DeliveryStatusPlaceholder(delivery.deliveryStatus),
      ],
    );
  }

  Widget buildFullDetails(DeliveryModel delivery) {
    return Scrollbar(
      thickness: 6,
      thumbVisibility: true,
      child: ListView(
        primary: true,
        children: [
          const _BaseInfo(),
          const AppDivider(),
          OptionsAmountLabel(delivery.options?.length ?? 0),
          const _OptionsList(),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String? message;
  const _ErrorMessage(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Center(
        child: Text(
          message ?? 'Неизвестная ошибка',
          style: AppTextStyles.bodySM.copyWith(color: AppPalette.red),
        ),
      ),
    );
  }
}

class _PopupMenuWidget extends StatelessWidget {
  const _PopupMenuWidget({
    Key? key,
  }) : super(key: key);

  bool isRepeateItemAvailable(DeliveryStatusType status) {
    return status == DeliveryStatusType.canceled ||
        status == DeliveryStatusType.done ||
        status == DeliveryStatusType.warning;
  }

  bool isCancelItemAvailable(DeliveryStatusType status) {
    return status == DeliveryStatusType.inQueue ||
        status == DeliveryStatusType.processing;
  }

  bool isPdfItemAvailable(DeliveryStatusType status) {
    return status == DeliveryStatusType.done ||
        status == DeliveryStatusType.warning;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SingleCalculationModalViewModel>();
    final delivery = vm.state.delivery;
    return PopupMenuButton(
      onSelected: (value) => vm.onPopupMenuAction(context, value),
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.menu),
      itemBuilder: (_) => [
        if (isRepeateItemAvailable(delivery.deliveryStatus))
          const PopupMenuItem(
            value: PopupMenuOptions.repeateCalculation,
            child: Text('Повторить расчет'),
          ),
        if (isPdfItemAvailable(delivery.deliveryStatus))
          const PopupMenuItem(
            value: PopupMenuOptions.sendPDF,
            child: Text('Отправить как PDF'),
          ),
        if (isCancelItemAvailable(delivery.deliveryStatus))
          const PopupMenuItem(
            value: PopupMenuOptions.cancel,
            child: Text('Отменить'),
          ),
      ],
    );
  }
}

class _BaseInfo extends StatelessWidget {
  const _BaseInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SingleCalculationModalViewModel>();
    final delivery = vm.state.delivery;
    const textStyle = AppTextStyles.bodySM;
    final mainStyle = textStyle.copyWith(color: AppPalette.black);
    final titleStyle = textStyle.copyWith(color: AppPalette.textLineTitle);
    final formatedDate = DateHelper.getFormatedDate(delivery.departureDate);
    return Container(
      color: AppPalette.white,
      width: double.maxFinite,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Дата отправки: ', style: titleStyle),
                Text(formatedDate, style: mainStyle),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Завод: ', style: titleStyle),
                  TextSpan(
                    text: delivery.factory?.name ?? 'Не выбран',
                    style: mainStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Станции перевалки: ', style: titleStyle),
                  TextSpan(
                      text: delivery.transshipmentsString, style: mainStyle),
                ],
              ),
            ),
            if (delivery.deliveryStatus == DeliveryStatusType.done)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Базис поставки: ', style: titleStyle),
                    AppDropdownButton<BasisFilterOptions>(
                      titles: const [
                        'По РФ',
                        'По РФ + 1 страна',
                        'По РФ + 2 страны',
                        'По РФ + 3 страны',
                      ],
                      value: vm.state.basisFilter,
                      values: BasisFilterOptions.values.toList(),
                      onChanged: vm.onFilterChange,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SingleCalculationModalViewModel>();
    final delivery = vm.state.delivery;
    final destinationString =
        '${delivery.destinationStation.name} (${delivery.destinationStation.country!.name})';
    return Container(
      color: AppPalette.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery.product.publicName,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(destinationString, style: AppTextStyles.bodySM),
              ],
            ),
          ),
          const Spacer(),
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 90),
              child: DeliveryStatusIndicator(delivery)),
        ],
      ),
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SingleCalculationModalViewModel>();
    final options = vm.state.delivery.options;
    return vm.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: options?.length ?? 0,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: DeliveryOptionCard(options![index], index),
                    )),
          );
  }
}
