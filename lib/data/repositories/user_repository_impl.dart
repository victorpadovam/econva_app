import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this.remoteDataSource);

  final UserRemoteDataSource remoteDataSource;

  @override
  Future<List<User>> getUsers() {
    return remoteDataSource.getUsers();
  }
}
