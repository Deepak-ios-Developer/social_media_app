import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:social_media/routes/app_routes.dart';
import '../../common_strings/app_common_strings.dart';
import '../../snack_bar/widgets/common_snackbar.dart';
import '../../storage/getX_storage.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GetStorageController storageController = Get.put(GetStorageController());

  RxBool apiLoading = false.obs;
  RxBool showHidePassword = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Mark

  //USER NAME --> deepaks24062000@gmail.com
  //PASSWORD --> 12345678


  void loginBtnClicked() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      showSnackBar(title: kMessage, msg: kEnterYourMail);
    } else if (password.isEmpty) {
      showSnackBar(title: kMessage, msg: kEnterPassword);
    } else {
      apiLoading.value = true;
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        showSnackBar(title: kMessage, msg: kSuccess);
        storageController.saveUserId(value: userCredential.user?.uid ?? '');
        Get.toNamed(AppRoutes.feedsPage);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = 'Login failed. Please try again.';
        }
        showSnackBar(title: kMessage, msg: errorMessage);
      } finally {
        apiLoading.value = false;
      }
    }
  }
}
