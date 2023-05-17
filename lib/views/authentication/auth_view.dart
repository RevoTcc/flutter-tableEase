import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_ease/controllers/authentication/auth_controller.dart';
import 'package:table_ease/models/authentication/auth_form_model.dart';
import 'package:table_ease/utils/colors.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/messenger.dart';
import 'package:table_ease/views/welcome/welcome_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormModel();

  bool isLoading = false;

  late bool passwordVisibility;
  bool? showWelcomePage;

  void setShowIntroduction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showWelcomePage = false;
    await prefs.setBool("showIntroduction", false);
  }

  Future<void> loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showWelcomePage = prefs.getBool("showIntroduction") ?? true;
    });
  }

  void popWelcomeView() {
    setState(() {
      setShowIntroduction();
    });
  }

  Future<void> handleSubmit(
    AuthFormModel formData,
    BuildContext context,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (formData.isLogin) {
        await AuthController().login(
          formData.email,
          formData.password,
        );
      } else {
        await AuthController().signup(
          formData.name,
          formData.email,
          formData.password,
        );
      }
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });

      String message = "Erro padrão";

      switch (e.code) {
        case "user-not-found":
          message = "Esse usuário não existe";
          break;

        case "email-already-in-use":
          message = "Esse e-mail já está sendo utilizado";
          break;

        case "wrong-password":
          message = "A senha digitada está incorreta";
          break;
      }

      Messenger.showMessage(
        context,
        message,
        AppColors.error,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Messenger.showMessage(
          context, "Ocorreu um erro. Tente novamente", AppColors.error);
    }
  }

  @override
  void initState() {
    passwordVisibility = false;
    loadInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (showWelcomePage == null)
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: showWelcomePage ?? true
                ? WelcomeView(doneWelcomeView: popWelcomeView)
                : SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "table ease",
                            style: AppFonts.text.headlineMedium
                                ?.copyWith(fontSize: 24),
                          ),
                          Center(
                            child: Card(
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formData.isLogin
                                                ? "login"
                                                : "registre-se",
                                            style: const TextStyle(
                                                color: AppColors.gray50),
                                          ),
                                          Icon(
                                            _formData.isLogin
                                                ? Icons.login
                                                : Icons.account_box,
                                            color: AppColors.gray50,
                                          ),
                                        ],
                                      ),
                                      if (_formData.isSignUp)
                                        TextFormField(
                                          key: const ValueKey('name'),
                                          initialValue: _formData.name,
                                          onChanged: (name) =>
                                              _formData.name = name,
                                          decoration: const InputDecoration(
                                            labelText: 'Nome de usuário',
                                            icon: Icon(Icons.alternate_email),
                                          ),
                                          validator: (_name) {
                                            final name = _name ?? '';
                                            if (name.trim().length < 4) {
                                              return 'Nome muito curto. Mínmimo de 4 letras';
                                            }
                                            return null;
                                          },
                                        ),
                                      TextFormField(
                                        key: const ValueKey('email'),
                                        initialValue: _formData.email,
                                        onChanged: (email) =>
                                            _formData.email = email,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          icon: Icon(Icons.email),
                                        ),
                                        validator: (_email) {
                                          final email = _email ?? '';
                                          final bool validEmail = RegExp(
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                              .hasMatch(email);

                                          if (email.isEmpty) {
                                            return 'O email não pode estar vazio';
                                          }
                                          if (!validEmail) {
                                            return 'Email inválido';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        key: const ValueKey('password'),
                                        initialValue: _formData.password,
                                        onChanged: (password) =>
                                            _formData.password = password,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText: 'Senha',
                                          icon: Icon(Icons.password),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              passwordVisibility
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisibility =
                                                    !passwordVisibility;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (_password) {
                                          final password = _password ?? '';
                                          if (password.isEmpty) {
                                            return 'A senha não pode estar vazia';
                                          }
                                          if (password.length < 6) {
                                            return 'Sua senha deve conter no mínimo 6 caracteres';
                                          }
                                          return null;
                                        },
                                        obscureText: !passwordVisibility,
                                      ),
                                      const SizedBox(height: 12),
                                      isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ElevatedButton(
                                              onPressed: () {
                                                final isValid = _formKey
                                                        .currentState
                                                        ?.validate() ??
                                                    false;
                                                if (!isValid) return;

                                                handleSubmit(
                                                    _formData, context);
                                              },
                                              child: Text(
                                                _formData.isLogin
                                                    ? 'entrar'
                                                    : 'cadastrar',
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _formData.toggleAuthMode();
                                          });
                                        },
                                        child: Text(
                                          _formData.isLogin
                                              ? 'criar uma nova conta'
                                              : 'já possui conta?',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
  }
}
