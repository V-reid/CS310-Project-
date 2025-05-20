import 'package:fit_quest/common/common.dart' as common;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCard extends StatefulWidget {
  final String name;
  final Icon icon;
  final String conversionRate;
  final String userId;
  final String? goalUnit;

  const HomeCard({
    super.key,
    required this.name,
    required this.icon,
    required this.conversionRate,
    required this.userId,
    this.goalUnit,
  });

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Map<String, List<int>> _progress = {};
  Map<String, List<int>> _questProgress = {};
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _goalStream;

  static const Map<String, Color> _colorBackground = {
    "Today's Steps": common.UI.walkCardColor,
    "Today's Active Time": common.UI.activeTimeCardColor,
    "Quest Progress": common.UI.questProgressCardColor,
  };

  @override
  void initState() {
    super.initState();
    // Listen to the user's goal document inside Firestore.
    _goalStream = FirebaseFirestore.instance
        .collection('fitness_tracker_data')
        .doc(widget.userId)
        .snapshots();
  }

  Widget _progressBarWithText({
    required int progress,
    required int goal,
    String? unit,
  }) {
    final double percentage = (progress / goal).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth * percentage;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 20,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                height: 20,
                width: barWidth,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            unit != null ?
              common.Common.text(
                data: "$progress/$goal $unit",
                fontWeight: FontWeight.w100,
              ) :
              common.Common.text(
                data: "$progress/$goal",
                fontWeight: FontWeight.w100,
              ),
          ],
        );
      },
    );
  }

  void _updateProgress(String label, int delta) async {
    final isQuest = widget.name == "Quest Progress";
    final dataMap = isQuest ? _questProgress : _progress;
    final current = dataMap[label]?[0] ?? 0;
    final goal = dataMap[label]?[1] ?? 1;

    final newProgress = (current + delta).clamp(0, goal);

    // Reverse labelMapping to get the Firestore key
    final firestoreKey = {
      "Today's Steps": 'dailySteps',
      "Today's Active Time": 'activeMins',
      "Daily  ": 'dailyQuests',
      "Weekly ": 'weeklyQuests',
      "Monthly": 'monthlyQuests',
    }[label];

    if (firestoreKey == null) return;

    await FirebaseFirestore.instance
        .collection('fitness_tracker_data')
        .doc(widget.userId)
        .update({
      firestoreKey: [newProgress, goal],
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _goalStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 350,
            height: 125,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox(
            width: 350,
            height: 125,
            child: Center(child: Text('Error loading goals')),
          );
        }

        final data = snapshot.data!.data() ?? {};
        // Filter the fields that correspond to progress keys you expect
        final allowedKeys = [
          'dailySteps',
          'activeMins',
          'dailyQuests',
          'weeklyQuests',
          'monthlyQuests',
        ];

        final Map<String, int> _incrementAmounts = {
          "Today's Steps": 100,
          "Today's Active Time": 5,
          "Daily  ": 7,
          "Weekly ": 5,
          "Monthly": 1,
        };

        // Map Firestore keys to user-friendly labels (matching your HomeCard names)
        final labelMapping = {
          'dailySteps': "Today's Steps",
          'activeMins': "Today's Active Time",
          // For Quest Progress, you can sum quests or handle separately
          'dailyQuests':    "Daily  ",
          'weeklyQuests':   "Weekly ",
          'monthlyQuests':  "Monthly",
        };

        _progress = {};
        _questProgress = {};

        for (var key in allowedKeys) {
          if (data.containsKey(key)){
            List<dynamic> val = data[key];
            if (val.length == 2){
              final label = labelMapping[key] ?? key;
              if (key.contains("Quests")){
                _questProgress[label] = [val[0] as int, val[1] as int];
              }
              else {
                _progress[label] = [val[0] as int, val[1] as int];
              }
            }
          }
        }


        final relevantProgress = widget.name == "Quest Progress" ? _questProgress : _progress;

        return Container(
          width: 350,
          height: 200,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: _colorBackground[widget.name],
            borderRadius: common.UI.borderRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: common.Common.paddingContainer(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Card Title
                      Row(
                        children: [
                          widget.icon,
                          // between icon and title space
                          const SizedBox(width: 5),
                          common.Common.title(data: widget.name, color: Colors.black),
                        ],
                      ),

                      /// Conversion Rate (if any)
                      if (widget.conversionRate.isNotEmpty) ...[
                        /// between card title and card conversion rate
                        const SizedBox(height: 35),
                        Center(
                          child: common.Common.text(
                            data: widget.conversionRate,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],

                      /// between conversion rate and progress bars
                      // const SizedBox(height: 5),
                      

                      /// Progress Bar(s)
                      ...relevantProgress.entries.map((entry) {
                        final label = entry.key;
                        final current = entry.value[0];
                        final goal = entry.value[1];
                        final increment = _incrementAmounts[label] ?? 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.name == "Quest Progress") ...[
                              Row(
                                children: [
                                  common.Common.text(
                                    data: label,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove, size: 18),
                                    onPressed: () => _updateProgress(label, -increment),
                                  ),
                                  Flexible(
                                    child: _progressBarWithText(
                                      progress: current,
                                      goal: goal,
                                      unit: widget.goalUnit,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, size: 18),
                                    onPressed: () => _updateProgress(label, increment),
                                  ),
                                ],
                              ),
                            ],
                            if (label == widget.name) ...{
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: 18),
                                    onPressed: () => _updateProgress(label, -increment),
                                  ),
                                  Expanded(
                                    child: _progressBarWithText(
                                      progress: current,
                                      goal: goal,
                                      unit: widget.goalUnit,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, size: 18),
                                    onPressed: () => _updateProgress(label, increment),
                                  ),
                                ],
                              ),
                            }
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

