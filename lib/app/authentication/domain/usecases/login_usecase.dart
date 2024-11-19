import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/network/data_failure.dart';
import '../../../../core/common/usecase/usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginUseCase
    implements BaseUseCase<Map<String, dynamic>, UserCredential> {
  final AuthenticationRepository _authRepository;
  LoginUseCase(this._authRepository);
  @override
  Future<Either<DataFailure, UserCredential>> execute(
      {required Map<String, dynamic> params}) {
    return _authRepository.login(
        email: params['email'], password: params['password']);
  }
}
