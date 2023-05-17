import 'package:flutter/material.dart';
import 'package:table_ease/utils/colors.dart';

class EmptyItemView extends StatelessWidget {
  const EmptyItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.sentiment_dissatisfied_outlined,
              color: AppColors.gray50,
            ),
            Text(
              "nenhum item adicionado. Que tal adicionar algo para começar?",
              style: TextStyle(color: AppColors.gray50),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
