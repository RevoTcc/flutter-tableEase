import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:table_ease/services/firebase_service.dart';

import 'space_controller.dart';

class SpaceControllerImpl implements SpaceController {
  final databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> addMemberToSpace(String spaceId, String? displayName) async {
    User? user = auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      await FirebaseService.spacesCollection
          .doc(spaceId)
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': uid,
        'displayName': displayName,
      }, SetOptions(merge: true));
    }
  }

  @override
  Future<bool> checkSpaceExistence(String spaceId) async {
    final space = await FirebaseService.spacesCollection.doc(spaceId).get();
    if (space.exists) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> createSpace(int spaceId) async {
    await FirebaseService.spacesCollection.doc(spaceId.toString()).set({});

    addMemberToSpace(spaceId.toString(), auth.currentUser!.displayName);
  }

  @override
  Future<void> addItemDetails(String spaceId, double debt) async {
    await FirebaseService.spacesCollection.doc(spaceId).update({
      'debt': FieldValue.increment(double.parse(debt.toString())),
      'totalItens': FieldValue.increment(1),
    });
  }

  @override
  Future<void> removeItemDetails(String spaceId, double debt) async {
    await FirebaseService.spacesCollection.doc(spaceId).update({
      'debt': FieldValue.increment(double.parse(debt.toString()) * -1),
      'totalItens': FieldValue.increment(-1),
    });
  }
}
