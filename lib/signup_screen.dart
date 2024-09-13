import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F9), // Light background color (#F6F6F9)
      body: SingleChildScrollView(
        child: Center(
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
                        'Sign Up',
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
                        obscureText: false,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                      ),
                      SizedBox(height: 16),
                      _buildDateField(),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _aadhaarController,
                        label: 'PAN Number',
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your PAN number' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'E-mail',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your E-mail' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _stateController,
                        label: 'State',
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your state' : null,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _cityController,
                        label: 'City',
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your city' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(name: _nameController.text),
                              ),
                            );
                          }
                        },
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
    required bool obscureText,
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
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // Text color
      validator: validator,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
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
        suffixIcon: Icon(Icons.calendar_today, color: Colors.black54),
      ),
      style: TextStyle(color: Colors.black), // Text color
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: (value) => value?.isEmpty ?? true ? 'Please enter your date of birth' : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF5995F0), // Primary color (#5995F0)
              onPrimary: Colors.white,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[800],
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
