import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../values/color_manager.dart';
import '../../values/string_manager.dart';
import 'custom_button.dart';

Future<bool> showCustomDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmButtonText,
  bool canPop = true,
  bool showCancelButton = false,
  String cancelButtonText = StringManager.close,
  bool showErrorTitle = false,
  void Function()? onTapConfirm,
}) async {
  bool? returnValue = await showDialog(
    context: context,
    barrierDismissible: canPop,
    useRootNavigator: true,
    barrierColor: ColorManager.darkBlue.withOpacity(0.4),
    builder: (context) {
      return CustomDialog(
        canPop: canPop,
        title: title,
        body: body,
        showCancelButton: showCancelButton,
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText,
        showErrorTitle: showErrorTitle,
        onTapConfirm: onTapConfirm,
      );
    },
  );
  return returnValue == true;
}

class CustomDialog extends StatefulWidget {
  final bool canPop;
  final String title;
  final String body;
  final bool showCancelButton;
  final String cancelButtonText;
  final String confirmButtonText;
  final bool showErrorTitle;
  final void Function()? onTapConfirm;
  const CustomDialog({
    super.key,
    required this.canPop,
    required this.title,
    required this.body,
    required this.showCancelButton,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.showErrorTitle,
    required this.onTapConfirm,
  });

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return PopScope(
      canPop: widget.canPop,
      child: Dialog(
        elevation: 30.r,
        alignment: const Alignment(0, -0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500.r),
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: ColorManager.darkBlue,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: themeData.textTheme.bodyLarge!
                    .copyWith(color: widget.showErrorTitle ? Colors.red : null),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.body,
                style: themeData.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: widget.confirmButtonText,
                    width: widget.showCancelButton ? 100 : 150,
                    onTap: () {
                      if (widget.onTapConfirm != null) {
                        widget.onTapConfirm!();
                      }
                      context.pop(true);
                    },
                    height: 40,
                  ),
                  if (widget.showCancelButton)
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 24.w),
                      child: CustomButton(
                        text: widget.cancelButtonText,
                        width: 100,
                        height: 40,
                        onTap: () => context.pop(false),
                        backgroundColor: Colors.transparent,
                        borderColor: themeData.canvasColor,
                        textColor: themeData.canvasColor,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 30.h)
            ],
          ),
        ),
      ),
    );
  }
}
