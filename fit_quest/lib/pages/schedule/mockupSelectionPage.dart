import 'package:flutter/material.dart';
import 'package:fit_quest/pages/mockup/mockupCard.dart';

class MockupSelectionPage extends StatefulWidget {
  final List<MockupCard> availableMockups;

  const MockupSelectionPage({Key? key, required this.availableMockups})
      : super(key: key);

  @override
  _MockupSelectionPageState createState() => _MockupSelectionPageState();
}

class _MockupSelectionPageState extends State<MockupSelectionPage> {
  final Set<MockupCard> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Mockup Workouts")),
      body: ListView(
        padding: EdgeInsets.all(25),
        children: widget.availableMockups.map((mockup) {
          final isSelected = selected.contains(mockup);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selected.remove(mockup);
                  } else {
                    selected.add(mockup);
                  }
                });
              },
              child: Opacity(
                opacity: isSelected ? 1.0 : 0.5,
                child: mockup,
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, selected.toList());
        },
        icon: Icon(Icons.check),
        label: Text("Add Selected"),
      ),
    );
  }
}
