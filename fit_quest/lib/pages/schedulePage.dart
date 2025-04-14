import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return pageLayer(
      context: context,
      pageName: "SCHEDULE",
      body: SingleChildScrollView(
        child: Column(
          spacing: 60,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  Common.days.map((x) => Common.dayButton(text: x)).toList(),
            ),
            Column(
              spacing: 20,
              children: [
                Text("START NOW!", style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: () => {},
                  child: Icon(Icons.add, size: 30),
                ),
              ],
            ),
          ],
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
