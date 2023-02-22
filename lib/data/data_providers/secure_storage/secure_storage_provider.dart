import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../models/auth_model.dart';

@Injectable(scope: 'auth')
class SecureStorageProvider {
  static const _authPrefKey = 'authData';
  SecureStorageProvider();

  Future<AuthModel?> getAuthData() async {
    try {
      final value = await const FlutterSecureStorage().read(key: _authPrefKey);
      return value == null ? null : AuthModel.fromJson(value);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<void> clearAuthData() async {
    await const FlutterSecureStorage().delete(key: _authPrefKey);
  }

  Future<void> saveAuthData(AuthModel authData) async {
    final userData = authData.toJson();
    await const FlutterSecureStorage()
        .write(key: _authPrefKey, value: userData);
  }
}
