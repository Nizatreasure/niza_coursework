part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginEmailChangedEvent extends LoginEvent {
  final String email;
  const LoginEmailChangedEvent(this.email);
}

class LoginPasswordChangedEvent extends LoginEvent {
  final String password;
  const LoginPasswordChangedEvent(this.password);
}

class LoginShowPasswordChangedEvent extends LoginEvent {
  final bool showPassword;
  const LoginShowPasswordChangedEvent(this.showPassword);
}

class LoginSubmittedEvent extends LoginEvent {}
