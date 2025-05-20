import 'package:flutter/cupertino.dart';
import 'package:navatech_task/modules/home/ui/home_screen.dart';
import 'package:navatech_task/modules/home/ui/splash_screen.dart';

class Routes {
  static const initial = '/';
  static const splashScreen = '/splashScreen';
  static const homeScreen = '/homeScreen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    homeScreen: (context) => const HomeScreen(),
  };
}
