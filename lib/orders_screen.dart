import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual orders content
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'Orders Details Here',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
