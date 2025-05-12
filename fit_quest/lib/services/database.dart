import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('user');

  Future updateUserData(
    String name,
    int age,
    double weight,
    double height,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
    });
  }

  UserData mapUser(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
      age: snapshot["age"],
      weight: snapshot["weight"],
      height: snapshot["height"],
      // lvl: snapshot["lvl"],
      // exp: snapshot["exp"],
      // health: snapshot["health"],
      // attributes: snapshot["attributes"],
      // badges: snapshot["badges"],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(mapUser);
  }
}
