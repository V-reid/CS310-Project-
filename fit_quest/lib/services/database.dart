import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('user');

  Future updateUserData(UserData u) async {
    return await userCollection.doc(uid).set({
      'name': u.name,
      'age': u.age,
      'weight': u.weight,
      'height': u.height,
      "profilePic": u.profilePic,
      "lvl": u.lvl,
      "exp": u.exp,
      "health": u.health,
      "attributes": u.attributes,
      "badges": u.badges,
    });
  }

  UserData mapUser(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
      age: snapshot["age"],
      weight: snapshot["weight"],
      height: snapshot["height"],
      profilePic: snapshot["profilePic"],
      lvl: snapshot["lvl"],
      exp: List<double>.from(snapshot.get("exp")),
      health: List<double>.from(snapshot.get("health")),
      attributes: List<Attribute>.from(snapshot.get("attributes")),
      badges: List<ProfileBadge>.from(snapshot.get("badges")),
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(mapUser);
  }
}
