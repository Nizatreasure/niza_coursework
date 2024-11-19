import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/form_submission/form_submission.dart';
import '../../../../../core/common/widgets/custom_loader.dart';
import '../../../domain/usecases/login_usecase.dart';

part 'login_events.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  TextEditingController get passwordController => _passwordController;
  TextEditingController get emailController => _emailController;

  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginState()) {
    on<LoginEmailChangedEvent>(_emailChangedEventHandler);
    on<LoginPasswordChangedEvent>(_passwordChangedEventHandler);
    on<LoginShowPasswordChangedEvent>(_showPasswordChangedEventHandler);
    on<LoginSubmittedEvent>(_loginEventHandler);
  }

  void _emailChangedEventHandler(
      LoginEmailChangedEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChangedEventHandler(
      LoginPasswordChangedEvent event, Emitter<LoginState> emit) {
    String password = event.password;
    emit(state.copyWith(password: password));
  }

  void _showPasswordChangedEventHandler(
      LoginShowPasswordChangedEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(showPassword: event.showPassword));
  }

  void _loginEventHandler(
      LoginSubmittedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      status: SubmittingForm(),
      showPassword: false,
    ));
    CustomLoader.showLoader();
    final dataState = await _loginUseCase.execute(params: {
      'email': state.email,
      'password': state.password,
    });
    CustomLoader.dismissLoader();
    if (dataState.isRight) {
      emit(state.copyWith(
          status: SubmissionSuccess<UserCredential>(dataState.right)));
    } else {
      emit(state.copyWith(status: SubmissionFailure(dataState.left)));
    }
    emit(state.copyWith(status: const InitialFormStatus()));
  }
}
