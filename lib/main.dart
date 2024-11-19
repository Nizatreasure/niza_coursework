import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/app_router.dart';
import 'core/values/string_manager.dart';
import 'core/values/theme_manager.dart';
import 'globals.dart';

void main() async {
  await Globals.initialize();
  runApp(NizaCoursework());
}

class NizaCoursework extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const NizaCoursework._internal();

  static const NizaCoursework instance = NizaCoursework._internal();

  factory NizaCoursework() => instance;

  @override
  State<NizaCoursework> createState() => _NizaCourseworkState();
}

class _NizaCourseworkState extends State<NizaCoursework> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: StringManager.appTitle,
            routeInformationParser: MyAppRouter.router.routeInformationParser,
            routerDelegate: MyAppRouter.router.routerDelegate,
            routeInformationProvider:
                MyAppRouter.router.routeInformationProvider,
            theme: ThemeManager.getDarkTheme(),
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
