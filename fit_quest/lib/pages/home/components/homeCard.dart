import 'package:fit_quest/common/common.dart' as common;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCard extends StatefulWidget {
  final String name;
  final Icon icon;
  final String conversionRate;
  final String userId; // <-- identify the user whose goals we should read
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
  Map<String, List<int>> _quest_progress = {};
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
        _quest_progress = {};

        for (var key in allowedKeys) {
          if (data.containsKey(key)){
            List<dynamic> val = data[key];
            if (val.length == 2){
              final label = labelMapping[key] ?? key;
              if (key.contains("Quests")){
                _quest_progress[label] = [val[0] as int, val[1] as int];
              }
              else {
                _progress[label] = [val[0] as int, val[1] as int];
              }
            }
          }
        }

        print(_progress);
        print(_quest_progress);

        final relevantProgress = widget.name == "Quest Progress" ? _quest_progress : _progress;

        return Container(
          width: 350,
          height: 150,
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
                          const SizedBox(width: 5),
                          common.Common.title(data: widget.name, color: Colors.black),
                        ],
                      ),

                      /// between card title and card conversion rate
                      const SizedBox(height: 20),

                      /// Conversion Rate (if any)
                      if (widget.conversionRate.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Center(
                          child: common.Common.text(
                            data: widget.conversionRate,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      /// between conversion rate and progress bars
                      const SizedBox(height: 5),
                      

                      /// Progress Bar(s)
                      ...relevantProgress.entries.map((entry) {
                      final label = entry.key;
                      final current = entry.value[0];
                      final goal = entry.value[1];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Produce titles next to bars
                            if (widget.name == "Quest Progress") ...[
                              common.Common.text(
                                data: label,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _progressBarWithText(
                                  progress: current,
                                  goal: goal,
                                ),
                              ),
                            ],

                            if (label == widget.name)...{
                              Expanded(
                                child: _progressBarWithText(
                                  progress: current,
                                  goal: goal,
                                ),
                              ),
                            }
                            
                          ],
                        ),
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



/*
class HomeCard extends StatelessWidget {
  final String name;
  final Icon icon;
  final String conversionRate;
  final Map<String, List<int>> progress;
  // final int currentCount;
  // final int goal;

  final double cardWidth = 350;
  final double cardHeight = 125;

  const HomeCard({
    super.key,
    required this.name,
    required this.icon,
    required this.conversionRate,
    required this.progress,
    // required this.currentCount,
    // required this.goal,
  });

  static const Map<String, Color> colorBackground = {
    "Today's Steps": common.UI.walkCardColor,
    "Today's Active Time": common.UI.activeTimeCardColor,
    "Quest Progress": common.UI.questProgressCardColor,
  };

  Widget progressBarWithText({
    required int progress,
    required int goal,
    String unit = '',
  }) {
    double percentage = (progress / goal).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        double barWidth = constraints.maxWidth * percentage;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background bar
            Container(
              height: 20,
              width: constraints.maxWidth, // match parent
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Green progress bar
            Positioned(
              left: 0,
              child: Container(
                height: 20,
                width: barWidth, // dynamically calculated
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Centered text
            common.Common.text(
              data: "$progress/$goal $unit",
              fontWeight: FontWeight.w100,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: colorBackground[name],
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
                  Row(
                    children: [
                      icon,
                      SizedBox(width: 5), // spacer between icon and title
                      common.Common.title(data: name, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 5),
                  if (conversionRate.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Center(
                      child: common.Common.text(
                        data: conversionRate,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                  SizedBox(height: 10),
                  ...progress.entries.map((entry) {
                    final label = entry.key;
                    final current = entry.value[0];
                    final goal = entry.value[1];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              if (progress.length > 1)
                                Row(
                                  children: [
                                    common.Common.text(
                                      data: label,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 15),
                                  ],
                                ),
                            ],
                          ),
                          Expanded(
                            child: progressBarWithText(
                              progress: current,
                              goal: goal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
