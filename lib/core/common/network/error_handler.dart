part of 'data_failure.dart';

class ErrorHandler implements Exception {
  late DataFailure failure;
  ErrorHandler.handleError(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else if (error is FirebaseAuthException) {
      failure = _handleFirebaseError(error);
    } else {
      failure = DataStatus.unknown.getFailure()!;
    }
  }

  DataFailure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataStatus.connectionTimeout.getFailure()!;
      case DioExceptionType.sendTimeout:
        return DataStatus.sendTimeout.getFailure()!;
      case DioExceptionType.receiveTimeout:
        return DataStatus.receiveTimeout.getFailure()!;
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      case DioExceptionType.badCertificate:
        return DataStatus.badCertificate.getFailure()!;
      case DioExceptionType.cancel:
        return DataStatus.cancel.getFailure()!;
      case DioExceptionType.connectionError:
        return DataStatus.connectionError.getFailure()!;
      case DioExceptionType.unknown:
        return DataStatus.unknown.getFailure()!;
    }
  }

  DataFailure _handleFirebaseError(FirebaseAuthException error) {
    print('error is ${error.code}');
    print('error is ${error.message}');
    switch (error.code) {
      case 'email-already-in-use':
        return DataStatus.emailInUse.getFailure()!;
      case 'invalid-email':
        return DataStatus.invalidEmail.getFailure()!;
      case 'weak-password':
        return DataStatus.weakPassword.getFailure()!;
      case 'wrong-password':
        return DataStatus.wrongPassword.getFailure()!;
      case 'user-not-found':
        return DataStatus.userNotFound.getFailure()!;
      case 'invalid-credential':
        return DataStatus.invalidCredential.getFailure()!;
      case 'too-many-requests':
        return DataStatus.tooManyRequests.getFailure()!;
      default:
        return DataStatus.unknown.getFailure()!;
    }
  }

  DataFailure _handleResponseError(DioException error) {
    switch (error.response!.statusCode) {
      case ResponseCode.badRequest:
        return DataStatus.badRequest.getFailure()!;
      case ResponseCode.unauthorized:
        return DataStatus.unauthorized.getFailure()!;
      case ResponseCode.forbidden:
        return DataStatus.forbidden.getFailure()!;
      case ResponseCode.notFound:
        return DataStatus.notFound.getFailure()!;
      case ResponseCode.internalServerError:
        return DataStatus.internalServerError.getFailure()!;
      case ResponseCode.unprocessable:
        var data = error.response?.data;
        return DataStatus.unprocessable.getFailure(data: data)!;
      default:
        return DataStatus.unknown.getFailure(data: error.response?.data)!;
    }
  }
}

