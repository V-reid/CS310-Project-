import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:flutter/material.dart';

import 'package:fit_quest/pages/mockup/mockupCard.dart';
import 'package:fit_quest/pages/mockupSelectionPage.dart';

const mockups = [
  MockupCard(
    name: "Saitama Training",
    time: 90,
    level: Difficulty.hard,
    kcalBurn: 1500,
    image: "assets/saitama.jpg",
    mostPopular: true,
    exercise: {
      "Pushup": "100",
      "Sits-up": "100",
      "Squats": "100",
      "Run": "10km",
    },
    rewards: {"Strength": "10", "Endurance": "15"},
  ),
  MockupCard(
    name: "Rocky Training",
    time: 60.5,
    level: Difficulty.medium,
    kcalBurn: 500,
    image: "assets/rocky.jpg",
    exercise: {"jump": "3x10", "run": "4km", "triceps extension": "3x10"},
  ),
  MockupCard(
    name: "Yusuf Dikec Training",
    time: 30,
    level: Difficulty.easy,
    kcalBurn: 145,
    image: "assets/yusuf.webp",
    exercise: {
      "Pushup": "100",
      "Sits-up": "100",
      "Squats": "100",
      "Run": "10km",
    },
  ),
];

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int selectedDayIndex = DateTime.now().weekday - 1;
  final Map<int, List<MockupCard>> trainingSchedule = {
    0: [mockups[0]], // Monday
    2: [mockups[1]], // Wednesday
    6: [mockups[2]], // Sunday
  };

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1;
    // final weekday = todayIndex;
    // final days = Common.days; // ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    // int selectedDayIndex = today.weekday;
    return pageLayer(
      context: context,
      pageName: "SCHEDULE",
      body: SingleChildScrollView(
        child: Column(
          spacing: 60,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // children:
              //     Common.days.map((x) => Common.dayButton(text: x)).toList(),
              children: List.generate(Common.days.length, (index) {
                final isToday = index == todayIndex;
                final isSelected = index == selectedDayIndex;
                return Common.dayButton(
                  text: Common.days[index],
                  isToday: isToday,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                );
              }),
            ),
            Column(
              children: trainingSchedule[selectedDayIndex] ??
                  [
                    Text("Rest Day or Slack Day? \n START NOW!", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                        ElevatedButton(
                          onPressed: () async {
                            final selected = await Navigator.push<List<MockupCard>>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MockupSelectionPage(
                                  availableMockups: mockups,
                                ),
                              ),
                            );

                            if (selected != null && selected.isNotEmpty) {
                              setState(() {
                                trainingSchedule.update(
                                  selectedDayIndex,
                                      (list) => [...list, ...selected],
                                  ifAbsent: () => selected,
                                );
                              });
                            }
                          },
                          child: Icon(Icons.add, size: 30),
                        ),
                  ],
            ),
            // Column(
            //   spacing: 20,
            //   children: [
            //     Text("START NOW!", style: TextStyle(fontSize: 20)),
            //     ElevatedButton(
            //       // TODO: show options, each day should be a storable
            //       onPressed: () => {},
            //       child: Icon(Icons.add, size: 30),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        backgroundColor: UI.accent,
        child: const Icon(Icons.filter_alt),
      ),
    );
  }
}
