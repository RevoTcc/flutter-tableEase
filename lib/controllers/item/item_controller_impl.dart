import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:table_ease/controllers/item/item_controller.dart';
import 'package:table_ease/controllers/space/space_controller.dart';
import 'package:table_ease/controllers/user/user_controller.dart';
import 'package:table_ease/models/item/item_model.dart';
import 'package:table_ease/services/firebase_service.dart';

class ItemControllerImpl implements ItemController {
  final databaseReference = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Future<void> addItem(
    String spaceId,
    Item item,
  ) async {
    final itemsInCollection =
        FirebaseService.spacesCollection.doc(spaceId).collection("items");

    final orderData = {
      'description':
          item.description.isEmpty ? "Sem descrição" : item.description,
      'price': item.price.toString().isEmpty ? 0 : item.price,
      'category': item.category,
      'categoryIcon': item.categoryIcon,
      'userId': item.userId.isEmpty
          ? FirebaseAuth.instance.currentUser!.uid
          : item.userId,
      'userName': item.userName.isEmpty
          ? FirebaseAuth.instance.currentUser!.displayName
          : item.userName,
      'createdAt': item.createdAt.toIso8601String(),
    };

    await UserController().addItemData(spaceId, item.price);
    await SpaceController().addItemDetails(spaceId, item.price);

    await itemsInCollection.doc().set(orderData);
  }

  @override
  Future<void> removeItem(
    String spaceId,
    String itemId,
    double itemPrice,
  ) async {
    final itemsCollection =
        FirebaseService.spacesCollection.doc(spaceId).collection('items');

    await itemsCollection.doc(itemId).delete();
  }
}
