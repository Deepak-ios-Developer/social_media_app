import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/bindinds/app_bindings.dart';
import 'package:social_media/login/view/login_page.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/splash_screen/splash_screen.dart';
import 'package:social_media/storage/getX_storage.dart';
import 'login/controller/login_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeLocalNotification();
  try {
    await Firebase.initializeApp();
    getDeviceToken();

  } catch (e) {
    print('Error initializing Firebase: $e');
  }  runApp(const MyApp());
}

void initializeLocalNotification() {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');



  final DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  final InitializationSettings initializationSettings =
  InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin);



}

Future selectNotification(String? payload) async {
  // Handle the notification tapped logic here
}

Future onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // Handle the notification received logic here
}


Future<void> getDeviceToken() async {
  try {
    await requestPermission();
    var deviceToken = await FirebaseMessaging.instance.getToken();
    print("Device Token: $deviceToken");


  } catch (e) {
    print("deviceToken ERROR--->${e.toString()}");
  }
}

Future<void> requestPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }
}






class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).orientation == Orientation.landscape
          ? const Size(640, 360) // Landscape design size
          : const Size(360, 640), // Portrait design size
      minTextAdapt: true,
      splitScreenMode: true,
      child: const SplashScreen(),
      builder: (BuildContext context, Widget? child) {
        return _runMainApp(child: child);
      },
    );
  }
}
GetMaterialApp _runMainApp({required Widget? child}) {
  Get.put(GetStorageController());
  Get.put(LoginController());

  return GetMaterialApp(
    navigatorKey: NavigationService.navigatorKey,
    debugShowCheckedModeBanner: false,
    title: 'Swiss Admin',
    home: child,
    initialBinding: AppBindings(),
    getPages: routes,
    initialRoute: "/",
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child ?? Container(),
      );
    },
  );
}
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}