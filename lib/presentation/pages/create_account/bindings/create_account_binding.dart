import 'package:econva_app/presentation/pages/create_account/controller/create_account_controller.dart';
import 'package:get/get.dart';

class CreateAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountController>(CreateAccountController.new);
  }
}
