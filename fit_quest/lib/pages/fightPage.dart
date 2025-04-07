import 'package:fit_quest/common/layer.dart';
import 'package:flutter/material.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  _FightPageState createState() => _FightPageState();
}

class _FightPageState extends State<FightPage> {
  @override
  Widget build(BuildContext context) {
    return pageLayer(context: context, pageName: "FIGHT", body: Container());
  }
}
