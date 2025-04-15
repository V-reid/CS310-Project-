import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/common/common.dart';
import 'package:flutter/material.dart';
import 'package:fit_quest/pages/home/components/homeCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> statCards = [
    HomeCard(
      name: "Today's Steps",
      icon: Icon(Icons.directions_walk, size: 30),
      conversionRate: "50 Steps = +1 Energy",
      progress: {
        "main": [2500, 5000],
      },
    ),
    HomeCard(
      name: "Today's Active Time",
      icon: Icon(Icons.sports_gymnastics, size: 30),
      conversionRate: "1 min = +10 Health",
      progress: {
        "main": [10, 30],
      },
    ),
    HomeCard(
      name: "Quest Progress",
      icon: Icon(Icons.emoji_events, size: 30),
      conversionRate: "",
      progress: {
        "Weekly ": [2, 4],
        "Monthly": [7, 8],
      },
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return pageLayer(
        context: context,
        pageName: "HOME",
        body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: UI.pady(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 70,
                children: statCards,
              ),
          )
          )
        ),
    );
  }
}
