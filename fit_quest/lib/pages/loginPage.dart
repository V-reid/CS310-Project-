import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  final _formKey = GlobalKey<FormState>();

  Widget actions() {
    return Column(
      children: [
        Inputs.formButton(
          state: _formKey.currentState,
          backgroundColor: UI.primary,
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/");
          },
          text: "Login",
          textColor: Colors.white,
        ),
        Inputs.formButton(
          state: _formKey.currentState,
          onPressed: () => Navigator.pushReplacementNamed(context, "/signup"),
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
                email = value != "" ? value : null;
              });
            },
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.emailAddress,

            onSaved:
                (value) => setState(() {
                  email = value;
                }),
            decoration: Inputs.inputDecoration("Email", Icons.email),
          ),
          TextFormField(
            validator: Validators.password,
            onChanged: (value) {
              setState(() {
                password = value != "" ? value : null;
              });
            },
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onSaved:
                (value) => setState(() {
                  password = value;
                }),
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
            ],
          ),
        ),
      ),
    );
  }
}
