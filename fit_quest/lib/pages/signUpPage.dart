import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/inputs.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;
  String? password;
  String? username;
  String? confirmPassword;

  final _formKey = GlobalKey<FormState>();

  Widget actions() {
    return Column(
      children: [
        Inputs.formButton(
          state: _formKey.currentState,
          backgroundColor: UI.primary,
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
          text: "Sign up",
          textColor: Colors.white,
        ),
        Inputs.formButton(
          state: _formKey.currentState,
          onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
          text: "Back",
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
            validator: (val) => val == "" ? "This filed is required" : null,
            onChanged: (value) {
              setState(() {
                username = value != "" ? value : null;
              });
            },
            style: TextStyle(fontSize: 12),
            onSaved:
                (value) => setState(() {
                  username = value;
                }),
            decoration: Inputs.inputDecoration("Username", Icons.person),
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

          TextFormField(
            validator:
                (val) => val != password ? "Not equals to password" : null,
            onChanged: (value) {
              setState(() {
                confirmPassword = value != "" ? value : null;
              });
            },
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onSaved:
                (value) => setState(() {
                  confirmPassword = value;
                }),
            decoration: Inputs.inputDecoration(
              "Confirm password",
              Icons.password,
            ),
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
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Start Your Journey",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              form(),
              actions(),
            ],
          ),
        ),
      ),
    );
  }
}
