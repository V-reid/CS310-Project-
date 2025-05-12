import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  String errorDetail;
  ErrorPage({required this.errorDetail, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(errorDetail)],
            ),
          ],
        ),
      ),
    );
  }
}
