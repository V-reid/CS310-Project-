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
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Filter',
        backgroundColor: UI.accent,
        child: const Icon(Icons.filter_alt),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {},
                child: Text("M", style: TextStyle(fontSize: 10)),
                // style: ButtonStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
