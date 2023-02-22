import 'package:flutter/material.dart';

import '../../shared/buttons/secondary_button.dart';
import '../../shared/labeled_divider.dart';
import '../../themes/palette.dart';
import 'widgets/login_widget.dart';
import 'widgets/sign_up_widget.dart';

enum AuthScreenMode { login, signUp }

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var mode = AuthScreenMode.login;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppPalette.white,
        body: mode == AuthScreenMode.login
            ? LoginWidget.create()
            : SignUpWidget.create(),
        resizeToAvoidBottomInset: false,
        bottomSheet: Container(
          color: AppPalette.white,
          height: 90,
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              const LabeledDivider("или"),
              SecondaryButton(
                title: mode == AuthScreenMode.login
                    ? const Text("Зарегистрироваться")
                    : const Text("Вход в Личный кабинет"),
                onPressed: () {
                  mode == AuthScreenMode.login
                      ? mode = AuthScreenMode.signUp
                      : mode = AuthScreenMode.login;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
