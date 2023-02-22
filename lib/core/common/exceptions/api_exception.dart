import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../enums/api_exception_type.dart';
import '../helpers/api_exception_helper.dart';
import '../helpers/data_helper.dart';

class ApiException implements Exception {
  final String entityName;
  final String code;
  final String message;

  ApiExceptionType get type => ApiExceptionHelper.getType(entityName, code);

  bool get isMuted {
    switch (type) {
      case ApiExceptionType.userWrongLoginOrPwd:
      case ApiExceptionType.userIsBlocked:
        return true;
      default:
        return false;
    }
  }

  ApiException(this.entityName, this.code, this.message);

  @override
  String toString() {
    return '$entityName - $code - $message';
  }

  factory ApiException.fromResponseData(ResponseData response) {
    var ex = ApiException.unknown();
    if (response.body == null) return ex;
    try {
      var responseData = DataHelper.decodeBytes(response.bodyBytes);
      ex = ApiException.fromMap(responseData);
    } catch (e) {
      // ignore
    }
    return ex;
  }

  factory ApiException.fromResponse(Response response) {
    var ex = ApiException.unknown();
    try {
      var responseData = DataHelper.decodeBytes(response.bodyBytes);
      ex = ApiException.fromMap(responseData);
    } catch (e) {
      // ignore
    }
    return ex;
  }

  factory ApiException.fromMap(dynamic obj) {
    return ApiException(
      obj['entityName'],
      obj['code'],
      obj['message'],
    );
  }

  factory ApiException.unknown() {
    return ApiException('Unknown', '***', 'Unknown error');
  }

  factory ApiException.serverUnavailable() {
    return ApiException('server', '001', 'Cервер не доступен');
  }
  factory ApiException.serverAccessError() {
    return ApiException('server', '002', 'Необходима авторизация');
  }
}
