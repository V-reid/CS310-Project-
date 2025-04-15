import 'package:fit_quest/common/common.dart' as common;
import 'package:flutter/material.dart';

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
              weight: FontWeight.w100,
            ),
          ],
        );
      },
    );
  }

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     // The background bar
    //     Container(
    //       height: 20,
    //       decoration: BoxDecoration(
    //         color: Colors.grey[300],
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //     ),
    //     // The actual progress bar aligned to the left and fills proportionally
    //     Align(
    //       alignment: Alignment.centerLeft, // Align the green progress bar to the left
    //       child: Container(
    //         height: 20,
    //         width: percentage * cardWidth,
    //         decoration: BoxDecoration(
    //           color: Colors.greenAccent,
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //       ),
    //     ),
    //     common.Common.text(
    //       data: "$progress/$goal $unit",
    //       weight: FontWeight.w100,
    //     ),
    //   ],
    // );
  // }

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
                        weight: FontWeight.w100,
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
                                        weight: FontWeight.bold,
                                      ),
                                      SizedBox(width:15),
                                    ]
                                ),
                            ]
                          ),
                          Expanded(
                            child: progressBarWithText(progress: current, goal: goal),
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

