import 'package:either_dart/either.dart';

import '../network/data_failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<DataFailure, Out>> execute({required In params});
}
