import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../values/color_manager.dart';

class CustomToggleButton extends StatelessWidget {
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final String tab1Text;
  final String tab2Text;
  final String selectedTab;
  final void Function()? onTapTab1;
  final void Function()? onTapTab2;
  const CustomToggleButton({
    super.key,
    this.borderRadius = 30,
    this.verticalPadding = 6,
    this.horizontalPadding = 12,
    required this.tab1Text,
    required this.tab2Text,
    required this.selectedTab,
    this.onTapTab1,
    this.onTapTab2,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextStyle style = themeData.textTheme.bodyMedium!
        .copyWith(fontWeight: FontWeight.w600, height: 16.8 / 14);
    return Row(
      children: [
        GestureDetector(
          onTap: onTapTab1,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: horizontalPadding.r, vertical: verticalPadding.r),
            decoration: BoxDecoration(
              color: tab1Text == selectedTab
                  ? ColorManager.vibrantBlue
                  : ColorManager.blue.withOpacity(0.24),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius.r),
                bottomLeft: Radius.circular(borderRadius.r),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(tab1Text, style: style),
                Opacity(opacity: 0, child: Text(tab2Text, style: style))
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onTapTab2,
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: horizontalPadding.r, vertical: verticalPadding.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tab2Text == selectedTab
                  ? ColorManager.vibrantBlue
                  : ColorManager.blue.withOpacity(0.24),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius.r),
                bottomRight: Radius.circular(borderRadius.r),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(tab2Text, style: style),
                Opacity(opacity: 0, child: Text(tab1Text, style: style))
              ],
            ),
          ),
        )
      ],
    );
  }
}
