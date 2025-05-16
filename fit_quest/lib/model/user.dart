class FitUser {
  final String uid;

  FitUser({required this.uid});
}

enum PhysicalAbility { strength, endurance, agility, flexibility, balance }

class Attribute {
  final PhysicalAbility type;
  final int lvl;
  List<double> exp = List.filled(2, 0, growable: false);

  Attribute({required this.type, this.lvl = 1, this.exp = const [0, 100]});
}

enum League { bronze, silver, gold, platinum, diamond, legends }

class ProfileBadge {
  final String name;
  final League league;

  ProfileBadge({required this.name, this.league = League.bronze});
}

class UserData {
  final String uid;
  final String name;
  final String? profilePic;
  final int age;
  final double weight;
  final double height;
  int lvl;
  List<double> exp = List.filled(2, 0, growable: false);
  List<double> health = List.filled(2, 0, growable: false);
  Map<PhysicalAbility, Attribute> attributes;
  List<ProfileBadge> badges;

  UserData({
    required this.uid,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    this.profilePic,
    this.lvl = 1,
    this.exp = const [0, 100],
    this.health = const [0, 100],
    Map<PhysicalAbility, Attribute>? attributes,
    this.badges = const [],
  }) : attributes =
           attributes ??
           {
             PhysicalAbility.strength: Attribute(
               type: PhysicalAbility.strength,
             ),
             PhysicalAbility.endurance: Attribute(
               type: PhysicalAbility.endurance,
             ),
             PhysicalAbility.agility: Attribute(type: PhysicalAbility.agility),
             PhysicalAbility.flexibility: Attribute(
               type: PhysicalAbility.flexibility,
             ),
             PhysicalAbility.balance: Attribute(type: PhysicalAbility.balance),
           };
}
