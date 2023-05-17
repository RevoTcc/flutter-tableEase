import 'package:flutter/material.dart';
import 'package:table_ease/models/item/item_model.dart';
import 'package:table_ease/services/firebase_service.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/text.dart';
import 'package:table_ease/views/general/empty_item_view.dart';
import 'package:table_ease/views/space/widgets/space_item_card_widget.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class ItemsTab extends StatelessWidget {
  ItemsTab({Key? key, required this.spaceId}) : super(key: key);

  final int spaceId;

  final numberFormat = TextFormat.numberFormat;

  @override
  Widget build(BuildContext context) {
    return Timeago(
      refreshRate: const Duration(seconds: 30),
      builder: (context, value) {
        return StreamBuilder(
          stream: FirebaseService.spacesCollection
              .doc("$spaceId")
              .collection('items')
              .orderBy('createdAt', descending: true)
              .snapshots()
              .map((querySnapshot) {
            final allItems = querySnapshot.docs.map((doc) {
              final data = doc.data();
              return Item(
                doc.id,
                data['description'],
                data['price'],
                data['category'],
                data['categoryIcon'],
                data['userId'],
                data['userName'],
                DateTime.parse(data['createdAt']),
              );
            }).toList();
            final totalPrice =
                allItems.fold<double>(0, (sum, p) => sum + p.price);
            final totalLength = allItems.length;
            return ItemInfo(totalLength, totalPrice, allItems);
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final itemData = snapshot.data!;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          label: Row(
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                              ),
                              Text(
                                '${itemData.total}',
                                style: AppFonts.text.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Chip(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              label: Text(
                                numberFormat.format(itemData.totalPrice / 100),
                                style: AppFonts.text.labelMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: itemData.allItems.isEmpty
                        ? EmptyItemView()
                        : ListView.builder(
                            itemCount: itemData.allItems.length,
                            itemBuilder: (context, index) {
                              final item = itemData.allItems[index];
                              return SpaceItemCardWidget(
                                  item: item, spaceId: spaceId);
                            },
                          ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: const Text('Erro ao carregar pedidos'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
      date: DateTime.now(),
    );
  }
}

class ItemInfo {
  final int total;
  final double totalPrice;
  final List<Item> allItems;

  ItemInfo(this.total, this.totalPrice, this.allItems);
}
