part of '../pages/login_page.dart';

Widget _buildPasswordField(BuildContext context) {
  LoginBloc loginBloc = context.read<LoginBloc>();
  return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.showPassword != current.showPassword,
      builder: (context, state) {
        return CustomInputField(
          hintText: StringManager.enterPassword,
          obscureText: !state.showPassword,
          textController: loginBloc.passwordController,
          obscuringCharacter: '*',
          keyboardType: TextInputType.visiblePassword,
          onChanged: (password) =>
              loginBloc.add(LoginPasswordChangedEvent(password)),
          isPasswordField: true,
          isPasswordVisible: state.showPassword,
          togglePasswordVisibility: () =>
              loginBloc.add(LoginShowPasswordChangedEvent(!state.showPassword)),
        );
      });
}

Widget _buildEmailField(BuildContext context) {
  LoginBloc loginBloc = context.read<LoginBloc>();
  return BlocBuilder<LoginBloc, LoginState>(
    buildWhen: (previous, current) => previous.email != current.email,
    builder: (context, state) {
      return CustomInputField(
        hintText: StringManager.enterEmail,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        textController: loginBloc.emailController,
        onChanged: (email) => loginBloc.add(LoginEmailChangedEvent(email)),
      );
    },
  );
}

Widget _loginButton(BuildContext context, ThemeData themeData) {
  return Column(
    children: [
      BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return CustomButton(
          text: StringManager.login,
          onTap: state.areFieldsValid
              ? () {
                  context.read<LoginBloc>().add(LoginSubmittedEvent());
                }
              : null,
        );
      }),
    ],
  );
}