extension DataStatusExtension on DataStatus {
  DataFailure? getFailure({dynamic data}) {
    switch (this) {
      case DataStatus.badRequest:
        return DataFailure(
          statusCode: ResponseCode.badRequest,
          message: (data ?? {})['message'] ?? ResponseMessage.badRequest,
          data: data,
        );
      case DataStatus.unauthorized:
        return DataFailure(
          statusCode: ResponseCode.unauthorized,
          message: (data ?? {})['message'] ?? ResponseMessage.unauthorized,
          data: data,
        );
      case DataStatus.unprocessable:
        return DataFailure(
          statusCode: ResponseCode.unprocessable,
          message: (data ?? {})['message'] ?? ResponseMessage.unprocessable,
          data: data,
        );
      case DataStatus.forbidden:
        return DataFailure(
          statusCode: ResponseCode.forbidden,
          message: (data ?? {})['message'] ?? ResponseMessage.forbidden,
          data: data,
        );
      case DataStatus.notFound:
        return DataFailure(
          statusCode: ResponseCode.notFound,
          message: (data ?? {})['message'] ?? ResponseMessage.notFound,
          data: data,
        );
      case DataStatus.internalServerError:
        return DataFailure(
          statusCode: ResponseCode.internalServerError,
          message:
              (data ?? {})['message'] ?? ResponseMessage.internalServerError,
          data: data,
        );
      case DataStatus.connectionError:
        return DataFailure(
          statusCode: ResponseCode.connectionError,
          message: (data ?? {})['message'] ?? ResponseMessage.connectionError,
          data: data,
        );

      case DataStatus.connectionTimeout:
        return DataFailure(
          statusCode: ResponseCode.connectionTimeout,
          message: (data ?? {})['message'] ?? ResponseMessage.connectionTimeout,
          data: data,
        );
      case DataStatus.receiveTimeout:
        return DataFailure(
          statusCode: ResponseCode.receiveTimeout,
          message: (data ?? {})['message'] ?? ResponseMessage.receiveTimeout,
          data: data,
        );
      case DataStatus.cancel:
        return DataFailure(
          statusCode: ResponseCode.cancel,
          message: (data ?? {})['message'] ?? ResponseMessage.cancel,
          data: data,
        );
      case DataStatus.unauthenticated:
        return DataFailure(
          statusCode: ResponseCode.unauthenticated,
          message: ResponseMessage.unauthenticated,
          data: null,
        );
      case DataStatus.sendTimeout:
        return DataFailure(
          statusCode: ResponseCode.sendTimeout,
          message: (data ?? {})['message'] ?? ResponseMessage.sendTimeout,
          data: data,
        );

      case DataStatus.badCertificate:
        return DataFailure(
          statusCode: ResponseCode.badCertificate,
          message: (data ?? {})['message'] ?? ResponseMessage.badCertificate,
          data: data,
        );

      case DataStatus.notVerified:
        return DataFailure(
          statusCode: ResponseCode.notVerified,
          message: ResponseMessage.notVerified,
          data: data,
        );

      case DataStatus.emailInUse:
        return DataFailure(
          statusCode: ResponseCode.emailInUse,
          message: ResponseMessage.emailInUse,
          data: data,
        );
      case DataStatus.invalidEmail:
        return DataFailure(
          statusCode: ResponseCode.invalidEmail,
          message: ResponseMessage.invalidEmail,
          data: data,
        );
      case DataStatus.weakPassword:
        return DataFailure(
          statusCode: ResponseCode.weakPassword,
          message: ResponseMessage.weakPassword,
          data: data,
        );
      case DataStatus.userNotFound:
        return DataFailure(
          statusCode: ResponseCode.userNotFound,
          message: ResponseMessage.userNotFound,
          data: data,
        );
      case DataStatus.wrongPassword:
        return DataFailure(
          statusCode: ResponseCode.wrongPassword,
          message: ResponseMessage.wrongPassword,
          data: data,
        );
      case DataStatus.invalidCredential:
        return DataFailure(
          statusCode: ResponseCode.invalidCredential,
          message: ResponseMessage.invalidCredential,
          data: data,
        );
      case DataStatus.tooManyRequests:
        return DataFailure(
          statusCode: ResponseCode.tooManyRequests,
          message: ResponseMessage.tooManyRequests,
          data: data,
        );

      default:
        return DataFailure(
          statusCode: ResponseCode.unknown,
          message: (data ?? {})['message'] ?? ResponseMessage.unknown,
          data: data,
        );
    }
  }
}

class ResponseCode {
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int unprocessable = 422;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;

  //local codes
  static const int connectionError = -1;
  static const int unknown = -2;
  static const int connectionTimeout = -3;
  static const int cancel = -4;
  static const int receiveTimeout = -5;
  static const int sendTimeout = -6;
  static const int unauthenticated = -7;
  static const int badCertificate = -8;
  static const int notVerified = -9;
  static const int emailInUse = -10;
  static const int invalidEmail = -11;
  static const int weakPassword = -12;
  static const int userNotFound = -13;
  static const int wrongPassword = -14;
  static const int invalidCredential = -15;
  static const int tooManyRequests = -16;
}

class ResponseMessage {
  static const String success = 'Success';
  static const String created = 'Created';
  static const String badRequest = 'Bad request, try again';
  static const String unauthorized =
      'You are not authorized to perform this action';
  static const String unprocessable = 'Unprocessable content';
  static const String forbidden = 'Request forbidden';
  static const String notFound = 'URL not found';
  static const String internalServerError =
      'Something went wrong, try again later';

  //local
  static const String connectionError = 'Please check your internet connection';
  static const String unknown = 'An error occurred, try again';
  static const String connectionTimeout = 'Connection timeout';
  static const String cancel = 'Request cancelled';
  static const String receiveTimeout = 'Receive timeout';
  static const String sendTimeout = 'Send timeout';
  static const String unauthenticated = 'Session expired. Please log in';
  static const String badCertificate = 'Bad request certificate';
  static const String notVerified = 'User not verified';
  static const String emailInUse = 'Email already in use';
  static const String invalidEmail = 'Email is not valid';
  static const String weakPassword = 'Password too weak';
  static const String userNotFound = 'No account found for provided email';
  static const String wrongPassword = 'Password too weak';
  static const String invalidCredential = 'Email or password is invalid';
  static const String tooManyRequests =
      'Too many requests. Try again after some time';
}
