import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/preferences_service.dart';
import '../../data/models/preferences_model.dart';
import '../../data/models/user_info_model.dart';
import '../themes/palette.dart';
import '../themes/styles/app_text_styles.dart';
import '../themes/styles/appbar_styles.dart';
import 'app_dialogs.dart';
import 'custom_app_bar.dart';
import 'screen_element.dart';

class _ViewModelState {
  PreferencesModel? prefs;
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  final AuthService _authService = GetIt.instance.get<AuthService>();
  final PreferencesService _prefsService =
      GetIt.instance.get<PreferencesService>();

  bool get sendPushNotifications => state.prefs!.pushNotificationsEnabled;

  User get user => _authService.user!;

  _ViewModel() {
    state.prefs = _prefsService.preferences;
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
  }

  Future<void> setPushNotificationSettings(bool value) async {
    _state.prefs!.pushNotificationsEnabled = value;
    await _prefsService.save(state.prefs!);
    notifyListeners();
  }
}

class UserProfile extends StatelessWidget {
  static const routeName = "/user-profile";
  const UserProfile({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const UserProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        title: Text('Профиль', style: AppBarStyles.mainScreenTitle()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _UserInfo(),
          _Settings(),
          Spacer(),
          _Controls(),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return ScreenElement(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vm.user.name,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.mail_outline, color: AppPalette.gray1),
                const SizedBox(width: 10),
                Text(vm.user.email, style: AppTextStyles.body),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<_ViewModel>();
    return ScreenElement(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(),
            const SizedBox(height: 20),
            buildPushSettings(vm),
          ],
        ),
      ),
    );
  }

  Row buildPushSettings(_ViewModel vm) {
    return Row(
      children: [
        const Text('Push-уведомления', style: AppTextStyles.body),
        const Spacer(),
        CupertinoSwitch(
          // This bool value toggles the switch.
          value: vm.sendPushNotifications,
          trackColor: AppPalette.gray2,
          activeColor: AppPalette.accentGreen,
          onChanged: (bool? value) => vm.setPushNotificationSettings(value!),
        ),
      ],
    );
  }

  Text buildTitle() => Text(
        'Настройки профиля',
        style: AppTextStyles.bodySM.copyWith(color: AppPalette.gray1),
      );
}

class _Controls extends StatelessWidget {
  const _Controls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: const [
          _DeleteAccountButton(),
          _LogoutButton(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return ScreenElement(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TextButton(
          onPressed: () {
            AppDialogs.showConfirmationDialog(
              context: context,
              message: 'Вы действительно хотите удалить учетную запись?',
              onConfirm: vm.deleteAccount,
            );
          },
          child: const Text("Удалить аккаунт", style: AppTextStyles.body),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return ScreenElement(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TextButton(
          onPressed: vm.logout,
          child: Text(
            "Выйти из учетной записи",
            style: AppTextStyles.body.copyWith(
              color: AppPalette.red,
            ),
          ),
        ),
      ),
    );
  }
}
