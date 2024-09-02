import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonGreyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;

  final TextInputAction textInputAction;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final Color? textFieldFillColor;
  final void Function(String)? onChanged;

  const CommonGreyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.padding,
    this.hintStyle,
    this.borderColor = Colors.grey,
    this.onChanged,
    this.suffix,
    this.textFieldFillColor,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: textFieldFillColor ?? Colors.grey[200],
          hintText: hintText,
          suffixIcon: suffix,
          hintStyle: hintStyle ??
              TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
        ),
      ),
    );
  }
}
