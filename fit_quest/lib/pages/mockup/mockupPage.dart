import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/mockup/singleMockup.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'mockupCard.dart';

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
    rewards: {PhysicalAbility.strength: 10, PhysicalAbility.endurance: 15},
  ),
  MockupCard(
    name: "Rocky Training",
    time: 60.5,
    level: Difficulty.medium,
    kcalBurn: 500,
    image: "assets/rocky.jpg",
    exercise: {"jump": "3x10", "run": "4km", "tricept extensions": "3x10"},
    rewards: {PhysicalAbility.strength: 120, PhysicalAbility.agility: 15},
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

class MockupPage extends StatefulWidget {
  const MockupPage({super.key});

  @override
  State<MockupPage> createState() => _MockupPageState();
}

class _MockupPageState extends State<MockupPage> {
  @override
  Widget build(BuildContext context) {
    return pageLayer(
      context: context,
      pageName: "MOCK-UP TRAINING",
      body: Center(
        child: Container(
          padding: UI.pady(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 15,
            children:
                mockups
                    .map(
                      (x) => GestureDetector(
                        onTap: () {
                          final int index = mockups.indexOf(x);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleMockup(mockup: x),
                            ),
                          );
                        },
                        //     () => Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => const SingleMockup()),
                        //     ),
                        child: x,
                      ),
                    )
                    .toList(),
          ),
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
