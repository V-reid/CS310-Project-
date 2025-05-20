import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/pages/quests/questPage.dart';
import 'package:flutter/material.dart';

class ProgressQuest extends StatefulWidget {
  final Quest quest;

  const ProgressQuest({
    super.key,
    required this.quest,
  });

  @override
  State<ProgressQuest> createState() => _ProgressQuestState();
}

class _ProgressQuestState extends State<ProgressQuest> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });

        if(_isTapped){

        }else{
          
        }
      },
      child: Container(
        margin: UI.padx(20),
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        height: 30,
        decoration: BoxDecoration(
          color: _isTapped 
              ? Colors.green.withValues(alpha: 255,red:  76,green:   175, blue: 80)
              : UI.accent,
          borderRadius: UI.borderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.quest.image ?? "assets/notFound.jpeg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: UI.borderRadius,
                border: Border.all(color: Colors.grey, width: 1),
              ),
            ),
            Common.text(data: widget.quest.text),
          ],
        ),
      ),
    );
  }
}
