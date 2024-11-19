import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../values/color_manager.dart';
import '../../values/font_size_manager.dart';

class CustomFields extends StatelessWidget {
  final String title;
  final String value;
  final String otherTitle;
  const CustomFields({
    required this.title,
    required this.value,
    required this.otherTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextStyle style = themeData.textTheme.bodyMedium!
        .copyWith(fontWeight: FontWeight.w600, height: 16.8 / 14);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.r, vertical: 9.r),
      decoration: BoxDecoration(
        color: ColorManager.navyBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: style,
              ),
              Opacity(
                opacity: 0,
                child: Text(otherTitle, style: style),
              )
            ],
          ),
          Gap(10.r),
          Text(
            value,
            style: themeData.textTheme.bodyMedium!.copyWith(
                color: themeData.primaryColorLight,
                fontSize: FontSizeManager.f20),
          ),
        ],
      ),
    );
  }
}
