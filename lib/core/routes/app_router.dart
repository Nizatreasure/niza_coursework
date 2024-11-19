import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/authentication/presentation/pages/login_page.dart';
import '../../app/home/presentation/blocs/homepage_bloc/homepage_bloc.dart';
import '../../app/home/presentation/pages/homepage.dart';
import '../../app/home/presentation/pages/plot.dart';
import '../../main.dart';
import 'route_names.dart';

class MyAppRouter {
  static GoRouter router = GoRouter(
    navigatorKey: NizaCoursework.navigatorKey,
    // initialLocation: RouteNames.homepage,
    // initialLocation: '${RouteNames.profile}/${RouteNames.changeTheme}',
    // initialExtra: MessagesLocalDataSource.messages[1],
    routes: [
      GoRoute(
        name: RouteNames.login,
        path: RouteNames.login,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
          name: RouteNames.homepage,
          path: RouteNames.homepage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: Homepage(),
            );
          },
          routes: [
            GoRoute(
              name: RouteNames.plot,
              path: RouteNames.plot,
              pageBuilder: (context, state) {
                HomepageBloc? bloc = state.extra is HomepageBloc
                    ? state.extra as HomepageBloc
                    : null;
                return MaterialPage(
                  child: bloc == null
                      ? const Scaffold()
                      : PlotPage(homepageBloc: bloc),
                );
              },
            ),
          ]),
    ],
  );
}
