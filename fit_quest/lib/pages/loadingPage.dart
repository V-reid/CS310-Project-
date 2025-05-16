import 'package:fit_quest/common/common.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final Widget? floatingActionButton;
  const LoadingPage({super.key, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Common.text(data: 'Loading data...'),
                CircularProgressIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
