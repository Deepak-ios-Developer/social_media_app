


import 'package:get/get.dart';
import 'package:social_media/feeds_page/controller/feeds_controller.dart';
import '../login/controller/login_controller.dart';
import '../storage/getX_storage.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetStorageController>(() => GetStorageController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<FeedController>(() => FeedController());





  }
}