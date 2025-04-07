import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/common/navigation.dart';
import 'package:flutter/material.dart';

Widget pageLayer({
  required BuildContext context,
  required String pageName,
  required Widget body,
  FloatingActionButton? floatingActionButton,
}) {
  return Scaffold(
    appBar: Common.appBar(pageName),
    bottomNavigationBar: navigationBar(context),
    body: body,
    floatingActionButton: floatingActionButton,
  );
}
