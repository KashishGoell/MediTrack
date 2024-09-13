import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blueGrey, // Consistent AppBar color
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: Colors.grey[900], // Card background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No new notifications',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
