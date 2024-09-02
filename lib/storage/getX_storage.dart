import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageController extends GetxController {
  final storage = GetStorage();



  void saveTokenData({required String value}) {
    storage.write(StorageKeys.deviceToken, value);
  }

  Future<String> getTokenData() async {
    final token = await storage.read(StorageKeys.deviceToken) ?? "";
    return token;
  }

  void saveUserId({required String value}) {
    storage.write(StorageKeys.userId, value);
  }

  Future<String> getUserId() async {
    final token = await storage.read(StorageKeys.userId) ?? "";
    return token;
  }


  void clearOutLetSession() {
    storage.write(StorageKeys.userId, 0);
    storage.write(StorageKeys.deviceToken, 0);

  }



}
class StorageKeys {
  static const String userId = 'userId';
  static const String deviceToken = 'deviceToken';


}