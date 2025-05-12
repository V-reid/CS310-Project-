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
              children: [Text('Loading data...'), CircularProgressIndicator()],
            ),
          ],
        ),
      ),
    );
  }
}
