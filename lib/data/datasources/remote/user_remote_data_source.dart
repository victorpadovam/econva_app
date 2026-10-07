import '../../models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl();

  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: Replace this mock with your API call.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return const [
      UserModel(
        id: 1,
        name: 'Usuário Exemplo',
        email: 'usuario@exemplo.com',
      ),
    ];
  }
}
