import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual settings content
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'Settings Options Here',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
