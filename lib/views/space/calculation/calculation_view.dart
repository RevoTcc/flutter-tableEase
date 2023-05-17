import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:table_ease/models/item/item_model.dart';
import 'package:table_ease/services/firebase_service.dart';
import 'package:table_ease/utils/colors.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/text.dart';
import 'package:table_ease/views/space/calculation/widgets/calculation_empty_list_widget.dart';

class CalculationView extends StatefulWidget {
  CalculationView({required this.spaceId, Key? key}) : super(key: key);

  int spaceId;

  @override
  State<CalculationView> createState() => _CalculationViewState();
}

class _CalculationViewState extends State<CalculationView> {
  List<Item> selectedItems = [];
  double total = 0;
  int quantity = 0;
  int members = 1;

  final numberFormat = TextFormat.numberFormat;

  void selectItem(item, value) {
    item.isSelected = value;
    if (item.isSelected!) {
      selectedItems.add(item);
      total += item.price;
      quantity++;
    } else {
      selectedItems.remove(item);
      total -= item.price;
      quantity--;
    }
  }

  void dismissItem(items, item, index) {
    items.removeAt(index);
    if (item.isSelected != null && item.isSelected == true) {
      total -= item.price;
      quantity--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseService.spacesCollection
            .doc("${widget.spaceId}")
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
          return allItems;
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<Item> items = snapshot.data!;

            return StatefulBuilder(builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart),
                                    Text(
                                      ": $quantity",
                                      style: AppFonts.text.titleMedium,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on),
                                    Text(
                                      ": ${numberFormat.format(total / 100)}",
                                      style: AppFonts.text.titleMedium,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${numberFormat.format((total / (members) / 100))} /",
                                      style: AppFonts.text.titleMedium,
                                    ),
                                    const Icon(Icons.person),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: NumberPicker(
                                      axis: Axis.horizontal,
                                      itemWidth: 40,
                                      value: members,
                                      minValue: 1,
                                      maxValue: 15,
                                      onChanged: (int value) {
                                        setState(() {
                                          members = value;
                                        });
                                      },
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      selectedTextStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Text('Nº pessoas'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: items.isEmpty
                        ? const CalculationEmptyListWidget()
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              Item item = items[index];
                              return Dismissible(
                                key: Key(item.id),
                                background: Card(
                                  child: Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    color: AppColors.error,
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(Icons.delete),
                                    ),
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  setState(() {
                                    dismissItem(items, item, index);
                                  });
                                },
                                child: Card(
                                  child: CheckboxListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.description),
                                        Icon(
                                          IconData(
                                            int.parse(item.categoryIcon),
                                            fontFamily: 'MaterialIcons',
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      numberFormat.format(item.price / 100),
                                    ),
                                    value: item.isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        selectItem(item, value);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            });
          }
          return const Center(
            child: Text('Um erro aconteceu'),
          );
        },
      ),
    );
  }
}
