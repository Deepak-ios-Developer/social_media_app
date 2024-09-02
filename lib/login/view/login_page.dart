import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app_colors/common_app_colours.dart';
import '../../app_fonts/app_font.dart';
import '../../common_strings/app_common_strings.dart';
import '../../common_textfield/common_grey_textfield.dart';
import '../../cutom_button/custom_button.dart';
import '../controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite.value,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SizedBox(
              height: ScreenUtil().screenHeight,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
              kWelcome,
                    style: AppFontStyle.heading(
                      color: AppColors.kPrimaryColour.value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: CommonGreyTextField(
                      textFieldFillColor: Colors.white,
                      controller: controller.emailController,
                      hintText: kEnterYourMail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Obx(
                        () => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: CommonGreyTextField(
                        controller: controller.passwordController,
                        hintText: kPassword,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        obscureText: controller.showHidePassword.value,
                        textFieldFillColor: Colors.white,
                        suffix: IconButton(
                          icon: Icon(
                            !controller.showHidePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.kPrimaryColour.value,
                          ),
                          onPressed: () {
                            controller.showHidePassword.value =
                            !controller.showHidePassword.value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Obx( () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomButton(
                            color: AppColors.kPrimaryColour.value,
                            height: 35.h,
                            borderRadius: 20.h / 2,
                            isLoader: controller.apiLoading.value,
                            style: AppFontStyle.smallText(color: AppColors.kSecondaryColour.value),
                            text: kLogIn.tr,
                            onTap: () {
                              // Get.updateLocale(Locale('ar')); // For Hindi
                              // FocusScope.of(context).unfocus();
                              controller.loginBtnClicked();
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
