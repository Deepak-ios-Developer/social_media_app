import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/bindinds/app_bindings.dart';
import 'package:social_media/feeds_page/views/feeds_page.dart';

import '../login/view/login_page.dart';


class AppRoutes {
  static const home = '/';
  static const loginPage = '/loginPage';
  static const feedsPage = '/feedsPage';


}

List<GetPage> routes = [
  GetPage(
    name: AppRoutes.loginPage,
    page: () => const LoginPage(),
    binding: AppBindings(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.feedsPage,
    page: () =>  FeedScreen(),
    binding: AppBindings(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),

];

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve!,
        ),
        child: child,
      ),
    );
  }
}
