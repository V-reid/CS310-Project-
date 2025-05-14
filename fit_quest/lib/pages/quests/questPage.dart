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
  Quest({required this.text, this.image, this.goal = 0, this.current = 0});
  String text;
  String? image;
  double goal;
  double current;
}

class _QuestsPageState extends State<QuestsPage> {
  List<Quest> daily = [
    Quest(text: "Drink water", image: "assets/rocky.jpg"),
    Quest(text: "Walk 10k steps"),
    Quest(text: "Complete 1 mock"),
  ];
  List<Quest> weekly = [
    Quest(text: "Drink water"),
    Quest(text: "Walk 10k steps"),
    Quest(text: "Complete 1 mock"),
  ];
  List<Quest> monthly = [
    Quest(text: "Drink water"),
    Quest(text: "Walk 70k steps"),
    Quest(text: "Complete 1 mock"),
  ];
  @override
  Widget build(BuildContext context) {
    return pageLayer(
      context: context,
      pageName: "QUESTS",
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Filter',
        backgroundColor: UI.accent,
        child: const Icon(Icons.filter_alt),
      ),
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
                ...daily.map((x) => progressQuest(quest: x)),
                Common.sectionName(title: "Weekly"),
                ...weekly.map((x) => progressQuest(quest: x)),
                Common.sectionName(title: "Monthly"),
                ...monthly.map((x) => progressQuest(quest: x)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
