import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:table_ease/controllers/authentication/auth_controller.dart';
import 'package:table_ease/views/authentication/auth_view.dart';
import 'package:table_ease/views/home/home_view.dart';

class RedirectView extends StatelessWidget {
  const RedirectView({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthController().userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return snapshot.hasData ? const HomeView() : const AuthView();
        }
      },
    );
  }
}
