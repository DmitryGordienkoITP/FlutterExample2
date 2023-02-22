import 'package:http_interceptor/http_interceptor.dart';

import '../api/policies/expired_token_retry_policy.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/content_type_interceptor.dart';
import 'interceptors/error_interceptor.dart';

abstract class BaseAPIProvider {
  static InterceptedHttp? _publicHttp;
  static InterceptedHttp? _securedHttp;

  InterceptedHttp get publicHttp {
    _publicHttp ??= InterceptedHttp.build(interceptors: [
      ErrorInterceptor(),
      ContentTypeInterceptor(),
    ]);
    return _publicHttp!;
  }

  InterceptedHttp get securedHttp {
    _securedHttp ??= InterceptedHttp.build(interceptors: [
      ErrorInterceptor(),
      AuthInterceptor(),
      ContentTypeInterceptor(),
    ], retryPolicy: ExpiredTokenRetryPolicy());
    return _securedHttp!;
  }
}
