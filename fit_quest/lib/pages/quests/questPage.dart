import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/pages/quests/components.dart';
import 'package:flutter/material.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({Key? key}) : super(key: key);

  @override
  _QuestsPageState createState() => _QuestsPageState();
}

class Quest {
  Quest({required this.text, this.image, this.xp = 0, this.steps = 0});
  String text;
  String? image;
  double xp;
  double steps;
}

class _QuestsPageState extends State<QuestsPage> {
  List<Quest> daily = [
    Quest(text: "Drink water", image: "assets/rocky.jpg", xp: 20),
    Quest(text: "Walk 10k steps", xp: 40, steps: 1300),
    Quest(text: "Complete 1 mock", xp: 50),
  ];
  List<Quest> weekly = [
    Quest(text: "Drink water", xp: 30),
    Quest(text: "Walk 30k steps", xp: 60, steps: 3900),
    Quest(text: "Complete 7 mock", xp: 250),
  ];
  List<Quest> monthly = [
    Quest(text: "Drink water", xp: 50),
    Quest(text: "Walk 70k steps", xp: 70, steps: 9100),
    Quest(text: "Complete 15 mock", xp: 750),
  ];
  @override
  Widget build(BuildContext context) {
    return pageLayer(
      context: context,
      pageName: "QUESTS",
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   tooltip: 'Filter',
      //   backgroundColor: UI.accent,
      //   child: const Icon(Icons.filter_alt),
      // ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 60,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children:
            //       Common.days.map((x) => Common.dayButton(text: x)).toList(),
            // ),
            Column(
              spacing: 20,
              children: [
                Common.sectionName(title: "Daily"),
                ...daily.map((x) => ProgressQuest(quest: x)),
                Common.sectionName(title: "Weekly"),
                ...weekly.map((x) => ProgressQuest(quest: x)),
                Common.sectionName(title: "Monthly"),
                ...monthly.map((x) => ProgressQuest(quest: x)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
