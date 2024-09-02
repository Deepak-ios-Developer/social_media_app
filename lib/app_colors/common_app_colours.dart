import 'package:flutter/material.dart';

enum AppColors {
  kPrimaryColour,
  kSecondaryColour,
  kPrimaryTextColour,
  kLoginBackGroundColour,
  kGetSnackBarColor,
  kBlack,
  kWhite,
  kRed,
  kGreen



}

extension AppColorHelper on AppColors {
  Color get value {
    switch (this) {
      case AppColors.kPrimaryColour:
        return const Color(0xFF000000);

      case AppColors.kSecondaryColour:
        return const Color(0xFFFFFFFF);
      case AppColors.kGetSnackBarColor:
        return const Color(0xFFF5F5F5).withOpacity(0.90);

      case AppColors.kBlack:
        return  Colors.black;

      case AppColors.kPrimaryTextColour:
        return Colors.white;

      case AppColors.kWhite:
        return Colors.white;

      case AppColors.kRed:
        return Colors.red;

      case AppColors.kGreen:
        return Colors.green;



      default:
        return const Color(0xFF212B36);
    }
  }
}

LinearGradient? primaryLinearColor = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromRGBO(217, 217, 217, 0.89),
    Color(0xFF6DC8BF),
  ],
);


