import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeView extends StatelessWidget {
  WelcomeView({Key? key, required this.doneWelcomeView}) : super(key: key);
  void Function() doneWelcomeView;

  final List<PageViewModel> pages = [
    PageViewModel(
      title: "O table ease chegou",
      body:
          "Adeus aos maus entendidos e discussões sobre quem consumiu o quê, o table ease resolve tudo para você!",
      image: Center(),
    ),
    PageViewModel(
      title: "Crie ou entre em um space",
      body: "Com ele, você consegue ter o controle de tudo sem complicação",
      image: const Center(
        child: Icon(Icons.workspaces, size: 100,),
      ),
    ),
    PageViewModel(
      title: "Adicione itens",
      body: "É tão simples que não leva nem 30 segundos.",
      image: Center(
        child: Icon(Icons.add, size: 100,),
      ),
    ),
    PageViewModel(
      title: "Visualize todos os itens",
      body: "Veja em tempo real quando alguém adiciona um novo item.",
      image: const Center(
        child: Icon(Icons.shopping_cart, size: 100,),
      ),
    ),
    PageViewModel(
        title: "Calcule tudo",
        body: "De forma prática e sem esforço",
        image: Center(
          child: Icon(Icons.calculate, size: 100,),
        ))
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      dotsDecorator: DotsDecorator(
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      skip: Center(child: Text("Pular")),
      showSkipButton: true,
      pages: pages,
      showNextButton: true,
      next: Icon(Icons.arrow_forward_outlined),
      showBackButton: false,
      done: Text("Feito"),
      onDone: () {
        doneWelcomeView();
      },
    );
  }
}
