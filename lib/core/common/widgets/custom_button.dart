import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../values/color_manager.dart';
import '../../values/font_size_manager.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showDisableState;
  final double? borderWidth;
  final Color? textColor;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final String? text;
  final Widget? child;
  final AlignmentGeometry textAlignment;
  final bool shrinkToFitChildSize;
  final EdgeInsetsGeometry? padding;
  const CustomButton({
    super.key,
    this.onTap,
    this.height = 56,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.showDisableState = true,
    this.borderColor,
    this.borderWidth,
    this.textColor,
    this.textFontSize,
    this.textFontWeight,
    this.text,
    this.child,
    this.shrinkToFitChildSize = false,
    this.textAlignment = AlignmentDirectional.center,
    this.padding,
  }) : assert(child != null || text != null,
            'You must provide a child widget or the text for the button');

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: shrinkToFitChildSize ? null : width?.r ?? double.infinity,
        padding: padding,
        height: height?.r,
        alignment: textAlignment,
        decoration: BoxDecoration(
          color: showDisableState && onTap == null
              ? themeData.disabledColor
              : backgroundColor ?? ColorManager.blue,
          borderRadius: BorderRadius.circular(borderRadius?.r ?? 8.r),
          border: Border.all(
            color: borderColor ?? ColorManager.transparent,
            width: borderWidth?.r ?? 1.r,
          ),
        ),
        child: child ??
            Text(
              text!,
              textAlign: TextAlign.center,
              style: themeData.textTheme.bodyMedium!.copyWith(
                color: textColor ??
                    (showDisableState && onTap == null
                        ? ColorManager.mediumGrey
                        : ColorManager.white),
                fontSize: textFontSize ?? FontSizeManager.f16,
                height: 24 / 16,
              ),
            ),
      ),
    );
  }
}
