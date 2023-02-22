import 'package:flutter/material.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/guest/guest_screen.dart';
import '../screens/legals_screen.dart';
import '../screens/main/main_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
      case LegalsScreen.routeName:
        return MaterialPageRoute(builder: (context) => const LegalsScreen());
      case GuestScreen.routeName:
        return MaterialPageRoute(builder: (context) => GuestScreen.create());
      case MainScreen.routeName:
        return MaterialPageRoute(builder: (context) => MainScreen.create());
      default:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
    }
  }
}
