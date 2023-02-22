import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'core/services/auth_service.dart';
import 'dependencies/dependencies.config.dart';
import 'dependencies/dependencies.dart';
import 'presentation/router/app_router.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/guest/guest_screen.dart';
import 'presentation/screens/loading_screen.dart';
import 'presentation/screens/main/main_screen.dart';
import 'presentation/themes/styles/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initAuthScope(getIt);
  runApp(TariffDVApp());
}

class TariffDVApp extends StatelessWidget {
  final _getIt = GetIt.instance;
  final _appRouter = AppRouter();

  TariffDVApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => _getIt.get<AuthService>()),
        ],
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            theme: AppTheme.main,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', 'RU'),
              Locale('en', ''),
            ],
            locale: const Locale('ru', 'RU'),
            title: 'Тариф ДВ',
            home: Consumer<AuthService>(
              builder: (context, authService, _) => FutureBuilder(
                future: authService.tryAutoLogin(),
                builder: (context, snapshot) =>
                    buildScreen(snapshot.connectionState),
              ),
            ),
            onGenerateRoute: _appRouter.onGenerateRoute,
          ),
        ),
      ),
    );
  }

  Widget buildScreen(ConnectionState state) {
    _getIt.popScopesTill('baseAccess');

    final authService = _getIt.get<AuthService>();

    if (state == ConnectionState.waiting) return const LoadingScreen();

    if (!authService.isAuth) return const AuthScreen();

    initBaseAccessScope(getIt);
    if (!authService.isTrader) return GuestScreen.create();

    initFullAccessScope(getIt);
    return MainScreen.create();
  }
}
