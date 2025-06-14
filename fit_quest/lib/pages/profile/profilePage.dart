import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/layer.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/errorPage.dart';
import 'package:fit_quest/pages/loadingPage.dart';
import 'package:fit_quest/pages/profile/EditProfile.dart';
import 'package:fit_quest/pages/profile/components.dart';
import 'package:fit_quest/services/auth.dart';
import 'package:fit_quest/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool edit = false;

  final AuthService _auth = AuthService();

  Widget singOut(AuthService auth) => FloatingActionButton(
    onPressed: () async {
      await auth.signOut();
    },
    child: Icon(Icons.logout),
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FitUser?>(context);

    return StreamBuilder<UserData?>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          if (userData == null) return ErrorPage(errorDetail: "error");
          return pageLayer(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      edit = !edit;
                    });
                  },
                  child: Icon(Icons.edit),
                ),
                singOut(_auth),
              ],
            ),
            context: context,
            pageName: "PROFILE",
            body:
                !edit
                    ? SingleChildScrollView(
                      child: Column(
                        spacing: 40,
                        children: [
                          Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profileImage(userData),
                              profileInfo(userData),
                            ],
                          ),
                          Common.sectionName(
                            title: "Attributes",
                            flexs: [0, 4, 5],
                          ),
                          userData.attributes.isEmpty
                              ? Center(
                                child: Common.title(data: "No attributes"),
                              )
                              : Common.Grid<Attribute>(
                                items: userData.attributes.values.toList(),
                                toElement: (x) => statsCard(x),
                              ),

                          // _buildAttributesGrid(userData),
                          Common.sectionName(title: "Badges", flexs: [0, 2, 5]),
                          userData.badges.isEmpty
                              ? Center(child: Common.title(data: "No Badges"))
                              : Common.Grid<ProfileBadge>(
                                col: 2,
                                items: userData.badges,
                                toElement: (x) => badgeWidget(x),
                              ),
                        ],
                      ),
                    )
                    : EditProfile(
                      changeEdit:
                          () => setState(() {
                            edit = false;
                          }),
                    ),
          );
        }
        return LoadingPage(floatingActionButton: singOut(_auth));
      },
    );
  }
}
