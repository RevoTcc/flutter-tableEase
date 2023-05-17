import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_ease/models/authentication/user_auth_model.dart';
import 'package:table_ease/models/item/item_model.dart';
import 'package:table_ease/services/firebase_service.dart';

import 'user_controller.dart';

class UserControllerImpl implements UserController {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Future<void> saveCostumer(UserAuth user) {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
    });
  }

  @override
  Future<void> addItemData(
    String spaceId,
    double itemPrice,
  ) async {
    final members =
        FirebaseService.spacesCollection.doc(spaceId).collection('users');

    await members.doc(user!.uid).update({
      'itemsCount': FieldValue.increment(1),
      'totalPrice': FieldValue.increment(itemPrice),
    });
  }

  @override
  Future<void> removeItemData(
    String spaceId,
    Item item,
  ) async {
    final members =
        FirebaseService.spacesCollection.doc(spaceId).collection('users');

    DocumentReference userRef = members.doc(item.userId);

    await userRef.update({
      'totalPrice': FieldValue.increment(-item.price),
      'itemsCount': FieldValue.increment(-1),
    });
  }
}
