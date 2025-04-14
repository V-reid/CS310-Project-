import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/pages/profile/profilePage.dart';
import 'package:flutter/material.dart';

Widget profileImage(Profile profile) {
  return Column(
    spacing: 5,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(profile.image ?? "assets/notFound.jpeg"),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(overlayColor, blend),
          ),
          borderRadius: UI.borderRadius,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Container(),
      ),
      profileTextInfo("Lvl", profile.level.toString()),
    ],
  );
}

Widget profileTextInfo(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: Colors.grey, fontSize: 10)),
      Text(value),
    ],
  );
}

Widget profileInfo(Profile profile) {
  return Column(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      profileTextInfo("Name", profile.name),
      Row(
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          profileTextInfo("Age", profile.age.toString()),
          profileTextInfo("Weight", "${profile.weight.toString()}kg"),
          profileTextInfo("Height", "${profile.height.toString()}cm"),
        ],
      ),
      Common.progressBar(
        current: profile.health[0],
        max: profile.health[1],
        width: 250,
        height: 20,
      ),
    ],
  );
}

Widget statsCard(Stat stat) {
  double width = 180;
  return Container(
    width: width,
    height: 80,
    padding: UI.padx(15),
    decoration: BoxDecoration(borderRadius: UI.borderRadius, color: UI.accent),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 0,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Lvl", style: TextStyle(color: Colors.grey)),
            Text(stat.lvl.toString(), style: TextStyle(fontSize: 18)),
          ],
        ),
        Text(
          stat.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Common.progressBar(
          current: stat.exp[0],
          max: stat.exp[1],
          width: width,
          height: 10,
          fill: UI.primary,
          background: Colors.grey.shade200,
          right: 40,
        ),
      ],
    ),
  );
}

Widget badgeWidget(ProfileBadge badge) {
  Map<League, Color> colors = {
    League.bronze: Color(0xffcd7f32),
    League.silver: Color(0xffC0C0C0),
    League.gold: Color(0xffd4af37),
    League.platinum: Color(0xffe5e4e2),
    League.diamond: Color(0xffb9f2ff),
    League.legends: Color(0xff7f00ff),
  };

  Color current = colors[badge.league] ?? Colors.black;

  return Container(
    padding: UI.padxy(10, 5),
    decoration: BoxDecoration(borderRadius: UI.borderRadius, color: current),
    child: Text(
      badge.title,
      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
    ),
  );
}
