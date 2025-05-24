import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/pages/navigationTab.dart';
import 'package:flutter/material.dart';
import 'package:fit_quest/common/common.dart';

class EditGoalsPage extends StatefulWidget {
  final String uid;

  const EditGoalsPage({required this.uid, super.key});

  @override
  State<EditGoalsPage> createState() => _EditGoalsPageState();
}

class _EditGoalsPageState extends State<EditGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> _controllers = {};
  Map<String, int> _existingTargets = {}; // 💡 Store current goal values

  final Map<String, String> _fields = {
    'Daily Steps': 'dailySteps',
    'Active Time': 'activeMins',
    'Daily Quests': 'dailyQuests',
    'Weekly Quests': 'weeklyQuests',
    'Monthly Quests': 'monthlyQuests',
  };

  @override
  void initState() {
    super.initState();
    for (var label in _fields.keys) {
      _controllers[label] = TextEditingController();
    }
    _loadGoals();
  }

  void _loadGoals() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('fitness_tracker_data')
            .doc(widget.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      _fields.forEach((label, firestoreKey) {
        final target = data[firestoreKey]?[1] ?? 0;
        _existingTargets[label] = target;
        _controllers[label]?.text = target.toString();
      });
    }
  }

  void _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      final updates = <String, List<dynamic>>{};

      _controllers.forEach((label, controller) {
        final firestoreKey = _fields[label]!;
        final inputText = controller.text.trim();
        final target =
            inputText.isEmpty
                ? _existingTargets[label] ?? 10000
                : int.tryParse(inputText) ?? 10000;

        updates[firestoreKey] = [0, target];
      });

      await FirebaseFirestore.instance
          .collection('fitness_tracker_data')
          .doc(widget.uid)
          .update(updates);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Goals updated!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Common.text(data: "Edit Goals...")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._fields.keys.map(
                (label) => Column(
                  children: [
                    TextFormField(
                      controller: _controllers[label],
                      decoration: InputDecoration(
                        labelText: label,
                        labelStyle: TextStyle(fontFamily: "Pokemon"),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return null;
                        final parsed = int.tryParse(val.trim());
                        if (parsed == null || parsed <= 0)
                          return 'Enter a positive number';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _saveGoals();
                  Navigator.of(context).pop();
         
                },
                child: Text("Save", style: TextStyle(fontFamily: "Pokemon")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
