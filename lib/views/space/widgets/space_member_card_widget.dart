import 'package:flutter/material.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/text.dart';

class SpaceMemberCardWidget extends StatelessWidget {
  SpaceMemberCardWidget({Key? key, required this.user}) : super(key: key);
  final user;

  final numberFormat = TextFormat.numberFormat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    user.displayName,
                    style: AppFonts.text.headlineMedium?.copyWith(fontSize: 24),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Row(
                    children: [
                      const Icon(Icons.shopping_cart),
                      Text(
                        '${user.itemsCount}',
                        style: AppFonts.text.labelMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Text(
                    numberFormat.format(user.totalPrice / 100),
                    style: AppFonts.text.labelMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
