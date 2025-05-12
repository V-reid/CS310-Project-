import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/authenticate/authenticate.dart';
import 'package:fit_quest/pages/home/homePage.dart';
import 'package:fit_quest/pages/navigationTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FitUser?>(context);
    if (user == null) {
      // Return Home or Authenticate
      return Authenticate();
    } else {
      return NavigationTab(uuid: user.uid);
    }
  }
}
