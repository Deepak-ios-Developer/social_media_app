import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/storage/getX_storage.dart';
import 'package:social_media/login/view/login_page.dart';
import 'package:social_media/feeds_page/views/feeds_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Get.find<GetStorageController>().getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          // Navigate to FeedScreen if userId is available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => const FeedScreen());
          });
        } else {
          // Navigate to LoginPage if userId is not available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(() => const LoginPage());
          });
        }
        return const Scaffold(
          body: Center(
            child: Icon(Icons.check, size: 100.0),
          ),
        );
      },
    );
  }
}
