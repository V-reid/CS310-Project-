import 'package:fit_quest/common/layer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return pageLayer(context: context, pageName: "PROFILE", body: Container());
  }
}
