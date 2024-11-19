import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontSizeManager {
  static double get f10 => 10.sp.clamp(10, 11);
  static double get f12 => 12.sp.clamp(12, 13);
  static double get f14 => 14.sp.clamp(14, 16);
  static double get f16 => 16.sp.clamp(16, 18);
  static double get f18 => 18.sp.clamp(18, 21);
  static double get f20 => 20.sp.clamp(20, 24);
  static double get f24 => 24.sp.clamp(24, 30);
  static double get f30 => 30.sp.clamp(30, 35);
  static double get f48 => 48.sp.clamp(48, 55);
}
