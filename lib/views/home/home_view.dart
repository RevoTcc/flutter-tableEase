import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_ease/controllers/authentication/auth_controller.dart';
import 'package:table_ease/controllers/space/space_controller.dart';
import 'package:table_ease/utils/colors.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/messenger.dart';
import 'package:table_ease/utils/navigator.dart';
import 'package:table_ease/views/space/space_view.dart';

import '../redirect_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isCreatingSpace = false;

  final databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;

  int spaceId = Random().nextInt(9000) + 1000;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _lastSpaceId;

  Future<void> setSpaceHistory(int spaceId) async {
    SharedPreferences prefs = await _prefs;
    int lastSpaceId = (prefs.getInt('spaceId') ?? 0);

    setState(() {
      _lastSpaceId = prefs.setInt('spaceId', spaceId).then((value) {
        return lastSpaceId;
      });
    });
  }

  @override
  void initState() {
    _lastSpaceId = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('spaceId') ?? 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo(a), ${auth.currentUser!.displayName}"),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthController().logout();
              if (context.mounted) {
                Navigation.navigatePush(context, RedirectView());
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'entrar em um space',
                            style: AppFonts.text.headlineMedium,
                          ),
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _controller,
                              decoration: const InputDecoration(
                                labelText: 'código',
                              ),
                              maxLength: 4,
                              validator: (code) {
                                if (code == null || code.isEmpty) {
                                  return 'Código vazio';
                                }
                                if (code.characters.length < 4) {
                                  return 'Código inválido';
                                }
                                if (code.characters.contains('aA-zZ')) {
                                  return 'Código inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 200,
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        bool exists = await SpaceController()
                                            .checkSpaceExistence(
                                                _controller.text);
                                        if (exists) {
                                          // O space existe
                                          try {
                                            await SpaceController()
                                                .addMemberToSpace(
                                                    _controller.text,
                                                    auth.currentUser!
                                                        .displayName)
                                                .timeout(Duration(seconds: 5));
                                            if (context.mounted) {
                                              Navigation.navigatePush(
                                                context,
                                                SpaceView(
                                                  spaceId: int.parse(
                                                      _controller.text),
                                                ),
                                              );
                                            }
                                            setSpaceHistory(
                                                int.parse(_controller.text));
                                          } catch (e) {
                                            if (context.mounted) {
                                              Messenger.showMessage(
                                                context,
                                                'Houve um erro ao acessar o space',
                                                AppColors.error,
                                              );
                                            }
                                          }
                                        } else {
                                          // O space não existe
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (context.mounted) {
                                            Messenger.showMessage(
                                              context,
                                              "O space não existe",
                                              AppColors.error,
                                            );
                                          }
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'entrar',
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("ou"),
                  ),
                  isCreatingSpace
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                isCreatingSpace = true;
                              });
                              await SpaceController()
                                  .createSpace(spaceId)
                                  .timeout(
                                    const Duration(seconds: 5),
                                  );

                              if (context.mounted) {
                                Navigation.navigatePush(
                                    context, SpaceView(spaceId: spaceId));
                              }
                              setSpaceHistory(spaceId);
                            } catch (e) {
                              setState(() {
                                isCreatingSpace = false;
                              });
                              Messenger.showMessage(
                                context,
                                'Houve um erro ao criar o space',
                                AppColors.error,
                              );
                            }
                          },
                          child: const Text(
                            'criar space',
                          ),
                        ),
                ],
              ),
              FutureBuilder(
                future: _lastSpaceId,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Houve um erro. ${snapshot.error}');
                      } else if (snapshot.data == null || snapshot.data == 0) {
                        return Text(
                          'Nenhum space recente',
                          style: AppFonts.text.titleMedium?.copyWith(color: AppColors.gray50),
                        );
                      } else {
                        return Text(
                          'último space visitado: ${snapshot.data}',
                          style: AppFonts.text.titleMedium?.copyWith(color: AppColors.gray50),
                        );
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
