import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final spacesCollection =
      FirebaseFirestore.instance.collection('spaces');
}
