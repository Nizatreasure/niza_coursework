import 'package:either_dart/either.dart';

import '../../../../core/common/network/data_failure.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LogoutUseCase implements BaseUseCase<dynamic, dynamic> {
  final AuthenticationRepository _authRepository;
  LogoutUseCase(this._authRepository);
  @override
  Future<Either<DataFailure, dynamic>> execute({required dynamic params}) {
    return _authRepository.logout();
  }
}
