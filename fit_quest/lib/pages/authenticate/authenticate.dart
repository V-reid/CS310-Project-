import 'package:fit_quest/pages/authenticate/loginPage.dart';
import 'package:fit_quest/pages/authenticate/signUpPage.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void changeView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? LoginPage(changeView: changeView)
        : SignUpPage(changeView: changeView);
  }
}
