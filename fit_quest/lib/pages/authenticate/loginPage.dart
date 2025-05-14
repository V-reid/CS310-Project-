import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/inputs.dart';
import 'package:fit_quest/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  final Function changeView;

  const LoginPage({Key? key, required this.changeView}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();

  Widget actions() {
    return Column(
      children: [
        Inputs.formButton(
          state: _formKey.currentState,
          backgroundColor: UI.primary,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              dynamic result = await _auth.signIn(email, password);
              if (result == null) {
                setState(() {
                  error = 'Wrong credentials';
                });
              } else {
                debugPrint('Logged in');
              }
            }
          },
          text: "Link Start",
          textColor: Colors.white,
        ),

        Inputs.formButton(
          state: _formKey.currentState,
          onPressed: () => widget.changeView(),
          text: "Sign Up",
          isPrimary: false,
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10,
        children: [
          TextFormField(
            validator: Validators.email,
            onChanged: (value) {
              setState(() {
                email = value ?? '';
              });
            },
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.emailAddress,

            decoration: Inputs.inputDecoration("Email", Icons.email),
          ),
          TextFormField(
            validator: Validators.password,
            onChanged: (value) {
              setState(() {
                password = value ?? '';
              });
            },
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,

            decoration: Inputs.inputDecoration("Password", Icons.password),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: UI.padx(40),
        child: Center(
          // add image here
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/fit_quest_logo.svg',),
              Text("FitQuest", style: TextStyle(fontSize: 24)),
              form(),
              actions(),
              Text(error, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
