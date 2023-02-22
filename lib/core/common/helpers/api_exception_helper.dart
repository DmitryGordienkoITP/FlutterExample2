import '../enums/api_exception_type.dart';
import '../exceptions/api_exception.dart';

abstract class ApiExceptionHelper {
  static const Map<String, Map<String, ApiExceptionType>> _exceptions = {
    'system': {
      '000': ApiExceptionType.systemError,
    },
    'server': {
      '001': ApiExceptionType.serverUnavailable,
      '002': ApiExceptionType.serverAccessError,
    },
    'access': {},
    'user': {
      '001': ApiExceptionType.userIsAlreadyRegistered,
      '002': ApiExceptionType.userNotFound,
      '003': ApiExceptionType.userWrongLoginOrPwd,
      '004': ApiExceptionType.userIsBlocked,
    },
    'station': {},
    'product': {},
    'factory': {},
    'delivery': {},
  };

  static const Map<ApiExceptionType, String> _messages = {
    // Unknown error
    ApiExceptionType.unknownError: 'Что-то пошло не так...',

    // Server errors
    ApiExceptionType.serverUnavailable:
        'Cервер не доступен. Повторите попытку позже.',
    ApiExceptionType.serverAccessError: 'Необходима авторизация',

    // User errors
    ApiExceptionType.userIsAlreadyRegistered:
        'Пользователь с таким логином уже зарегистрирован',
    ApiExceptionType.userNotFound: 'Такой пользователь не найден',
    ApiExceptionType.userWrongLoginOrPwd:
        'Неверный логин или пароль, повторите ввод.',
    ApiExceptionType.userIsBlocked: 'Эта учетная запись заблокирована.',
  };

  static ApiExceptionType getType(String entityName, String code) =>
      _exceptions[entityName]?[code] ?? ApiExceptionType.unknownError;

  static String getMessageByType(ApiExceptionType type) =>
      _messages[type] ?? _messages[ApiExceptionType.unknownError]!;

  static String getMessageByException(ApiException ex) =>
      getMessageByType(ex.type);

  static String getMessageByProps(String entityName, String code) {
    final type = getType(entityName, code);
    return getMessageByType(type);
  }
}
