import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commarce/models/user_data.model.dart';

abstract class AppConfigService {
  static UserData? currentUser;

  static Future<void> refreshUserData(
      {DocumentSnapshot<Map<String, dynamic>>? dataFromFirebase}) async {
    DocumentSnapshot<Map<String, dynamic>>? dataSnap;

    if (dataFromFirebase == null) {
      dataSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
    } else {
      dataSnap = dataFromFirebase;
    }

    currentUser = UserData.fromJson(dataSnap.data() ?? {}, dataSnap.id);
  }
}
