import 'package:flutter/material.dart';
import 'login_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F9), // Light background color (#F6F6F9)
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white, // Card color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8.0,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select User Type',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text color for this text
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  _buildUserTypeButton(
                    context,
                    'Pharmacy Owner',
                    Icons.local_pharmacy,
                    isPharmacyOwner: true,
                  ),
                  SizedBox(height: 16),
                  _buildUserTypeButton(
                    context,
                    'Regular Consumer',
                    Icons.person,
                    isPharmacyOwner: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeButton(
      BuildContext context,
      String label,
      IconData icon, {
        required bool isPharmacyOwner,
      }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white, // White text color for the button label
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(isPharmacyOwner: isPharmacyOwner),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF5995F0), // Button color (#5995F0)
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
