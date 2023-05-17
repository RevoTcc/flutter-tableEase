import 'package:flutter/material.dart';
import 'package:table_ease/controllers/item/item_controller.dart';
import 'package:table_ease/controllers/space/space_controller.dart';
import 'package:table_ease/controllers/user/user_controller.dart';
import 'package:table_ease/utils/colors.dart';
import 'package:table_ease/utils/messenger.dart';
import 'package:table_ease/utils/text.dart';
import 'package:timeago/timeago.dart' as timeago;

class SpaceItemCardWidget extends StatefulWidget {
  SpaceItemCardWidget({Key? key, required this.item, required this.spaceId})
      : super(key: key);
  final item;
  final spaceId;

  @override
  State<SpaceItemCardWidget> createState() => _SpaceItemCardWidgetState();
}

class _SpaceItemCardWidgetState extends State<SpaceItemCardWidget> {
  bool isDeleting = false;

  final numberFormat = TextFormat.numberFormat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.item.description,
            ),
            Text(
              numberFormat.format(widget.item.price / 100),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.item.userName,
            ),
            Text(
              timeago.format(
                widget.item.createdAt,
                locale: 'pt_br',
                allowFromNow: true,
              ),
            ),
          ],
        ),
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            IconData(
              int.parse(widget.item.categoryIcon),
              fontFamily: 'MaterialIcons',
            ),
          ),
        ),
        trailing: isDeleting
            ? SizedBox(child: const CircularProgressIndicator())
            : IconButton(
                icon: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error),
                onPressed: () async {
                  setState(() {
                    isDeleting = true;
                  });
                  try {
                    await UserController()
                        .removeItemData(
                          widget.spaceId.toString(),
                          widget.item,
                        )
                        .timeout(
                          Duration(seconds: 5),
                        );
                    await SpaceController()
                        .removeItemDetails(
                          widget.spaceId.toString(),
                          widget.item.price,
                        )
                        .timeout(
                          Duration(seconds: 5),
                        );
                    await ItemController()
                        .removeItem(
                          widget.spaceId.toString(),
                          // Room Password
                          widget.item.id, // Order key
                          double.parse(
                            widget.item.price.toString(),
                          ), // OrderValue
                        )
                        .timeout(
                          const Duration(seconds: 5),
                        );
                    if (context.mounted) {
                      Messenger.showMessage(
                        context,
                        "Item removido com sucesso",
                        AppColors.success,
                      );
                    }
                    setState(() {
                      isDeleting = false;
                    });
                  } catch (e) {
                    Messenger.showMessage(
                      context,
                      "Houve um erro em remover o item",
                      AppColors.error,
                    );
                    setState(() {
                      isDeleting = false;
                    });
                  }
                },
              ),
      ),
    );
  }
}
