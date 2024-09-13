import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual notifications content
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'No new notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
