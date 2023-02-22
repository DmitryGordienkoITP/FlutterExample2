import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/station_model.dart';
import '../../../../../core/services/station_service.dart';
import '../../../../shared/app_divider.dart';
import '../../../../shared/buttons/primary_button.dart';
import '../../../../shared/custom_app_bar.dart';
import '../../../../shared/empty_list_placeholder.dart';
import '../../../../themes/styles/appbar_styles.dart';

class _ViewModelState {
  List<StationModel> stations = [];
  List<StationModel> filteredStations = [];
  List<StationModel> selectedStations = [];
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  late String _countryCode;
  bool isLoading = false;
  _ViewModelState get state => _state;

  final StationService stationService = GetIt.instance.get<StationService>();

  final scrollController = ScrollController();

  _ViewModel(String countryCode, List<StationModel>? stations) {
    _countryCode = countryCode;

    state.selectedStations = stations == null ? [] : [...stations];
    getStations();
  }

  getStations() async {
    isLoading = true;
    notifyListeners();
    state.stations = await stationService.getTransshipment(_countryCode);
    state.filteredStations = state.stations;
    isLoading = false;
    notifyListeners();
  }

  filterStations(String? searchString) async {
    if (scrollController.hasClients) scrollController.jumpTo(0);
    if (searchString == null || searchString.isEmpty) {
      state.filteredStations = state.stations;
    } else {
      state.filteredStations =
          state.stations.where((el) => el.isLike(searchString)).toList();
    }
    notifyListeners();
  }

  bool isStationSelected(StationModel station) {
    return state.selectedStations.any((el) => el.id == station.id);
  }

  bool get isSubmitAllowed {
    return state.selectedStations.isNotEmpty;
  }

  onStationTap(StationModel station) {
    if (!isStationSelected(station)) {
      selectStation(station);
    } else {
      unselectStation(station);
    }
    notifyListeners();
  }

  selectStation(StationModel station) {
    state.selectedStations.add(station);
  }

  unselectStation(StationModel station) {
    state.selectedStations.removeWhere((el) => el.id == station.id);
  }

  selectItems(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, state.selectedStations);
  }
}

class TransshipmentStationSelectionModal extends StatelessWidget {
  const TransshipmentStationSelectionModal({Key? key}) : super(key: key);

  static Widget create(String countryCode, List<StationModel>? stations) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(countryCode, stations),
      child: const TransshipmentStationSelectionModal(),
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
          floatingActionButton: const _SubmitButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            centerTitle: true,
            title:
                Text('Станции перевалки', style: AppBarStyles.subScreenTitle()),
          ),
          body: Column(
            children: const [
              _SearchField(),
              AppDivider(),
              _StationsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: PrimaryButton(
        title: const Text("Выбрать"),
        onPressed: () => vm.selectItems(context),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CupertinoSearchTextField(onChanged: vm.filterStations),
    );
  }
}

class _StationsList extends StatelessWidget {
  const _StationsList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    final stations = vm.state.filteredStations;
    return Expanded(
      child: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : stations.isNotEmpty
              ? ListView(
                  controller: vm.scrollController,
                  children: [
                    ...stations.map((e) => buildCard(vm, e)).toList(),
                    const SizedBox(height: 80),
                  ],
                )
              : const EmptyListPlaceholder('Нет подходящих станций'),
    );
  }

  Padding buildCard(_ViewModel vm, StationModel station) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            width: 0.5,
            color: Color.fromRGBO(0xE5, 0xE5, 0xEA, 1),
          ),
        ),
        elevation: 0,
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          horizontalTitleGap: 0,
          onTap: () => vm.onStationTap(station),
          leading: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            value: vm.isStationSelected(station),
            onChanged: (selected) => vm.onStationTap(station),
          ),
          title: Text(station.name),
          subtitle: Text(station.country!.name),
        ),
      ),
    );
  }
}
