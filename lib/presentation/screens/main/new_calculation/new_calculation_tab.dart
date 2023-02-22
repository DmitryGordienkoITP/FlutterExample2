import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/enums/tabs/main_tabs.dart';
import '../../../../core/common/enums/transhipment_selection_type.dart';
import '../../../../core/common/helpers/date_helper.dart';
import '../../../../core/common/helpers/money_helper.dart';
import '../../../../core/services/delivery_service.dart';
import '../../../../data/models/delivery_model.dart';
import '../../../../data/models/factory_model.dart';
import '../../../../data/models/factory_product_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/station_model.dart';
import '../../../shared/app_label.dart';
import '../../../shared/app_segmented_switch.dart';
import '../../../shared/buttons/primary_button.dart';
import '../../../shared/custom_app_bar.dart';
import '../../../shared/inputs/external_source_input.dart';
import '../../../shared/screen_element.dart';
import '../../../themes/styles/appbar_styles.dart';
import 'modals/departure_station_selection_modal.dart';
import 'modals/destination_station_selection_modal.dart';
import 'modals/factory_selection_modal.dart';
import 'modals/product_selection_modal.dart';
import 'modals/transshipment_station_selection_modal.dart';

part 'new_calculation_tab_view_model.dart';

class NewCalculationTab extends StatelessWidget {
  //static const routeName = "/new-calc";
  const NewCalculationTab({Key? key}) : super(key: key);

  static Widget create(void Function(MainTabs) tabsHandler,
      {DeliveryModel? template}) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(tabsHandler, template: template),
      child: const NewCalculationTab(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar(
            centerTitle: true,
            title: Text('Новый Расчет', style: AppBarStyles.mainScreenTitle()),
          ),
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 18),
                    const _DateSelector(),
                    const _ProductSelector(),
                    const _FactorySelector(),
                    const _DepartureStationSelector(),
                    const _TargetStationSelector(),
                    const _TransshipmentStationsBlock(),
                  ],
                ),
              ),
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _SubmitFormButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitFormButton extends StatelessWidget {
  const _SubmitFormButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(15),
          child: PrimaryButton(
            disabled: !vm.isSubmitAllowed,
            title: const Text('Рассчитать'),
            onPressed: vm.submitForm,
          ),
        ),
      ],
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    vm.state.dateController.text = DateHelper.getFormatedDate(vm.state.date);
    return ScreenElement(
      child: ExternalSourceInput(
        label: const AppLabel("Дата отправления груза"),
        controller: vm.state.dateController,
        onTap: () => vm.selectDate(context),
        onAction: () => vm.selectDate(context),
      ),
    );
  }
}

class _ProductSelector extends StatelessWidget {
  const _ProductSelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return ScreenElement(
      child: ExternalSourceInput(
        clearable: true,
        label: const AppLabel('Груз', marked: true),
        controller: vm.state.productController,
        onTap: () => vm.selectProduct(context),
        onAction: () => vm.selectProduct(context),
        onReset: vm.resetProductAndFactory,
      ),
    );
  }
}

class _FactorySelector extends StatelessWidget {
  const _FactorySelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return ScreenElement(
      child: ExternalSourceInput(
        enabled: vm.isFactorySelectorAllowed,
        clearable: true,
        label: const AppLabel("Завод"),
        controller: vm.state.factoryController,
        onTap: () => vm.selectFactory(context),
        onAction: () => vm.selectFactory(context),
        onReset: vm.resetFactoryAndDepartureStation,
      ),
    );
  }
}

class _DepartureStationSelector extends StatelessWidget {
  const _DepartureStationSelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return ScreenElement(
      child: ExternalSourceInput(
        enabled: vm.isDepartureStationSelectorAllowed,
        clearable: true,
        label: const AppLabel("Станция отправления"),
        controller: vm.state.departureStationController,
        onAction: () => vm.selectDepartureStation(context),
        onTap: () => vm.selectDepartureStation(context),
        onReset: vm.resetDepartureStation,
      ),
    );
  }
}

class _TargetStationSelector extends StatelessWidget {
  const _TargetStationSelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return ScreenElement(
      child: ExternalSourceInput(
        clearable: true,
        label: const AppLabel("Станция назначения", marked: true),
        controller: vm.state.destinationStationController,
        onTap: () => vm.selectDestinationStation(context),
        onAction: () => vm.selectDestinationStation(context),
        onReset: vm.resetDestinationStationAndTransshipments,
      ),
    );
  }
}

class _TransshipmentStationsBlock extends StatelessWidget {
  const _TransshipmentStationsBlock();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    final isInputActive = vm.state.transshipmentSelectorValue ==
        TransshipmentSelectionType.selected.index;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 12),
          child: Text('Станции перевалки'),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: AppSegmentedSwitch<int>(
            enabled: vm.isTransshipmetsSelectorAllowed,
            values:
                TransshipmentSelectionType.values.map((e) => e.index).toList(),
            titles: const ['Нет', 'Все', 'Выбрать'],
            groupValue: vm.state.transshipmentSelectorValue,
            onValueChanged: vm.switchTransshipmentSelector,
          ),
        ),
        if (isInputActive)
          ScreenElement(
            child: ExternalSourceInput(
              clearable: true,
              label: const AppLabel("Станции перевалки", marked: true),
              controller: vm.state.transshipmentsController,
              onTap: () => vm.selectTransshipmentStations(context),
              onAction: () => vm.selectTransshipmentStations(context),
              onReset: vm.resetTransshipmentStations,
            ),
          ),
      ],
    );
  }
}
