import 'package:flutter/material.dart';
import 'package:table_ease/utils/colors.dart';

class CalculationEmptyListWidget extends StatelessWidget {
  const CalculationEmptyListWidget({Key? key}) : super(key: key);

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
              Icons.sentiment_satisfied_outlined,
              color: AppColors.gray50,
            ),
            Text(
              "todos os itens já foram calculados!",
              style: TextStyle(color: AppColors.gray50),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
