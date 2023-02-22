import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/profile.dart';
import 'widgets/stations_list_tab.dart';

class _ViewModelState {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    StationsListTab.create(),
    UserProfile.create(),
  ];
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  _ViewModelState get state => _state;
  void _onItemTapped(int index) {
    state.selectedIndex = index;
    notifyListeners();
  }
}

class GuestScreen extends StatelessWidget {
  static const routeName = "/guest-screen";
  const GuestScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const GuestScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      */
      body: SafeArea(
        top: false,
        child: Center(
          child: vm.state._widgetOptions.elementAt(vm.state.selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Список Станций',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Профиль',
          ),
        ],
        currentIndex: vm.state.selectedIndex,
        //selectedItemColor: Colors.blueAccent,
        //unselectedItemColor: Colors.black54,
        onTap: vm._onItemTapped,
      ),
    );
  }
}
