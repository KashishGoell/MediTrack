import 'package:flutter/material.dart';
import 'package:apphaiapp/qr_code_scanner_screen.dart';
import 'medicine_screen.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background
      appBar: AppBar(
        title: Text('Welcome, $name'),
        backgroundColor: Colors.blueGrey, // Red background for the AppBar
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Text
              Text(
                'Hi, $name!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Title color
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // QR Code Scanner Button
              _buildOptionButton(
                label: 'Scan QR Code',
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnhancedQRCodeScannerScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Medicine Check Button
              _buildOptionButton(
                label: 'Check Medicine & Place Order',
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicineScreen(), // Replace with your Medicine screen
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color, // Text color
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

