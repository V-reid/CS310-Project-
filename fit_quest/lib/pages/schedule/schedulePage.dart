import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/pages/mockup/mockupPage.dart';
import 'package:fit_quest/pages/mockup/singleMockup.dart';
import 'package:flutter/material.dart';

import 'package:fit_quest/pages/mockup/mockupCard.dart';
import 'mockupSelectionPage.dart';
import 'package:provider/provider.dart';
import 'package:fit_quest/state/trainingScheduleProvider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int selectedDayIndex = DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1;
    final provider = Provider.of<TrainingScheduleProvider>(context);
    final schedule = provider.trainingSchedule;

    return pageLayer(
      context: context,
      pageName: "SCHEDULE",
      body: SingleChildScrollView(
        child: Column(
          spacing: 60,
          children: [
            // Day Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              children: [
                if (schedule[selectedDayIndex] != null &&
                    schedule[selectedDayIndex]!.isNotEmpty)
                  ...schedule[selectedDayIndex]!
                      .expand(
                        (card) => [
                          // Wrap each card with a Stack to overlay the remove button
                          Stack(
                            children: [
                              //card,
                              GestureDetector(
                                onTap: () {
                                  final int index = mockups.indexOf(card);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              SingleMockup(mockup: card),
                                    ),
                                  );
                                },
                                child: card,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Show confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Common.text(
                                            data: "Remove Training",
                                          ),
                                          content: Common.text(
                                            data:
                                                "Are you sure you want to remove '${card.name}' from your schedule?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Common.text(
                                                data: "Cancel",
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Common.text(
                                                data: "Remove",
                                              ),
                                              onPressed: () {
                                                provider.removeCard(
                                                  selectedDayIndex,
                                                  card,
                                                );
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                      .toList()
                else
                  Common.text(
                    data: "Rest Day or Slack Day? \n START NOW!",
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 35),

                // Always show the Add button
                ElevatedButton(
                  onPressed: () async {
                    final selected = await Navigator.push<List<MockupCard>>(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                MockupSelectionPage(availableMockups: mockups),
                      ),
                    );

                    if (selected != null && selected.isNotEmpty) {
                      setState(() {
                        provider.updateScheduleForDay(selectedDayIndex, [
                          ...(schedule[selectedDayIndex] ?? []),
                          ...selected,
                        ]);
                      });
                    }
                  },
                  child: const Icon(Icons.add, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
