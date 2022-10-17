import 'package:circuit4driver/modules/Home/home.dart';
import 'package:circuit4driver/modules/appPages/routes.dart';
import 'package:circuit4driver/modules/login/login.dart';
import 'package:circuit4driver/modules/login/loginBinding.dart';
import 'package:circuit4driver/modules/register/register.dart';
import 'package:circuit4driver/modules/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  final initial = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.Splash,
      page: () => SplashScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const Register(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const Home(),
      binding: LoginBinding(),
    ),
  ];
}
