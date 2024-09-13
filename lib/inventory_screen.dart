import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual inventory content
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'Inventory Details Here',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
