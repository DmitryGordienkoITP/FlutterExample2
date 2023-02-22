import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/station_model.dart';
import '../../../../core/services/station_service.dart';
import '../../../shared/app_divider.dart';
import '../../../shared/custom_app_bar.dart';
import '../../../shared/station_list_item.dart';
import '../../../themes/palette.dart';
import '../../../themes/styles/appbar_styles.dart';

class _ViewModelState {
  List<StationModel> stations = [];
  List<StationModel> filteredStations = [];
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  bool isLoading = false;
  _ViewModelState get state => _state;

  final StationService _stationService = GetIt.instance.get<StationService>();

  final scrollController = ScrollController();

  getStations() async {
    isLoading = true;
    notifyListeners();
    state.stations = await _stationService.getAll();
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
}

class StationsListTab extends StatelessWidget {
  const StationsListTab({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const StationsListTab(),
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
          backgroundColor: AppPalette.white,
          appBar: CustomAppBar(
            centerTitle: true,
            title:
                Text('Список станций', style: AppBarStyles.mainScreenTitle()),
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
    return vm.isLoading
        ? const Expanded(child: Center(child: CircularProgressIndicator()))
        : Expanded(
            child: ListView.separated(
              controller: vm.scrollController,
              separatorBuilder: (context, index) => const AppDivider(),
              itemCount: stations.length,
              itemBuilder: (context, index) => StationListItem(stations[index]),
            ),
          );
  }
}
