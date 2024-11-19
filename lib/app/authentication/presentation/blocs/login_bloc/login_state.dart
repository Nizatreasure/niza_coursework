part of 'login_bloc.dart';

@immutable
class LoginState {
  final String email;
  final String password;
  final bool showPassword;
  final FormSubmissionStatus status;

  bool get areFieldsValid =>
      EmailValidator.validate(email) && password.isNotEmpty;

  const LoginState({
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.status = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? showPassword,
    FormSubmissionStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      status: status ?? this.status,
    );
  }
}
