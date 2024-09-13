import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final bool isPharmacyOwner;

  LoginScreen({Key? key, required this.isPharmacyOwner}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F9), // Light background color (#F6F6F9)
      body: Center(
        child: SingleChildScrollView(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isPharmacyOwner ? 'Pharmacy Owner Login' : 'Consumer Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black text color for header
                          fontFamily: 'Rany', // Ensure you are using the 'Rany' font
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        keyboardType: TextInputType.text,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _idController,
                        label: isPharmacyOwner ? 'PAN Card Number' : 'Aadhaar Number',
                        keyboardType: TextInputType.text,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter your ${isPharmacyOwner ? 'PAN card number' : 'Aadhaar number'}'
                            : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _handleLogin(context),
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5995F0), // Button color (#5995F0)
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rany', // Ensure you are using the 'Rany' font
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen())),
                          child: Text(
                            'Not an existing user? Sign Up',
                            style: TextStyle(
                              color: Colors.grey[800], // Dark grey for the sign-up text
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rany', // Ensure you are using the 'Rany' font
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54), // Label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.black38),
        ),
      ),
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black), // Text color
      validator: validator,
    );
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      Provider.of<UserProvider>(context, listen: false).setUserDetails(
        name: _nameController.text,
        idNumber: _idController.text,
        phoneNumber: _phoneController.text,
        isPharmacyOwner: isPharmacyOwner,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(name: _nameController.text)),
      );
    }
  }
}
