part of 'single_calculation_modal.dart';

enum PopupMenuOptions {
  cancel,
  repeateCalculation,
  sendPDF,
}

class _ViewModelState {
  late DeliveryModel delivery;
  //List<FilterOptions> filter = [];
  BasisFilterOptions basisFilter =
      BasisFilterOptions.domesticPlusThreeCountries;
  _ViewModelState();
}

class SingleCalculationModalViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  bool isLoading = false;
  _ViewModelState get state => _state;

  final DeliveryService _deliveryService =
      GetIt.instance.get<DeliveryService>();

  final void Function(DeliveryModel) _repeateCalculationHandler;

  late StreamSubscription deliveriesSub;

  SingleCalculationModalViewModel(
      this._repeateCalculationHandler, DeliveryModel delivery) {
    state.delivery = delivery;
    deliveriesSub = _deliveryService.deliveriesStream.listen((value) async {
      state.delivery =
          value.firstWhere((element) => element.id == state.delivery.id);
      notifyListeners();
    });

    initAsync();
  }

  initAsync() async {
    isLoading = true;
    notifyListeners();
    state.delivery = await _deliveryService.getSingle(state.delivery.id);
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendPDFReport(BuildContext context) async {
    LoadingIndicator.startLoading(context);
    final file = await _deliveryService.getAsPdf(state.delivery.id);
    LoadingIndicator.stopLoading(context);
    try {
      await Share.shareFiles([file.path],
          mimeTypes: ['application/pdf'], text: 'Pdf report');
    } catch (e) {
      ToastHelper.showErrorToast(e.toString());
    } finally {
      await file.delete();
    }
  }

  Future<void> cancelReport() async {
    try {
      state.delivery = await _deliveryService.cancel(state.delivery.id);
      notifyListeners();
      ToastHelper.showAppToast("Расчет отменен");
    } catch (err) {
      ToastHelper.showErrorToast(err.toString());
    }
  }

  void onPopupMenuAction(BuildContext context, PopupMenuOptions value) async {
    switch (value) {
      case PopupMenuOptions.cancel:
        cancelReport();
        break;
      case PopupMenuOptions.repeateCalculation:
        _repeateCalculationHandler(state.delivery);
        await deliveriesSub.cancel();
        Navigator.pop(context);
        break;
      case PopupMenuOptions.sendPDF:
        sendPDFReport(context);
        break;
    }
  }

  void onFilterChange(BasisFilterOptions value) {
    state.basisFilter = value;
    notifyListeners();
  }
}
