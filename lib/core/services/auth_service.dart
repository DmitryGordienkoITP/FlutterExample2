import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:oktoast/oktoast.dart';

import '../../data/data_providers/api/auth_api_provider.dart';
import '../../data/data_providers/secure_storage/secure_storage_provider.dart';
import '../../data/models/auth_model.dart';
import '../../data/models/user_info_model.dart';
import '../common/enums/user_role_enum.dart';
import '../common/helpers/toast_helper.dart';

@Singleton(scope: 'auth')
class AuthService extends ChangeNotifier {
  AuthModel? _authData;
  User? _user;

  final AuthAPIProvider _authApi;
  final SecureStorageProvider _secureStorage;

  bool get isAuth {
    final isAuth = _authData != null && _authData!.exp.isAfter(DateTime.now());

    return isAuth;
  }

  bool get isTrader {
    return _user?.role == UserRole.manager;
  }

  String get token => _authData!.token;

  User? get user => _user;

  AuthService(this._authApi, this._secureStorage);

  Future<bool> signUp(String name, String login, String password) async {
    try {
      final authData =
          await _authApi.signUp(name: name, email: login, password: password);
      await _login(authData);
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> login(String login, String password) async {
    try {
      final authData = await _authApi.login(login: login, password: password);
      await _login(authData);
      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _login(AuthModel authData) async {
    _authData = authData;
    await _secureStorage.saveAuthData(_authData!);
    await _getUserInfo();
  }

  Future<void> logout() async {
    _authData = null;
    await _secureStorage.clearAuthData();
    notifyListeners();
  }

  Future<void> _getUserInfo() async {
    try {
      final user = await _authApi.getUserInfo();
      _user = user;
    } catch (err) {
      await logout();
    }
  }

  Future<void> tryAutoLogin() async {
    _authData = await _secureStorage.getAuthData();

    if (!isAuth) {
      if (_authData != null) {
        await logout();
      }
    } else {
      await _getUserInfo();
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _authApi.deleteAccount();
      await logout();
      ToastHelper.showAppToast(
        'Учетная запись успешно удалена',
        position: ToastPosition.center,
      );
    } catch (error) {
      ///
    }
  }

  Future<String?> refreshToken() async {
    if (_authData == null) return null;
    try {
      final authData =
          await _authApi.refreshAccessToken(token: _authData!.refresh);
      _login(authData);
    } catch (e) {
      return null;
    }
    return _authData?.token;
  }
}
