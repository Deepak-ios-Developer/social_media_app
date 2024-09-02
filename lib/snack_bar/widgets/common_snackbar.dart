



import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../app_colors/common_app_colours.dart';

showSnackBar(
    {required String title,
      required String msg,
    }) {
  Get.closeCurrentSnackbar();
  return Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.TOP,
    backgroundColor: AppColors.kGetSnackBarColor.value,
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(seconds: 1),
  );
}