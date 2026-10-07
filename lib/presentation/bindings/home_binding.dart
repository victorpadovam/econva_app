import 'package:get/get.dart';

import '../../data/datasources/remote/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_use_case.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRemoteDataSource>(
      () => const UserRemoteDataSourceImpl(),
    );

    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<UserRemoteDataSource>()),
    );

    Get.lazyPut<GetUsersUseCase>(
      () => GetUsersUseCase(Get.find<UserRepository>()),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetUsersUseCase>()),
    );
  }
}
