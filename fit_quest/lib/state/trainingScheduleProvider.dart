import 'package:flutter/material.dart';
import 'package:fit_quest/pages/mockup/mockupCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainingScheduleProvider with ChangeNotifier {
  final Map<int, List<MockupCard>> _trainingSchedule = {};

  Map<int, List<MockupCard>> get trainingSchedule => _trainingSchedule;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  void addToDay(int dayIndex, List<MockupCard> newCards) {
    if (_trainingSchedule.containsKey(dayIndex)) {
      _trainingSchedule[dayIndex]!.addAll(newCards);
    } else {
      _trainingSchedule[dayIndex] = newCards;
    }
    notifyListeners();
    saveSchedule(); // Save automatically on change
  }

  void removeCard(int dayIndex, MockupCard card) {
    _trainingSchedule[dayIndex]?.remove(card);
    notifyListeners();
    saveSchedule(); // Save automatically on change
  }

  Future<void> saveSchedule() async {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final docRef = db.collection('schedules').doc(user.uid);
  final doc = await docRef.get();

  // Build the training schedule map from _trainingSchedule
  final Map<String, List<Map<String, dynamic>>> scheduleMap =
      _trainingSchedule.map(
    (day, list) =>
        MapEntry(day.toString(), list.map((card) => card.toJson()).toList()),
  );

  // Top-level document map to save to Firestore
  final Map<String, dynamic> dataToSave = {
    'schedule': scheduleMap,
  };

  // Add createdAt if it's the first time
  if (!doc.exists) {
    dataToSave['createdAt'] = FieldValue.serverTimestamp();
  }

  await docRef.set(dataToSave, SetOptions(merge: true));

  print("Saving schedule for user: ${user.uid}");
  print(dataToSave);
}


  void updateScheduleForDay(int dayIndex, List<MockupCard> newList) {
    _trainingSchedule[dayIndex] = newList;
    notifyListeners();
    saveSchedule(); // this ensures Firestore gets updated
  }

  Future<void> loadSchedule() async {
    final doc = await _firestore.collection('schedules').doc(userId).get();
    final data = doc.data();

    if (data == null || data['schedule'] == null) return;

    _trainingSchedule.clear();
    (data['schedule'] as Map<String, dynamic>).forEach((key, value) {
      final int day = int.parse(key);
      final cards =
          (value as List)
              .map(
                (e) =>
                    MockupCard.fromJson(Map<String, dynamic>.from(e))
                        ,
              )
              .toList();
      _trainingSchedule[day] = cards;
    });

    notifyListeners();
  }
}
