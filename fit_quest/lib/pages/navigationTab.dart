import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/pages/allPages.dart';
import 'package:flutter/material.dart';
import 'package:fit_quest/pages/home/components/homeCard.dart';

class NavigationTab extends StatefulWidget {
  final String uuid;
  const NavigationTab({super.key, required this.uuid});

  @override
  State<NavigationTab> createState() => _NavigationTabState();
}

class _NavigationTabState extends State<NavigationTab> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: [
          QuestsPage(),
          MockupPage(),
          HomePage(uuid: widget.uuid),
          SchedulePage(),
          ProfilePage(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Quests",
            icon: Icon(Icons.emoji_events),
          ),
          BottomNavigationBarItem(
            label: "Mocks",
            icon: Icon(Icons.fitness_center),
          ),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Schedule", icon: Icon(Icons.today)),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_circle),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.grey[800],
        unselectedLabelStyle: TextStyle(color: Colors.black),
        onTap: _onItemTapped,
      ),
    );
  }
}
