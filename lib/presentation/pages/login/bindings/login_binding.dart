import 'package:econva_app/presentation/pages/login/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(LoginController.new);
  }
}
