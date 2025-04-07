import 'package:fit_quest/common/layer.dart';
import 'package:flutter/material.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return pageLayer(context: context, pageName: "DAILY", body: Container());
  }
}
