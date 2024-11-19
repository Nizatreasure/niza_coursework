import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:niza_coursework/main.dart';
import '../../../../core/common/enums/enums.dart';
import '../../../../core/common/network/connection_checker.dart';
import '../../../../core/common/network/data_failure.dart';
import '../../../../core/routes/route_names.dart';

part '../../domain/repositories/auth_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final ConnectionChecker _connectionChecker;
  static final _auth = FirebaseAuth.instance;
  AuthenticationRepositoryImpl(this._connectionChecker);

  @override
  Future<Either<DataFailure, dynamic>> logout() async {
    await _auth.signOut();
    NizaCoursework.navigatorKey.currentContext?.goNamed(RouteNames.login);
    return const Right('');
  }

  @override
  Future<Either<DataFailure, UserCredential>> login(
      {required String email, required String password}) async {
    if (await _connectionChecker.isConnected) {
      try {
        await _auth.signOut();
        final credential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return Right(credential);
      } catch (e) {
        return Left(ErrorHandler.handleError(e).failure);
      }
    } else {
      return Left(DataStatus.connectionError.getFailure()!);
    }
  }
}
