import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'color_manager.dart';
import 'font_size_manager.dart';

class ThemeManager {
  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: ColorManager.darkBlue,
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      textTheme: TextTheme(
        bodyLarge: _boldTextStyle(),
        bodyMedium: _normalTextStyle(),
      ),
      disabledColor: ColorManager.blue.withOpacity(0.2),
      primaryColor: ColorManager.white,
      primaryColorLight: ColorManager.mediumGrey,
    );
  }

  static TextStyle _boldTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? ColorManager.white,
      fontSize: fontSize ?? FontSizeManager.f24,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontFamily: AppConstants.fontFamily,
    );
  }

  static TextStyle _normalTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? ColorManager.white,
      fontSize: fontSize ?? FontSizeManager.f14,
      fontWeight: fontWeight ?? FontWeight.w400,
      fontFamily: AppConstants.fontFamily,
    );
  }
}
