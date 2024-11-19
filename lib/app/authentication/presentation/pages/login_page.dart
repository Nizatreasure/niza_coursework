import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/form_submission/form_submission.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_dialog.dart';
import '../../../../core/common/widgets/custom_input_field.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/values/color_manager.dart';
import '../../../../core/values/string_manager.dart';
import '../../../../di.dart';
import '../blocs/login_bloc/login_bloc.dart';

part '../widgets/login_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocProvider<LoginBloc>(
      create: (context) => getIt(),
      child: Scaffold(
        backgroundColor: themeData.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 24.r),
              child: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state.status is SubmissionFailure) {
                      showCustomDialog(
                        context,
                        title: StringManager.error,
                        confirmButtonText: StringManager.close,
                        body: (state.status as SubmissionFailure)
                            .exception
                            .message!,
                      );
                    } else if (state.status is SubmissionSuccess) {
                      context.goNamed(RouteNames.homepage);
                    }
                  },
                  child: _buildBody(context, themeData)),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData themeData) {
    bool largeScreen = MediaQuery.of(context).size.width >= 600;

    return largeScreen
        ? Align(
            alignment: const Alignment(0, -0.3),
            child: Container(
              padding: EdgeInsetsDirectional.all(25.r),
              decoration: BoxDecoration(
                  color: ColorManager.mediumGrey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r)),
              constraints: BoxConstraints(maxWidth: 700.r),
              child: _buildDisplay(context, themeData),
            ),
          )
        : _buildDisplay(context, themeData);
  }

  Widget _buildDisplay(BuildContext context, ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringManager.login,
          style: themeData.textTheme.bodyLarge,
        ),
        Gap(32.r),
        _buildEmailField(context),
        Gap(24.r),
        _buildPasswordField(context),
        Gap(24.r),
        _loginButton(context, themeData),
        Gap(30.r)
      ],
    );
  }
}
