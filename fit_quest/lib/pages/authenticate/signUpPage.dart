import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/inputs.dart';
import 'package:fit_quest/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fit_quest/services/database.dart';

class SignUpPage extends StatefulWidget {
  final Function changeView;

  const SignUpPage({Key? key, required this.changeView}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  int age = 18;
  double weight = 0;
  double height = 0;
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
              try {
                dynamic result = await _auth.register(
                  email,
                  password,
                  name,
                  age,
                  weight,
                  height,
                );
                if (result != null) {
                  print('Success');
                  final db = DatabaseService(uid: result.uid);
                  await db.ensureDefaultGoalsExist(result.uid);
                }
              } catch (e) {
                setState(() {
                  error = e.toString();
                });
              }
            }
          },
          text: "Sign up",
          textColor: Colors.white,
        ),
        Inputs.formButton(
          state: _formKey.currentState,
          onPressed: () => widget.changeView(),
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
          TextFormField(
            validator:
                (val) => val != password ? "Not equals to password" : null,
            onChanged: (value) {
              setState(() {
                password = value ?? '';
              });
            },
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: Inputs.inputDecoration(
              "Confirm password",
              Icons.password,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 230),
                child: TextFormField(
                  validator: Validators.text,
                  onChanged: (value) {
                    setState(() {
                      name = value ?? '';
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  decoration: Inputs.inputDecoration("Name", Icons.person),
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: Validators.positiveInt,
                  onChanged: (value) {
                    setState(() {
                      age = value != '' ? int.parse(value) : 0;
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  decoration: Inputs.inputDecoration("Age", Icons.cake),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 165),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),

                  validator: Validators.positiveDouble,
                  onChanged: (value) {
                    setState(() {
                      weight = value != '' ? double.parse(value) : 0;
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  decoration: Inputs.inputDecoration(
                    "Weight(kg)",
                    Icons.line_weight,
                  ),
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 165),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),

                  validator: Validators.positiveDouble,
                  onChanged: (value) {
                    setState(() {
                      height = value != '' ? double.parse(value) : 0;
                    });
                  },
                  style: TextStyle(fontSize: 12),
                  decoration: Inputs.inputDecoration(
                    "Height(cm)",
                    Icons.height,
                  ),
                ),
              ),
            ],
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
              Common.text(
                data: "Start Your Journey",
                fontSize: 24,
                textAlign: TextAlign.center,
              ),
              form(),

              actions(),
              Common.text(data: error, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
