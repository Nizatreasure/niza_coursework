import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:niza_coursework/core/values/color_manager.dart';

import '../../values/app_asset_manager.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final dynamic value;
  const CustomDropDown({
    required this.items,
    required this.onChanged,
    this.hintText,
    this.contentPadding = const EdgeInsetsDirectional.only(end: 12),
    this.value,
    super.key,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField2<T>(
          items: widget.items,
          onChanged: widget.onChanged,
          value: widget.value,
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(5.r),
            ),
            maxHeight: 350.r,
          ),
          style: themeData.textTheme.bodyMedium,
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            selectedMenuItemBuilder: (context, child) {
              return Container(
                color: ColorManager.navyBlue.withOpacity(0.1),
                child: child,
              );
            },
          ),
          iconStyleData: IconStyleData(
              icon: SvgPicture.asset(
            AppAssetManager.dropdownArrow,
          )),
          hint: widget.hintText == null
              ? null
              : Text(widget.hintText!,
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(color: ColorManager.mediumGrey)),
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorManager.navyBlue.withOpacity(0.1),
            contentPadding: widget.contentPadding,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.blue,
                width: 1.r,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.blue,
                width: 1.r,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.blue,
                width: 1.r,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }
}
