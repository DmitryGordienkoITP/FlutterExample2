import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common/enums/tabs/main_tabs.dart';
import '../../../core/common/helpers/date_helper.dart';
import '../../../data/models/delivery_model.dart';
import '../../shared/profile.dart';
import '../../themes/palette.dart';
import 'history/calculations_history_tab.dart';
import 'new_calculation/new_calculation_tab.dart';

class _ViewModelState {
  int selectedIndex = MainTabs.deliveryCalculation.index;

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  int get selectedIndex => state.selectedIndex;

  List<Widget> _widgetOptions = [];

  DeliveryModel? _template;

  _ViewModel() {
    _widgetOptions = [
      NewCalculationTab.create(selectTab, template: _template),
      CalculationsHistoryTab.create(_repeateCalculation),
      UserProfile.create(),
    ];
  }

  void _onItemTapped(int index) {
    _clearTemplate();
    state.selectedIndex = index;
    notifyListeners();
  }

  void selectTab(MainTabs tab) {
    _clearTemplate();
    state.selectedIndex = tab.index;
    notifyListeners();
  }

  void _clearTemplate() {
    if (_template == null) return;
    _template = null;
    _rebuildNewCalculationWidget();
  }

  void _rebuildNewCalculationWidget() {
    _widgetOptions[MainTabs.deliveryCalculation.index] =
        NewCalculationTab.create(selectTab, template: _template);
  }

  void _repeateCalculation(DeliveryModel template) {
    _template = template;
    _rebuildNewCalculationWidget();
    state.selectedIndex = MainTabs.deliveryCalculation.index;
    notifyListeners();
  }
}

class MainScreen extends StatelessWidget {
  static const routeName = "/main";
  const MainScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const MainScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateHelper.init(context);
    final vm = context.watch<_ViewModel>();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppPalette.white,
        body: vm._widgetOptions.elementAt(vm.selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppPalette.white,
          iconSize: 28,
          items: const [
            /// MainTabs.deliveryCalculation
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'Расчет',
            ),

            /// MainTabs.history
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              label: 'История',
            ),

            /// MainTabs.profile
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Профиль',
            ),
          ],
          currentIndex: vm.selectedIndex,
          onTap: vm._onItemTapped,
        ),
      ),
    );
  }
}
