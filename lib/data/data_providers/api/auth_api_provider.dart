import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../models/auth_model.dart';
import '../../models/user_info_model.dart';
import '../../../core/environment/app_environment.dart';
import 'base_api_provider.dart';

@Injectable(scope: 'auth')
class AuthAPIProvider extends BaseAPIProvider {
  final _authApiUrl = '${AppEnvironment.apiUrl}/auth';

  Future<AuthModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = '$_authApiUrl/registration';

    final response = await publicHttp.post(
      Uri.parse(url),
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    final responseData = json.decode(response.body);
    return AuthModel.fromMap(responseData);
  }

  Future<AuthModel> login({
    required String login,
    required String password,
  }) async {
    final url = '$_authApiUrl/login';

    final response = await publicHttp.post(
      Uri.parse(url),
      body: json.encode({'email': login, 'password': password}),
    );

    return AuthModel.fromJson(response.body);
  }

  Future<User> getUserInfo() async {
    final url = '$_authApiUrl/info';
    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    return User.fromMap(responseData);
  }

  Future<void> deleteAccount() async {
    final url = '$_authApiUrl/user';
    await securedHttp.delete(Uri.parse(url));
  }

  Future<AuthModel> refreshAccessToken({required String token}) async {
    final url = '$_authApiUrl/refresh';

    final body = json.encode({'token': token});

    final response = await publicHttp.post(Uri.parse(url), body: body);

    final responseData = json.decode(response.body);
    return AuthModel.fromMap(responseData);
  }
}
