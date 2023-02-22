part of 'new_calculation_tab.dart';

class _ViewModelState {
  ProductModel? product;
  FactoryModel? factory;
  StationModel? departureStation;
  StationModel? destinationStation;
  List<StationModel> transshipmentStations = [];
  var date = DateTime.now();

  final dateController = TextEditingController();
  final productController = TextEditingController();
  final factoryController = TextEditingController();
  final departureStationController = TextEditingController();
  final destinationStationController = TextEditingController();
  final transshipmentsController = TextEditingController();

  int transshipmentSelectorValue = TransshipmentSelectionType.none.index;

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final form = GlobalKey<FormState>();
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  final DeliveryService _deliveryService =
      GetIt.instance.get<DeliveryService>();

  final void Function(MainTabs) _selectTab;

  bool get isFactorySelectorAllowed {
    return state.product != null;
  }

  bool get isDepartureStationSelectorAllowed {
    return state.factory != null;
  }

  bool get isTransshipmetsSelectorAllowed {
    return state.destinationStation != null;
  }

  bool get transshipmentsRequired {
    return state.transshipmentStations.isEmpty &&
        state.transshipmentSelectorValue ==
            TransshipmentSelectionType.selected.index;
  }

  bool get isSubmitAllowed {
    return state.product != null &&
        state.destinationStation != null &&
        !transshipmentsRequired;
  }

  _ViewModel(this._selectTab, {DeliveryModel? template}) {
    _init();
    _initFormFromTemplate(template);
  }

  void _init() async {
    await initializeDateFormatting('RU', null);
  }

  _initFormFromTemplate(DeliveryModel? template) {
    if (template == null) return;

    state.product = template.product;
    state.productController.text = state.product!.publicName;

    state.factory = template.factory;
    state.factoryController.text = state.factory?.name ?? '';

    state.departureStation = template.departureStation;
    state.departureStationController.text = state.departureStation?.name ?? '';

    state.destinationStation = template.destinationStation;
    state.destinationStationController.text = state.destinationStation!.name;

    state.transshipmentSelectorValue = template.transshipmentSelection.index;
    state.transshipmentStations = template.transshipmentStations;
    state.transshipmentsController.text =
        getTransshipmentStationsString(state.transshipmentStations);
  }

  String getTransshipmentStationsString(List<StationModel> stations) {
    String result = '';
    if (stations.isEmpty) {
      result = '';
    } else if (stations.length == 1) {
      final station = stations.single;
      result = '${station.name}\n${station.country!.name}';
    } else if (stations.length <= 4) {
      result = 'Выбрано ${stations.length} станции';
    } else {
      result = 'Выбрано ${stations.length} станций';
    }
    return result;
  }

  Future<void> submitForm() async {
    await _deliveryService.create(
        departureDate: state.date,
        product: state.product!,
        factory: state.factory,
        departureStation: state.departureStation,
        destinationStation: state.destinationStation!,
        transshipmentSelectionType:
            TransshipmentSelectionType.values[state.transshipmentSelectorValue],
        transshipmentStations: state.transshipmentStations);

    _selectTab(MainTabs.history);
  }

  switchTransshipmentSelector(int? value) {
    state.transshipmentSelectorValue = value!;
    notifyListeners();
  }

  Future selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: state.date,
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 10)),
    );
    if (pickedDate != null) {
      state.date = pickedDate;
      state.dateController.text = DateHelper.getFormatedDate(state.date);
    }
  }

  Future selectProduct(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductSelectionModal.create()));
    if (result != null) {
      final product = result as ProductModel;
      state.product = product;
      state.productController.text = product.publicName;
      resetFactoryAndDepartureStation();
      notifyListeners();
    }
  }

  Future selectFactory(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FactorySelectionModal.create(product: state.product)));
    if (result != null) {
      final product = result.products[0] as FactoryProductModel;
      final formatedPrice = MoneyHelper.format(product.price);
      final formatedDate =
          DateFormat('h:mm:ss d.MM.yyy').format(product.priceUpdatedAt);

      final factory = result as FactoryModel;
      state.factory = factory;
      state.factoryController.text =
          '${factory.name}\n$formatedPrice руб. на $formatedDate';
      resetDepartureStation();
      notifyListeners();
    }
  }

  Future selectDepartureStation(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DepartureStationSelectionModal.create(
                stations: state.factory?.stations)));
    if (result != null) {
      final station = result as StationModel;
      state.departureStation = station;
      state.departureStationController.text =
          '${station.name}\n${station.country!.name}';
      notifyListeners();
    }
  }

  Future selectDestinationStation(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DestinationStationSelectionModal.create()));
    if (result != null) {
      final station = result as StationModel;
      state.destinationStation = station;
      state.destinationStationController.text =
          '${station.name}\n${station.country!.name}';
      notifyListeners();
    }
  }

  Future selectTransshipmentStations(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransshipmentStationSelectionModal.create(
          state.destinationStation!.countryCode!,
          state.transshipmentStations,
        ),
      ),
    );
    if (result != null) {
      final stations = result as List<StationModel>;
      state.transshipmentStations = stations;

      state.transshipmentsController.text =
          getTransshipmentStationsString(state.transshipmentStations);

      notifyListeners();
    }
  }

  resetProductAndFactory() {
    state.product = null;
    state.productController.clear();
    resetFactoryAndDepartureStation();
  }

  resetFactoryAndDepartureStation() {
    state.factory = null;
    state.factoryController.clear();
    resetDepartureStation();
  }

  resetDepartureStation() {
    state.departureStation = null;
    state.departureStationController.clear();
    notifyListeners();
  }

  resetDestinationStationAndTransshipments() {
    state.destinationStation = null;
    state.destinationStationController.clear();
    resetTransshipmentStations();
  }

  resetTransshipmentStations() {
    state.transshipmentStations = [];
    state.transshipmentsController.clear();
    notifyListeners();
  }
}
