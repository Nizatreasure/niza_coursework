import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:retrofit/retrofit.dart';

import '../common/enums/enums.dart';
import '../common/network/connection_checker.dart';
import '../common/network/data_failure.dart';

class NetworkRequestService {
  final ConnectionChecker _connectionChecker;
  NetworkRequestService(this._connectionChecker);

  Future<Either<DataFailure, Output>> makeRequest<Output>(
      {required Future<HttpResponse<Output>> Function() request}) async {
    if (await _connectionChecker.isConnected) {
      try {
        final httpResponse = await request();
        if (httpResponse.response.statusCode == HttpStatus.ok ||
            httpResponse.response.statusCode == HttpStatus.created) {
          return Right(httpResponse.data);
        } else {
          return Left(
            DataFailure(
              statusCode:
                  httpResponse.response.statusCode ?? ResponseCode.unknown,
              message: httpResponse.response.statusMessage ??
                  ResponseMessage.unknown,
            ),
          );
        }
      } catch (e) {
        return Left(ErrorHandler.handleError(e).failure);
      }
    } else {
      return Left(DataStatus.connectionError.getFailure()!);
    }
  }
}
