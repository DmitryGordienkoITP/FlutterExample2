import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/delivery_model.dart';
import '../../../../data/models/paging.dart';
import '../../../../core/services/delivery_service.dart';
import '../../../shared/custom_app_bar.dart';
import '../../../themes/palette.dart';
import '../../../themes/styles/app_text_styles.dart';
import '../../../themes/styles/appbar_styles.dart';
import 'single_calculation_modal/single_calculation_modal.dart';
import 'widgets/delivery_card.dart';

class _ViewModelState {
  List<DeliveryModel> deliveriesTotal = [];
  Paging<DeliveryModel>? deliveriesPage;
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  final DeliveryService _deliveryService =
      GetIt.instance.get<DeliveryService>();

  bool isLoading = false;
  bool isRefreshing = false;

  List<DeliveryModel> get deliveries => state.deliveriesTotal;

  final void Function(DeliveryModel) _repeateCalculationHandler;

  late StreamSubscription deliveriesSub;

  bool get isMoreAvailable {
    return state.deliveriesPage == null
        ? false
        : !state.deliveriesPage!.isLastPage;
  }

  _ViewModel(this._repeateCalculationHandler) {
    deliveriesSub = _deliveryService.deliveriesStream.listen((value) {
      state.deliveriesTotal = value;
      notifyListeners();
    });

    initAsync();
  }

  Future<void> cancelSubscriptions() async {
    await deliveriesSub.cancel();
  }

  Future<void> initAsync() async {
    await getDeliveries();
  }

  Future<void> getDeliveries() async {
    isRefreshing = true;
    notifyListeners();
    state.deliveriesPage = await _deliveryService.get();
    isRefreshing = false;
    notifyListeners();
  }

  Future<void> getMore() async {
    isLoading = true;
    notifyListeners();
    state.deliveriesPage = await _deliveryService.get(
      pageIndex: state.deliveriesPage!.nextPageIndex,
      pageSize: state.deliveriesPage!.pageSize,
    );
    isLoading = false;
    notifyListeners();
  }

  Future showSingleCalculationModal(
      BuildContext context, DeliveryModel delivery) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SingleCalculationModal.create(_repeateCalculationHandler, delivery),
      ),
    );
  }
}

class CalculationsHistoryTab extends StatefulWidget {
  static const routeName = "/calc-history";
  const CalculationsHistoryTab({Key? key}) : super(key: key);

  static Widget create(void Function(DeliveryModel) repeateCalculationHandler) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(repeateCalculationHandler),
      child: const CalculationsHistoryTab(),
    );
  }

  @override
  State<CalculationsHistoryTab> createState() => _CalculationsHistoryTabState();
}

class _CalculationsHistoryTabState extends State<CalculationsHistoryTab> {
  late Function disposeViewModel;

  @override
  void dispose() {
    disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    disposeViewModel = vm.cancelSubscriptions;
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        title: Text('Расчеты', style: AppBarStyles.mainScreenTitle()),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: vm.isRefreshing
            ? const _LoadingIndicator()
            : Scrollbar(
                thickness: 6,
                thumbVisibility: true,
                child: RefreshIndicator(
                  onRefresh: vm.getDeliveries,
                  child: ListView(
                    children: [
                      const SizedBox(height: 24),
                      ...buildDeliveryCards(context),
                      vm.isLoading
                          ? const _LoadingIndicator()
                          : vm.isMoreAvailable
                              ? const _ShowMoreButton()
                              : const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> buildDeliveryCards(BuildContext context) {
    final vm = context.read<_ViewModel>();
    final handler = vm.showSingleCalculationModal;
    return vm.deliveries
        .map((delivery) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DeliveryCard(
                delivery,
                () => handler(context, delivery),
              ),
            ))
        .toList();
  }
}

class _ShowMoreButton extends StatelessWidget {
  const _ShowMoreButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: vm.getMore,
        child: Text(
          "Показать еще",
          style: AppTextStyles.body.copyWith(color: AppPalette.accentGreen),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
