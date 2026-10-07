import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this.repository);

  final UserRepository repository;

  Future<List<User>> call() {
    return repository.getUsers();
  }
}
