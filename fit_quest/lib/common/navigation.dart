import 'package:flutter/material.dart';

import 'common.dart';

class NavigationObj {
  final String route;
  final NavigationDestination destination;

  const NavigationObj({required this.route, required this.destination});
}

const iconColor = Colors.white;

const Map<String, NavigationDestination> destinations = {
  "/quests": NavigationDestination(
    selectedIcon: Icon(Icons.emoji_events, color: iconColor),
    icon: Icon(Icons.emoji_events, color: iconColor),
    label: 'Quests',
  ),

  "/mockup": NavigationDestination(
    selectedIcon: Icon(Icons.fitness_center, color: iconColor),
    icon: Icon(Icons.fitness_center, color: iconColor),
    label: 'Mockup',
  ),

  "/": NavigationDestination(
    selectedIcon: Icon(Icons.home, color: iconColor),
    icon: Icon(Icons.home_outlined, color: iconColor),
    label: 'Home',
  ),

  "/schedule": NavigationDestination(
    selectedIcon: Icon(Icons.today, color: iconColor),
    icon: Icon(Icons.today, color: iconColor),
    label: 'Schedule',
  ),

  "/profile": NavigationDestination(
    selectedIcon: Icon(Icons.account_circle, color: iconColor),
    icon: Icon(Icons.account_circle, color: iconColor),
    label: 'Profile',
  ),
};

NavigationBar navigationBar(BuildContext context) {
  String? name = ModalRoute.of(context)?.settings.name;
  String? currentRoute = "/${name?.split("/")[1]}";
  int currentDest = destinations.keys.toList().indexOf(currentRoute ?? "/");
  return NavigationBar(
    backgroundColor: Colors.black,
    selectedIndex: currentDest < 0 ? 0 : currentDest,
    onDestinationSelected:
        (value) => {
          Navigator.pushReplacementNamed(
            context,
            destinations.keys.toList()[value],
          ),
        },
    destinations: destinations.values.toList(),
  );
}

// class NavigationExample extends StatefulWidget {
//   const NavigationExample({super.key});

//   @override
//   State<NavigationExample> createState() => _NavigationExampleState();
// }

// class _NavigationExampleState extends State<NavigationExample> {
//   int currentPageIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return Scaffold(
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             currentPageIndex = index;
//           });
//         },
//         indicatorColor: Colors.amber,
//         selectedIndex: currentPageIndex,
//         destinations: const <Widget>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.home),
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Badge(child: Icon(Icons.notifications_sharp)),
//             label: 'Notifications',
//           ),
//           NavigationDestination(
//             icon: Badge(label: Text('2'), child: Icon(Icons.messenger_sharp)),
//             label: 'Messages',
//           ),
//         ],
//       ),
//       body:
//           <Widget>[
//             /// Home page
//             Card(
//               shadowColor: Colors.transparent,
//               margin: const EdgeInsets.all(8.0),
//               child: SizedBox.expand(
//                 child: Center(
//                   child: Text('Home page', style: theme.textTheme.titleLarge),
//                 ),
//               ),
//             ),

//             /// Notifications page
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 children: <Widget>[
//                   Card(
//                     child: ListTile(
//                       leading: Icon(Icons.notifications_sharp),
//                       title: Text('Notification 1'),
//                       subtitle: Text('This is a notification'),
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: Icon(Icons.notifications_sharp),
//                       title: Text('Notification 2'),
//                       subtitle: Text('This is a notification'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// Messages page
//             ListView.builder(
//               reverse: true,
//               itemCount: 2,
//               itemBuilder: (BuildContext context, int index) {
//                 if (index == 0) {
//                   return Align(
//                     alignment: Alignment.centerRight,
//                     child: Container(
//                       margin: const EdgeInsets.all(8.0),
//                       padding: const EdgeInsets.all(8.0),
//                       decoration: BoxDecoration(
//                         color: theme.colorScheme.primary,
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Text(
//                         'Hello',
//                         style: theme.textTheme.bodyLarge!.copyWith(
//                           color: theme.colorScheme.onPrimary,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 return Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.all(8.0),
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.primary,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(
//                       'Hi!',
//                       style: theme.textTheme.bodyLarge!.copyWith(
//                         color: theme.colorScheme.onPrimary,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ][currentPageIndex],
//     );
//   }
// }
