part of '../../data/repositories/auth_repository_impl.dart';

abstract class AuthenticationRepository {
  Future<Either<DataFailure, UserCredential>> login(
      {required String email, required String password});
  Future<Either<DataFailure, dynamic>> logout();
}
