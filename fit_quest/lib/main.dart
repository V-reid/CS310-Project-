import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/pages/allPages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/errorPage.dart';
import 'package:fit_quest/pages/loadingPage.dart';
import 'package:fit_quest/pages/wrapper.dart';
import 'package:fit_quest/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:fit_quest/state/trainingScheduleProvider.dart';

void main() {
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = TrainingScheduleProvider();
        provider.loadSchedule(); // Load saved data
        return provider;
      },
      child: MyApp(),
    ),
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => TrainingScheduleProvider()),
    //   ],
    //   child: const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder:
          (context, snapshot) =>
              snapshot.hasError
                  ? MaterialApp(
                    home: ErrorPage(errorDetail: "Error on initialization!"),

                    routes: {
                      "/": (context) => Text("PORCA MADONNA"),
                      "/profile": (context) => ProfilePage(),
                      "/mockup": (context) => MockupPage(),
                      "/mockup/single": (context) => SingleMockup(),
                      "/schedule": (context) => SchedulePage(),
                      "/quests": (context) => QuestsPage(),
                    },

                    
                  )
                  : snapshot.connectionState == ConnectionState.done
                  ? StreamProvider<FitUser?>.value(
                    value: AuthService().user,
                    initialData: null,
                    child: MaterialApp(home: Wrapper()),
                  )
                  : MaterialApp(home: LoadingPage()),

    );
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       // Requirement 1: Named Routes
//       initialRoute: "/login",
//       debugShowCheckedModeBanner: false,

//       // Requirement 4: Custom Font
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         fontFamily: "Pokemon",
//         navigationBarTheme: NavigationBarThemeData(
//           indicatorColor: Colors.orange,
//           labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
//             return TextStyle(fontSize: 8, color: Colors.white);
//           }),
//         ),
//       ),

//       // Requirement 1: Named Routes
//       routes: {
//         "/login": (context) => LoginPage(),
//         "/signup": (context) => SignUpPage(),
//         "/": (context) => HomePage(),
//         "/profile": (context) => ProfilePage(),
//         "/mockup": (context) => MockupPage(),
//         "/mockup/single": (context) => SingleMockup(),
//         "/schedule": (context) => SchedulePage(),
//         "/campaign": (context) => CampaignPage(),
//         "/fight": (context) => FightPage(),
//         "/quests": (context) => QuestsPage(),
//       },
//     );
//   }
// }

// class Main extends StatefulWidget {
//   const Main({super.key, required this.title});

//   final String title;

//   @override
//   State<Main> createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   @override
//   Widget build(BuildContext context) {
//     return pageLayer(
//       context: context,
//       pageName: "HOME",
//       body: Center(
//         child: Container(
//           padding: UI.pady(40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             spacing: 15,
//             children: [],
//           ),
//         ),
//       ),
//     );
//   }
// }
