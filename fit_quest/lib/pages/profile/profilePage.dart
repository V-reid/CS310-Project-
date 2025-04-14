import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/pages/profile/components.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

List<double> getExp(int level) {
  return [0, level * 2];
}

class Stat {
  Stat({required this.name, this.lvl = 1, this.exp = const [0, 100]});
  String name;
  int lvl;
  List<double> exp;
}

enum League { bronze, silver, gold, platinum, diamond, legends }

class ProfileBadge {
  ProfileBadge({required this.title, this.league = League.bronze});

  String title;
  League league;
}

class Profile {
  Profile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    this.level = 1,
    this.image,
    this.exp = const [0, 100],
    this.health = const [50, 100],
    this.stats = const [],
    this.badges = const [],
  });

  String name;
  String? image;
  int age;
  double weight;
  double height;
  int level;
  List<double> exp;
  List<double> health;
  List<Stat> stats;
  List<ProfileBadge> badges;
}

class _ProfilePageState extends State<ProfilePage> {
  Profile profile = Profile(
    name: "Mario Rossi",
    image: "assets/saitama.jpg",
    age: 20,
    weight: 80.5,
    height: 180,
    stats: [
      Stat(name: "Strength", lvl: 8, exp: [25, 100]),
      Stat(name: "Endurance", lvl: 6, exp: [40, 100]),
      Stat(name: "Agility", lvl: 3, exp: [90, 100]),
    ],
    badges: [
      ProfileBadge(title: "Contanst Machine", league: League.bronze),
      ProfileBadge(title: "Silver Warrior", league: League.silver),
      ProfileBadge(title: "Gold Warrior", league: League.gold),
      ProfileBadge(title: "Platinum Warrior", league: League.platinum),
      ProfileBadge(title: "Diamond Warrior", league: League.diamond),
      ProfileBadge(title: "Legends Warrior", league: League.legends),
    ],
  );

  @override
  Widget build(BuildContext context) {
    profile.badges.sort((a, b) => b.league.index - a.league.index);
    return pageLayer(
      context: context,
      pageName: "PROFILE",
      body: SingleChildScrollView(
        child: Column(
          spacing: 40,
          children: [
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [profileImage(profile), profileInfo(profile)],
            ),
            Common.sectionName(title: "Attributes", flexs: [0, 4, 5]),
            Common.Grid<Stat>(
              items: profile.stats,
              toElement: (x) => statsCard(x),
            ),
            // Container(
            //   height: 500,
            //   child: GridView.count(
            //     shrinkWrap: true,
            //     crossAxisCount: 2,
            //     children: profile.stats.map((x) => statsCard(x)).toList(),
            //   ),
            // ),
            // for (int i = 0; i <= (profile.stats.length / 2).ceil(); i = i + 2)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     spacing: 15,
            //     children:
            //         profile.stats
            //             .where(
            //               (x) =>
            //                   profile.stats.indexOf(x) >= i &&
            //                   profile.stats.indexOf(x) <= i + 1,
            //             )
            //             .map((x) => statsCard(x))
            //             .toList(),
            //   ),
            Common.sectionName(title: "Badges", flexs: [0, 2, 5]),
            Common.Grid<ProfileBadge>(
              col: 2,
              items: profile.badges,
              toElement: (x) => badgeWidget(x),
            ),
          ],
        ),
      ),
    );
  }
}
