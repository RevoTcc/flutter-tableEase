import 'package:table_ease/controllers/item/item_controller_impl.dart';
import 'package:table_ease/models/item/item_model.dart';

abstract class ItemController {
  Future<void> addItem(
    String spaceId,
    Item item,
  );

  Future<void> removeItem(
    String spaceId,
    String itemId,
    double itemPrice,
  );

  factory ItemController() {
    return ItemControllerImpl();
  }
}
