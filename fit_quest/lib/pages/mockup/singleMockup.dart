import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/mockup/Timer.dart';
import 'package:fit_quest/pages/mockup/mockupCard.dart';
import 'package:fit_quest/pages/mockup/mockupPage.dart';
import 'package:fit_quest/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleMockup extends StatefulWidget {
  final MockupCard mockup;
  const SingleMockup({Key? key, required this.mockup}) : super(key: key);

  @override
  _SingleMockupState createState() => _SingleMockupState();
}

List<Widget> getExercise(MockupCard mockup) {
  return mockup.exercise == null
      ? [Common.text(data: "No Exercise")]
      : mockup.exercise!.keys
          .map(
            (x) => Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                roundedContainer(width: 20, height: 20),
                roundedContainer(
                  width: 150,
                  height: 20,
                  child: Common.text(data: x),
                ),
                roundedContainer(
                  child: Common.text(data: mockup.exercise?[x] ?? ""),
                ),
              ],
            ),
          )
          .toList();
}

List<Widget> getRewards(MockupCard mockup) {
  return mockup.rewards == null
      ? [Common.text(data: "No rewards")]
      : mockup.rewards!.keys
          .map(
            (x) => roundedContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Common.text(data: x.name),
                  Row(
                    children: [
                      Common.text(data: mockup.rewards?[x].toString() ?? ""),
                      Icon(Icons.arrow_upward, color: Colors.lightGreen),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList();
}

class _SingleMockupState extends State<SingleMockup> {
  bool running = false;
  bool finished = false;

  final timerKey = GlobalKey<FitTimerState>();

  Widget exerciseWidget(MockupCard mockup) {
    return Container(
      width: 300,
      padding: UI.padxy(20, 20),
      decoration: BoxDecoration(
        color: UI.accent,
        boxShadow: [UI.boxShadow()],
        borderRadius: UI.borderRadius,
      ),
      child: Column(
        spacing: 20,
        children: [Common.text(data: "Plan"), ...getExercise(widget.mockup)],
      ),
    );
  }

  Widget rewardsWidget(MockupCard mockup) {
    return Container(
      width: 300,
      padding: UI.padxy(20, 20),
      decoration: BoxDecoration(
        boxShadow: [UI.boxShadow()],
        color: UI.accent,
        borderRadius: UI.borderRadius,
      ),
      child: Column(
        spacing: 20,
        children: [Common.text(data: "Redwars"), ...getRewards(widget.mockup)],
      ),
    );
  }

  Widget actions(MockupCard mockup) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          running
              ? [
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        running = false;
                      }),
                  child: Icon(Icons.arrow_back),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.accent),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // setState(() {
                    //   running = false;
                    // });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Common.text(data: "Confirm"),
                          content: Common.text(
                            data: "did you finished '${mockup.name}'?",
                          ),
                          actions: [
                            TextButton(
                              child: Common.text(data: "Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Common.text(data: "Confirm"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  running = false;
                                  finished = true;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },

                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.primary),
                  ),
                  child: Common.text(data: "Finish", color: Colors.white),
                ),
              ]
              : [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.accent),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        running = true;
                      }),
                  child: Common.text(data: "Begin", color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.primary),
                  ),
                ),
              ],
    );
  }

  Widget timer(MockupCard mockup) {
    return Container(
      width: 300,
      padding: UI.padxy(20, 20),
      decoration: BoxDecoration(
        color: UI.accent,
        borderRadius: UI.borderRadius,
      ),
      child: Column(
        spacing: 20,
        children: [
          Common.text(data: "Time"),
          // Common.text(data: doubleToTimeString(widget.mockup.time)),
          FitTimer(
            key: timerKey,
            initialDuration: Duration(minutes: mockup.time.toInt()),
            autoStart: true,
          ),
        ],
      ),
    );
  }

  Widget notBegin(MockupCard mockup) {
    return pageLayer(
      context: context,
      pageName: widget.mockup.name,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            mockup,
            exerciseWidget(widget.mockup),
            rewardsWidget(widget.mockup),
            actions(widget.mockup),
          ],
        ),
      ),
    );
  }

  Widget beginPage(MockupCard mockup) {
    return pageLayer(
      context: context,
      pageName: widget.mockup.name,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            mockup,
            exerciseWidget(widget.mockup),
            timer(widget.mockup),
            actions(widget.mockup),
          ],
        ),
      ),
    );
  }

  Widget congratsPage(MockupCard mockup, BuildContext context) {
    final user = Provider.of<FitUser?>(context);

    return pageLayer(
      context: context,
      pageName: widget.mockup.name,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Common.title(data: "Congratulations!"),
            Common.text(data: "you finished ${mockup.name}!"),
            ...(mockup.rewards != null
                ? mockup.rewards!.entries
                    .map(
                      (x) => Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Common.text(data: x.key.name),
                          Common.text(data: x.value.toString()),
                          Icon(Icons.arrow_upward, color: Colors.lightGreen),
                        ],
                      ),
                    )
                    .toList()
                : [Center(child: Common.text(data: "No redwards!"))]),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (user != null && mockup.rewards != null) {
                    await DatabaseService(
                      uid: user.uid!,
                    ).applyAttributeUpdates(mockup.rewards!);
                  }
                  Navigator.of(context).pop();
                },
                child: Common.text(data: "Get more", color: Colors.white),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(UI.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // int index = ModalRoute.of(context)?.settings.arguments as int;
    // MockupCard mockup = mockups[index];

    return finished
        ? congratsPage(widget.mockup, context)
        : running
        ? beginPage(widget.mockup)
        : notBegin(widget.mockup);
  }
}

Widget roundedContainer({Widget? child, double? width, double? height}) {
  return Container(
    padding: UI.padx(10),
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: child,
  );
}
