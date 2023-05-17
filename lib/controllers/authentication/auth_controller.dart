import 'package:table_ease/models/authentication/user_auth_model.dart';

import 'auth_controller_impl.dart';

abstract class AuthController {
  UserAuth? get currentUser;

  Stream<UserAuth?> get userChanges;

  Future<void> signup(
      String name,
      String email,
      String password,
      );

  Future<void> login(
      String email,
      String password,
      );

  Future<void> logout();

  factory AuthController() {
    return AuthControllerImpl();
  }
}