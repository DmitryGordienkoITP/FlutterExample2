import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../../../../core/services/auth_service.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  // ignore: overridden_fields
  int maxRetryAttempts = 3;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode != 401) return false;
    try {
      final authService = GetIt.instance.get<AuthService>();
      await authService.refreshToken();
    } catch (e) {
      return false;
    }
    return true;
  }
}
