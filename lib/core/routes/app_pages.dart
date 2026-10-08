import 'package:econva_app/presentation/pages/create_account/bindings/create_account_binding.dart';
import 'package:get/get.dart';

import '../../presentation/pages/create_account/create_account_page.dart';
import '../../presentation/pages/first_access/bindings/first_access_binding.dart';
import '../../presentation/pages/first_access/first_access_page.dart';
import '../../presentation/pages/home/bindings/home_binding.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/splash_page/splash_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.createAccount,
      page: CreateAccountPage.new,
      binding: CreateAccountBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: SplashPage.new,
    ),
    GetPage<dynamic>(
      name: AppRoutes.firstAccess,
      page: FirstAccessPage.new,
      binding: FirstAccessBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 1200),
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: HomePage.new,
      binding: HomeBinding(),
    ),
  ];
}
