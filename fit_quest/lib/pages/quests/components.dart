import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/pages/quests/questPage.dart';
import 'package:flutter/material.dart';

Widget progressQuest({required Quest quest}) {
  return Container(
    margin: UI.padx(20),
    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
    height: 30,
    decoration: BoxDecoration(color: UI.accent, borderRadius: UI.borderRadius),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(quest.image ?? "assets/notFound.jpeg"),
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(overlayColor, blend),
            ),
            borderRadius: UI.borderRadius,
            border: Border.all(color: Colors.grey, width: 1),
          ),
        ),
        Common.text(data: quest.text),
      ],
    ),
  );
}
