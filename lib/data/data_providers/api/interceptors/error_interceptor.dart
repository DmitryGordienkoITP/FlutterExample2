import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../../../../core/common/exceptions/api_exception.dart';
import '../../../../core/common/helpers/api_exception_helper.dart';
import '../../../../core/common/helpers/toast_helper.dart';

class ErrorInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async =>
      data;

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    final statusCode = data.statusCode;
    if (statusCode < 400) return data;

    if (kDebugMode) {
      print(data);
    }
    var ex = ApiException.unknown();

    if (statusCode >= 502 && statusCode <= 504) {
      ex = ApiException.serverUnavailable();
    } else if (statusCode == 401 || statusCode == 403) {
      ex = ApiException.serverAccessError();
    } else {
      try {
        ex = ApiException.fromResponseData(data);
      } catch (e) {
        // ignore
      }
    }

    if (!ex.isMuted) {
      final msg = ApiExceptionHelper.getMessageByException(ex);
      ToastHelper.showErrorToast(msg);
    }

    throw ex;
  }
}
