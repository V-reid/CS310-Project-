import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/pages/campaignPage.dart';
import 'package:fit_quest/pages/dailyPage.dart';
import 'package:fit_quest/pages/fightPage.dart';
import 'package:fit_quest/pages/homePage.dart';
import 'package:fit_quest/pages/loginPage.dart';
import 'package:fit_quest/pages/mockup/mockupPage.dart';
import 'package:fit_quest/pages/mockup/singleMockup.dart';
import 'package:fit_quest/pages/profilePage.dart';
import 'package:fit_quest/pages/schedulePage.dart';
import 'package:fit_quest/pages/signUpPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/login",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: "Pokemon",
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.orange,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            return TextStyle(fontSize: 8, color: Colors.white);
          }),
        ),
      ),
      routes: {
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignUpPage(),
        "/": (context) => HomePage(),
        "/profile": (context) => ProfilePage(),
        "/mockup": (context) => MockupPage(),
        "/mockup/single": (context) => SingleMockup(),
        "/schedule": (context) => SchedulePage(),
        "/campaign": (context) => CampaignPage(),
        "/fight": (context) => FightPage(),
        "/quests": (context) => DailyPage(),
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});

  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return pageLayer(
      context: context,
      pageName: "HOME",
      body: Center(
        child: Container(
          padding: UI.pady(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 15,
            children: [],
          ),
        ),
      ),
    );
  }
}
