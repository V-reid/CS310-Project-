import 'dart:core';

import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/inputs.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/errorPage.dart';
import 'package:fit_quest/pages/profile/profilePage.dart';
import 'package:fit_quest/services/auth.dart';
import 'package:fit_quest/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Widget profileImage(UserData userData) {
  return Column(
    spacing: 5,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(userData?.profilePic ?? "assets/notFound.jpeg"),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(overlayColor, blend),
          ),
          borderRadius: UI.borderRadius,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Container(),
      ),
      profileTextInfo("Lvl", (userData?.lvl ?? 1).toString()),
    ],
  );
}

Widget profileTextInfo(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: Colors.grey, fontSize: 10)),
      Text(value),
    ],
  );
}

Widget profileInfo(UserData userData) {
  return Column(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      profileTextInfo("Name", userData.name),
      Row(
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          profileTextInfo("Age", userData.age.toString()),
          profileTextInfo("Weight", "${userData.weight.toString()}kg"),
          profileTextInfo("Height", "${userData.height.toString()}cm"),
        ],
      ),
      Common.progressBar(
        current: userData.health[0],
        max: userData.health[1],
        width: 250,
        height: 20,
      ),
    ],
  );
}

Widget statsCard(Attribute stat) {
  double width = 180;
  return Container(
    width: width,
    height: 80,
    padding: UI.padx(15),
    decoration: BoxDecoration(borderRadius: UI.borderRadius, color: UI.accent),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 0,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Lvl", style: TextStyle(color: Colors.grey)),
            Text(stat.lvl.toString(), style: TextStyle(fontSize: 18)),
          ],
        ),
        Text(
          stat.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Common.progressBar(
          current: stat.exp[0],
          max: stat.exp[1],
          width: width,
          height: 10,
          fill: UI.primary,
          background: Colors.grey.shade200,
          right: 40,
        ),
      ],
    ),
  );
}

Widget badgeWidget(ProfileBadge badge) {
  Map<League, Color> colors = {
    League.bronze: Color(0xffcd7f32),
    League.silver: Color(0xffC0C0C0),
    League.gold: Color(0xffd4af37),
    League.platinum: Color(0xffe5e4e2),
    League.diamond: Color(0xffb9f2ff),
    League.legends: Color(0xff7f00ff),
  };

  Color current = colors[badge.league] ?? Colors.black;

  return Container(
    padding: UI.padxy(10, 5),
    decoration: BoxDecoration(borderRadius: UI.borderRadius, color: current),
    child: Text(
      badge.name,
      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
    ),
  );
}

class EditProfile extends StatefulWidget {
  final Function changeEdit;
  const EditProfile({Key? key, required this.changeEdit}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthService _auth = AuthService();

  String uid = "";
  String name = '';
  int age = 18;
  double weight = 0;
  double height = 0;

  String error = '';

  final _formKey = GlobalKey<FormState>();

  Widget actions() {
    return Column(children: [
        
      ],
    );
  }

  Widget form(UserData user) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 10,
        children: [
          TextFormField(
            validator: Validators.text,
            onChanged: (value) {
              setState(() {
                name = value ?? '';
              });
            },
            initialValue: name,
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.emailAddress,
            decoration: Inputs.inputDecoration("Name", Icons.email),
          ),

          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: Validators.positiveInt,
            initialValue: age.toString(),
            onChanged: (value) {
              setState(() {
                age = value != '' ? int.parse(value) : 0;
              });
            },
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration("Age", Icons.cake),
          ),

          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            initialValue: weight.toString(),
            validator: Validators.positiveDouble,
            onChanged: (value) {
              setState(() {
                weight = value != '' ? double.parse(value) : 0;
              });
            },
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration(
              "Weight (kg)",
              Icons.line_weight,
            ),
          ),

          TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            initialValue: height.toString(),
            validator: Validators.positiveDouble,
            onChanged: (value) {
              setState(() {
                height = value != '' ? double.parse(value) : 0;
              });
            },
            style: TextStyle(fontSize: 12),
            decoration: Inputs.inputDecoration("Height", Icons.height),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FitUser?>(context);
    if (user == null) return ErrorPage(errorDetail: "error");
    return StreamBuilder<UserData?>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        UserData? userData = snapshot.data;
        if (userData == null) return ErrorPage(errorDetail: "error");
        uid = userData.uid;
        name = userData.name;
        age = userData.age;
        weight = userData.weight;
        height = userData.height;
        return Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Start Your Journey",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            form(userData),

            Inputs.formButton(
              state: _formKey.currentState,
              backgroundColor: UI.primary,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print(user.uid);

                  dynamic result = await DatabaseService(
                    uid: user.uid!,
                  ).updateUserData(
                    UserData(
                      uid: uid,
                      name: name,
                      age: age,
                      weight: weight,
                      height: height,
                    ),
                  );

                  if (result == null) {
                    // setState(() {
                    //   error = '500 server error';
                    // });
                  } else {
                    widget.changeEdit();
                  }
                }
              },
              text: "Edit",
              textColor: Colors.white,
            ),
            Text(error, style: TextStyle(color: Colors.red)),
          ],
        );
      },
    );
  }
}
