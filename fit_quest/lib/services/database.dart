// import 'dart:convert';

// import 'package:clouduserCollection/cloud_firestore.dart';
// import 'package:fit_quest/model/user.dart';

// class DatabaseService {
//   final String uid;

//   DatabaseService({required this.uid});

//   final CollectionReference userCollection = FirebaseFirestore.instance
//       .collection('user');

//   Future updateUserData(UserData u) async {
//     return await userCollection.doc(uid).set({
//       'name': u.name,
//       'age': u.age,
//       'weight': u.weight,
//       'height': u.height,
//       "profilePic": u.profilePic,
//       "lvl": u.lvl,
//       "exp": u.exp,
//       "health": u.health,
//       "attributes": u.attributes,
//       "badges": u.badges,
//     });
//   }

//   UserData mapUser(DocumentSnapshot snapshot) {
//     return UserData(
//       uid: uid,
//       name: snapshot['name'],
//       age: snapshot["age"],
//       weight: snapshot["weight"],
//       height: snapshot["height"],
//       profilePic: snapshot["profilePic"],
//       lvl: snapshot["lvl"],
//       exp: List<double>.from(snapshot.get("exp")),
//       health: List<double>.from(snapshot.get("health")),
//       attributes: List<Attribute>.from(snapshot.get("attributes")),
//       badges: List<ProfileBadge>.from(snapshot.get("badges")),
//     );
//   }

//   Stream<UserData> get userData {
//     return userCollection.doc(uid).snapshots().map(mapUser);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('user');

  Future<void> setUserData(UserData userData) async {
    await userCollection
        .doc(uid)
        .set(_userDataToMap(userData), SetOptions(merge: true));
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromMap);
  }

  Future<void> deleteUserData(String uid) async {
    await userCollection.doc(uid).delete();
  }

  Map<String, dynamic> _userDataToMap(UserData userData) {
    return {
      'uid': userData.uid,
      'name': userData.name,
      'profilePic': userData.profilePic,
      'age': userData.age,
      'weight': userData.weight,
      'height': userData.height,
      'lvl': userData.lvl,
      'exp': userData.exp,
      'health': userData.health,
      'attributes': _attributesToMap(userData.attributes),
      'badges': userData.badges.map((b) => _badgeToMap(b)).toList(),
    };
  }

  UserData _userDataFromMap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    print(data["attributes"]);
    return UserData(
      uid: data['uid'],
      name: data['name'],
      age: data['age'],
      weight: data['weight'].toDouble(),
      height: data['height'].toDouble(),
      profilePic: data['profilePic'],
      lvl: data['lvl'],
      exp: _convertDoubleArray(data['exp']),
      health: _convertDoubleArray(data['health']),
      attributes: _attributesFromMap(
        data['attributes'] as Map<String, dynamic>,
      ),
      badges: List<ProfileBadge>.from(
        (data['badges'] as List).map((b) => _badgeFromMap(b)),
      ),
    );
  }

  Map<String, dynamic> _attributesToMap(
    Map<PhysicalAbility, Attribute> attributes,
  ) {
    return {
      PhysicalAbility.strength.name: _attributeToMap(
        attributes[PhysicalAbility.strength]!,
      ),
      PhysicalAbility.endurance.name: _attributeToMap(
        attributes[PhysicalAbility.endurance]!,
      ),
      PhysicalAbility.agility.name: _attributeToMap(
        attributes[PhysicalAbility.agility]!,
      ),
      PhysicalAbility.flexibility.name: _attributeToMap(
        attributes[PhysicalAbility.flexibility]!,
      ),
      PhysicalAbility.balance.name: _attributeToMap(
        attributes[PhysicalAbility.balance]!,
      ),
    };
  }

  Map<PhysicalAbility, Attribute> _attributesFromMap(
    Map<String, dynamic> attributesMap,
  ) {
    return {
      PhysicalAbility.strength: _parseAttribute(
        attributesMap['strength'],
        PhysicalAbility.strength,
      ),
      PhysicalAbility.endurance: _parseAttribute(
        attributesMap['endurance'],
        PhysicalAbility.endurance,
      ),
      PhysicalAbility.agility: _parseAttribute(
        attributesMap['agility'],
        PhysicalAbility.agility,
      ),
      PhysicalAbility.flexibility: _parseAttribute(
        attributesMap['flexibility'],
        PhysicalAbility.flexibility,
      ),
      PhysicalAbility.balance: _parseAttribute(
        attributesMap['balance'],
        PhysicalAbility.balance,
      ),
    };
  }

  Attribute _parseAttribute(dynamic data, PhysicalAbility fallbackType) {
    if (data == null) {
      return Attribute(type: fallbackType);
    }

    final map = data as Map<String, dynamic>;

    return Attribute(
      type: PhysicalAbility.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => fallbackType,
      ),
      lvl: (map['lvl'] as int?) ?? 1,
      exp: _convertDoubleArray(
        map['exp'],
      ), //]List<double>.from(map['exp'] ?? [0.0, 100.0]) as List<double>,
    );
  }

  List<double> _convertDoubleArray(dynamic expData) {
    if (expData is List) {
      return expData.map((e) {
        if (e is int) return e.toDouble();
        if (e is double) return e;
        return 0.0;
      }).toList();
    }
    return [0.0, 100.0];
  }

  Map<String, dynamic> _attributeToMap(Attribute attribute) {
    return {
      'type': attribute.type.name,
      'lvl': attribute.lvl,
      'exp': attribute.exp,
    };
  }

  Map<String, dynamic> _badgeToMap(ProfileBadge badge) {
    return {'name': badge.name, 'league': badge.league.name};
  }

  ProfileBadge _badgeFromMap(DocumentSnapshot map) {
    return ProfileBadge(
      name: map['name'],
      league: League.values.firstWhere(
        (l) => l.name == map['league'],
        orElse: () => League.bronze,
      ),
    );
  }
}
