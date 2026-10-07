import 'package:get/get.dart';

import '../../presentation/bindings/home_binding.dart';
import '../../presentation/pages/home_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: HomePage.new,
      binding: HomeBinding(),
    ),
  ];
}
