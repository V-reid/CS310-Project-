class FitUser {
  final String uid;

  FitUser({required this.uid});
}

class Attribute {
  final String name;
  final int lvl;
  List<double> exp = List.filled(2, 0, growable: false);

  Attribute({required this.name, this.lvl = 1, this.exp = const [0, 100]});
}

enum League { bronze, silver, gold, platinum, diamond, legends }

class Badge {
  final String name;
  final League league;

  Badge({required this.name, this.league = League.bronze});
}

class UserData {
  final String uid;
  final String name;
  final int age;
  final double weight;
  final double height;
  int lvl;
  List<double> exp = List.filled(2, 0, growable: false);
  List<double> health = List.filled(2, 0, growable: false);
  List<Attribute> attributes;
  List<Badge> badges;

  UserData({
    required this.uid,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    this.lvl = 1,
    this.exp = const [0, 100],
    this.health = const [0, 100],
    this.attributes = const [],
    this.badges = const [],
  });
}
