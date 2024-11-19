import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../values/color_manager.dart';

class CustomLoader {
  static BuildContext? _context;

  static showLoader() async {
    if (_context?.mounted ?? false) {
      dismissLoader();
    }

    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      barrierColor: ColorManager.darkBlue.withOpacity(0.1),
      context: NizaCoursework.navigatorKey.currentContext!,
      builder: (pageContext) {
        _context = pageContext;
        double size = 50.w.clamp(50, 80);
        return PopScope(
          canPop: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        color: ColorManager.transparent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size,
                    width: size,
                    child: SpinKitFoldingCube(
                      size: size,
                      itemBuilder: (context, index) {
                        return DecoratedBox(
                          decoration: const BoxDecoration(),
                          child: Container(
                            margin: EdgeInsetsDirectional.all(1.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.w),
                              border: Border.all(
                                color: index % 2 == 0
                                    ? ColorManager.blue
                                    : ColorManager.darkBlue,
                                width: 5.w.clamp(5, 8),
                              ),
                              color: index % 2 == 0
                                  ? ColorManager.darkBlue
                                  : ColorManager.blue,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static dismissLoader() async {
    if (_context != null) {
      _context!.pop();
      _context = null;
    }
  }
}
