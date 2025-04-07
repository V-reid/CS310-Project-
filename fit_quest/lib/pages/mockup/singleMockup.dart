import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/pages/mockup/components/mockupCard.dart';
import 'package:fit_quest/pages/mockup/mockupPage.dart';
import 'package:flutter/material.dart';

class SingleMockup extends StatefulWidget {
  const SingleMockup({Key? key}) : super(key: key);

  @override
  _SingleMockupState createState() => _SingleMockupState();
}

List<Widget> getExcersice(MockupCard mockup) {
  return mockup.excercise == null
      ? [Text("No Excercise")]
      : mockup.excercise!.keys
          .map(
            (x) => Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                roundedContainer(width: 20, height: 20),
                roundedContainer(width: 150, height: 20, child: Text(x)),
                roundedContainer(child: Text(mockup.excercise?[x] ?? "")),
              ],
            ),
          )
          .toList();
}

List<Widget> getRedwards(MockupCard mockup) {
  return mockup.rewards == null
      ? [Text("No rewards")]
      : mockup.rewards!.keys
          .map(
            (x) => roundedContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(x),
                  Row(
                    children: [
                      Text(mockup.rewards?[x] ?? ""),
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
  bool beign = false;

  Widget excerciseWidget(MockupCard mockup) {
    return Container(
      width: 300,
      padding: UI.padxy(20, 20),
      decoration: BoxDecoration(
        color: UI.accent,
        borderRadius: UI.borderRadius,
      ),
      child: Column(
        spacing: 20,
        children: [Text("Plan"), ...getExcersice(mockup)],
      ),
    );
  }

  Widget rewardsWidget(MockupCard mockup) {
    return Container(
      width: 300,
      padding: UI.padxy(20, 20),
      decoration: BoxDecoration(
        color: UI.accent,
        borderRadius: UI.borderRadius,
      ),
      child: Column(
        spacing: 20,
        children: [Text("Redwars"), ...getRedwards(mockup)],
      ),
    );
  }

  Widget actions() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          beign
              ? [
                ElevatedButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.accent),
                  ),
                  child: Text("Pause"),
                ),
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        beign = false;
                      }),

                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.primary),
                  ),
                  child: Text("Finish", style: TextStyle(color: Colors.white)),
                ),
              ]
              : [
                ElevatedButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, "/mockup"),
                  child: Icon(Icons.arrow_back),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(UI.accent),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        beign = true;
                      }),
                  child: Text("Begin", style: TextStyle(color: Colors.white)),
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
        children: [Text("Time"), Text(doubleToTimeString(mockup.time))],
      ),
    );
  }

  Widget notBeign(MockupCard mockup) {
    return pageLayer(
      context: context,
      pageName: mockup.name,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            mockup,
            excerciseWidget(mockup),
            rewardsWidget(mockup),
            actions(),
          ],
        ),
      ),
    );
  }

  Widget beignPage(MockupCard mockup) {
    return pageLayer(
      context: context,
      pageName: mockup.name,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [mockup, timer(mockup), excerciseWidget(mockup), actions()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)?.settings.arguments as int;
    MockupCard mockup = mockups[index];

    return beign ? beignPage(mockup) : notBeign(mockup);
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
