import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/pages/home/homePage.dart';
import 'package:flutter/material.dart';

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

  final List<String> _fields = [
    'dailySteps',
    'activeMins',
    'dailyQuests',
    'weeklyQuests',
    'monthlyQuests',
  ];

  @override
  void initState() {
    super.initState();
    for (var field in _fields) {
      _controllers[field] = TextEditingController();
    }
    _loadGoals();
  }

  void _loadGoals() async {
    final doc = await FirebaseFirestore.instance
        .collection('fitness_tracker_data')
        .doc(widget.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      for (var field in _fields) {
        final target = data[field]?[1] ?? 0;
        _existingTargets[field] = target;
        _controllers[field]?.text = target.toString(); // Prefill UI
      }
    }
  }

  void _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      final updates = <String, List<dynamic>>{};

      _controllers.forEach((field, controller) {
        final inputText = controller.text.trim();
        final target = inputText.isEmpty
            ? _existingTargets[field] ?? 10000
            : int.tryParse(inputText) ?? 10000;

        updates[field] = [0, target];
      });

      await FirebaseFirestore.instance
          .collection('fitness_tracker_data')
          .doc(widget.uid)
          .update(updates);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Goals updated!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Your Goals")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._fields.map((field) => TextFormField(
                    controller: _controllers[field],
                    decoration: InputDecoration(labelText: field),
                    keyboardType: TextInputType.number,
                    // validator: (val) => val == null || val.isEmpty
                    //     ? 'Enter a value'
                    //     : null,
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  _saveGoals();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(uuid: widget.uid),
                      ),
                    );
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
