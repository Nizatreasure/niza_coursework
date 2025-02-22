enum DataStatus {
  success,
  created,
  badCertificate,
  badRequest,
  unauthorized,
  unprocessable,
  forbidden,
  notFound,
  internalServerError,
  connectionError,
  unknown,
  connectionTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  unauthenticated,
  notVerified,
  emailInUse,
  invalidEmail,
  weakPassword,
  userNotFound,
  wrongPassword,
  invalidCredential,
  tooManyRequests,
}

enum UpdateType { reporting, sampling, max, min }
