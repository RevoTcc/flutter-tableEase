enum AuthMode { signUp, login }

class AuthFormModel {
  String name = '';
  String email = '';
  String password = '';
  AuthMode _mode = AuthMode.login;

  bool get isLogin {
    return _mode == AuthMode.login;
  }

  bool get isSignUp {
    return _mode == AuthMode.signUp;
  }

  void toggleAuthMode() {
    _mode = isLogin ? AuthMode.signUp : AuthMode.login;
  }
}
