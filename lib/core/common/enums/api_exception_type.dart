enum ApiExceptionType {
  // Unknows error
  unknownError,

  // Server errors
  serverUnavailable,
  serverAccessError,

  // System error
  systemError,

  // User errors
  userIsAlreadyRegistered,
  userNotFound,
  userWrongLoginOrPwd,
  userIsBlocked,
}
