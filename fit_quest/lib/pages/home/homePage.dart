import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/common/common.dart';
import 'package:flutter/material.dart';
import 'package:fit_quest/pages/home/components/homeCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_quest/pages/home/editGoalsPage.dart';

class HomePage extends StatefulWidget {
  final String uuid;
  const HomePage({super.key, required this.uuid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              children: [
                HomeCard(
                  name: "Today's Steps",
                  icon: const Icon(Icons.directions_walk, size: 30),
                  conversionRate: "50 Steps = +1 Energy",
                  userId: widget.uuid,
                  goalUnit: "steps",
                ),
                SizedBox(height: 20),
                HomeCard(
                  name: "Today's Active Time",
                  icon: const Icon(Icons.sports_gymnastics, size: 30),
                  conversionRate: "1 min = +10 Health",
                  userId: widget.uuid,
                  goalUnit: "mins",
                ),
                SizedBox(height: 20),
                HomeCard(
                  name: "Quest Progress",
                  icon: const Icon(Icons.emoji_events, size: 30),
                  conversionRate: "",
                  userId: widget.uuid,
                ),

                SizedBox(height: 30), // spacing

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditGoalsPage(uid: widget.uuid),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit Goals"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
