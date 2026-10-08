import 'package:econva_app/domain/usecases/get_users_use_case.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/user.dart';

class HomeController extends GetxController {
  HomeController(this.getUsersUseCase);

  final GetUsersUseCase getUsersUseCase;

  final users = <User>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      users.assignAll(await getUsersUseCase());
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
