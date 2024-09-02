import 'package:flutter/material.dart';
import 'package:social_media/app_colors/common_app_colours.dart';

import '../app_loader/app_loader.dart';


class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final String? secondaryText;
  final TextStyle? style;
  final TextStyle? secondaryTextStyle;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color borderColor;
  final double? height;
  final double? width;
  final bool? isLoader;
  final double? borderRadius;
  final LinearGradient? linearColor;

  const CustomButton(
      {super.key,
        required this.text,
        this.secondaryText,
        this.onTap,
        this.style,
        this.secondaryTextStyle,
        this.padding,
        this.color,
        this.height,
        this.width,
        this.borderColor = Colors.transparent,
        this.borderRadius,
        this.isLoader = false,
        this.linearColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
        child: Material(
          color: color ?? AppColors.kPrimaryColour.value,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: height ?? 50,
              width: width ?? 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius ?? 25),
                  border: Border.all(color: borderColor)),
              child: isLoader == true
                  ? AppLoader(
                color: AppColors.kSecondaryColour.value,
              )
                  : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: style ??
                          TextStyle(
                            color: AppColors.kSecondaryColour.value,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    if (secondaryText?.isNotEmpty ?? false) ...[
                      Text(
                        "$secondaryText",
                        style: secondaryTextStyle ??
                            TextStyle(
                              color:
                              AppColors.kSecondaryColour.value,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
