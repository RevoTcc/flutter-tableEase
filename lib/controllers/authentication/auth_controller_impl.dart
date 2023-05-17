import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:table_ease/controllers/authentication/auth_controller.dart';
import 'package:table_ease/controllers/user/user_controller.dart';
import 'package:table_ease/models/authentication/user_auth_model.dart';

class AuthControllerImpl implements AuthController {
  static UserAuth? _currentUser;
  static final _userStream = Stream<UserAuth?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toCostumer(user);
      controller.add(_currentUser);
    }
  });

  @override
  UserAuth? get currentUser {
    return _currentUser;
  }

  @override
  Stream<UserAuth?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
      String name,
      String email,
      String password,
      ) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return;

    await credential.user?.updateDisplayName(name);

    await login(email, password);

    _currentUser = _toCostumer(
      credential.user!,
      name,
    );
    await UserController().saveCostumer(_currentUser!);

    await signup.delete();
  }

  @override
  Future<void> login(
      String email,
      String password,
      ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  static UserAuth _toCostumer(User user, [String? name]) {
    return UserAuth(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
    );
  }
}