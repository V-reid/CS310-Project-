import 'dart:math';

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

  Future<void> applyAttributeUpdates(
    Map<PhysicalAbility, double> attributeUpdates,
  ) async {
    final userRef = userCollection.doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final userData = _userDataFromMap(snapshot);

      final updates = <String, dynamic>{};
      int totalLevelIncrease = 0;
      double totExp = 0;

      attributeUpdates.forEach((ability, expToAdd) async {
        if (userData.attributes[ability] != null) {
          final currentAttribute = userData.attributes[ability]!;

          double newCurrentExp = currentAttribute.exp[0] + expToAdd;
          userData.exp[0] += expToAdd;
          int levelsGained = 0;

          while (newCurrentExp >= currentAttribute.exp[1]) {
            newCurrentExp -= currentAttribute.exp[1];
            levelsGained++;
            currentAttribute.exp[1] =
                100 * pow(1.2, currentAttribute.lvl).toDouble();
          }

          updates['attributes.${ability.name}'] = {
            'type': ability.name,
            'lvl': currentAttribute.lvl + levelsGained,
            'exp': [newCurrentExp, currentAttribute.exp[1]],
          };
        }
      });

      while (userData.exp[0] > userData.exp[1]) {
        userData.exp[0] -= userData.exp[1];
        totalLevelIncrease++;
        userData.exp[1] = 100 * pow(1.5, userData.lvl).toDouble();

        userData.health[1] = 100 * pow(1.25, userData.lvl).toDouble();
        userData.health[0] = userData.health[1];
      }
      updates['exp'] = [userData.exp[0], userData.exp[1]];
      updates['lvl'] = FieldValue.increment(totalLevelIncrease);
      updates['health'] = [userData.health[0], userData.health[1]];

      transaction.update(userRef, updates);
    });
  }

  Future<void> restoreChanges(
    Map<PhysicalAbility, double> attributeUpdates,
  ) async {
    final userRef = userCollection.doc(uid);
    int go_down = 1;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final userData = _userDataFromMap(snapshot);

      final updates = <String, dynamic>{};
      int totalLevelDecrese= 0;
      double totExp = 0;

      attributeUpdates.forEach((ability, expToGet) async {
        if (userData.attributes[ability] != null) {
          final currentAttribute = userData.attributes[ability]!;

          double newCurrentExp = currentAttribute.exp[0] - expToGet;
          userData.exp[0] -= expToGet;
          int levelsGained = 0;
//40/100
//lv+1
          while (newCurrentExp + currentAttribute.exp[1] <= currentAttribute.exp[1]) {
            double decrease = currentAttribute.exp[1] + newCurrentExp;
            

            currentAttribute.exp[1] =
                100 * pow(1.2, currentAttribute.lvl-go_down).toDouble();
            
            go_down--;
            levelsGained--;
            
            newCurrentExp = decrease + currentAttribute.exp[1];
          }

          updates['attributes.${ability.name}'] = {
            'type': ability.name,
            'lvl': currentAttribute.lvl + levelsGained,
            'exp': [newCurrentExp, currentAttribute.exp[1]],
          };
        }
      });

      while (userData.exp[0] > userData.exp[1]) {
        userData.exp[0] -= userData.exp[1];
        totalLevelDecrese--;
        userData.exp[1] = 100 * pow(1.5, userData.lvl).toDouble();

        userData.health[1] = 100 * pow(1.25, userData.lvl).toDouble();
        userData.health[0] = userData.health[1];
      }
      updates['exp'] = [userData.exp[0], userData.exp[1]];
      updates['lvl'] = FieldValue.increment(totalLevelDecrese);
      updates['health'] = [userData.health[0], userData.health[1]];

      transaction.update(userRef, updates);
    });
  }

}
