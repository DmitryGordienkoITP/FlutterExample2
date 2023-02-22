import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../../secure_storage/secure_storage_provider.dart';

class AuthInterceptor implements InterceptorContract {
  AuthInterceptor();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final storage = GetIt.instance.get<SecureStorageProvider>();
    final token = (await storage.getAuthData())?.token;

    if (kDebugMode) {
      print(token);
    }
    try {
      data.headers["Authorization"] = 'Bearer $token';
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
