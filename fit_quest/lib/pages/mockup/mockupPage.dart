import 'package:fit_quest/common/layer.dart';
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
    excercise: {
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
    excercise: {"jump": "3x10", "run": "4km", "tricept extensions": "3x10"},
  ),
  MockupCard(
    name: "Yusuf Dikec Training",
    time: 30,
    level: Difficulty.easy,
    kcalBurn: 145,
    image: "assets/yusuf.webp",
    excercise: {
      "Pushup": "100",
      "Sits-up": "100",
      "Squats": "100",
      "Run": "10km",
    },
  ),
];

class MockupPage extends StatelessWidget {
  const MockupPage({super.key});

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
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              "/mockup/single",
                              arguments: mockups.indexOf(x),
                            ),
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
