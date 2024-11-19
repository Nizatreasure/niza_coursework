import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../values/app_asset_manager.dart';
import '../../values/color_manager.dart';

class CustomInputField extends StatefulWidget {
  final bool readOnly;
  final double borderRadius;
  final TextEditingController? textController;
  final List<TextInputFormatter> inputFormatters;
  final String? hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String obscuringCharacter;
  final void Function()? onTap;
  final TextCapitalization? textCapitalization;
  final bool isDropdown;
  final bool isPasswordField;
  final void Function()? togglePasswordVisibility;
  final bool isPasswordVisible;
  final void Function()? onTapSecondaryAction;
  final String? secondaryActionText;
  final int? maxLength;

  const CustomInputField({
    super.key,
    this.readOnly = false,
    this.borderRadius = 6.0,
    this.textController,
    this.inputFormatters = const [],
    this.hintText,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.obscuringCharacter = "*",
    this.onTap,
    this.textCapitalization,
    this.isDropdown = false,
    this.isPasswordField = false,
    this.isPasswordVisible = false,
    this.togglePasswordVisibility,
    this.onTapSecondaryAction,
    this.secondaryActionText,
    this.maxLength,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(listener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(listener);
    super.dispose();
  }

  listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return TextFormField(
      readOnly: widget.isDropdown ? true : widget.readOnly,
      onTap: widget.onTap,
      obscureText: !widget.isPasswordVisible && widget.isPasswordField,
      textCapitalization:
          widget.textCapitalization ?? TextCapitalization.sentences,
      controller: widget.textController,
      focusNode: _focusNode,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      cursorHeight: 15.h,
      maxLength: widget.maxLength,
      cursorColor: themeData.primaryColor,
      style: themeData.textTheme.bodyMedium!.copyWith(height: 20 / 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.navyBlue.withOpacity(0.1),
        counterText: '',
        focusedBorder: _inputBorder(ColorManager.blue),
        border: _inputBorder(ColorManager.transparent),
        enabledBorder: _inputBorder(ColorManager.transparent),
        hintText: widget.hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        hintStyle: themeData.textTheme.bodyMedium!
            .copyWith(color: themeData.primaryColorLight, height: 20 / 14),
        suffixIconConstraints:
            widget.isPasswordField ? BoxConstraints(maxWidth: 40.r) : null,
        suffixIcon: widget.isDropdown
            ? _dropdownIcon()
            : widget.isPasswordField
                ? _password(themeData)
                : null,
      ),
    );
  }

  Widget _dropdownIcon() {
    return Icon(
      Icons.keyboard_arrow_down,
      color: ColorManager.white,
      size: 24.r,
    );
  }

  Widget _password(ThemeData themeData) {
    return GestureDetector(
      onTap: widget.togglePasswordVisibility,
      child: Container(
        height: 40.r,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: SvgPicture.asset(
          AppAssetManager.eye,
          width: 24.r,
          height: 24.r,
          colorFilter: ColorFilter.mode(
              widget.isPasswordVisible
                  ? themeData.primaryColor
                  : themeData.primaryColorLight,
              BlendMode.srcIn),
        ),
      ),
    );
  }

  InputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: color,
        width: 1.r,
      ),
    );
  }
}
