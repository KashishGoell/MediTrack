import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'qr_details_screen.dart';

class EmailInputScreen extends StatefulWidget {
  final String qrData;
  final String aadharNumber;

  const EmailInputScreen({Key? key, required this.qrData, required this.aadharNumber}) : super(key: key);

  @override
  _EmailInputScreenState createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  String? _otp;
  bool _otpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final response = await http.post(
      Uri.parse('http://172.17.80.231:5000/send-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _otp = responseData['otp'];
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  void _verifyOTP() {
    if (_otpController.text == _otp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verified successfully')),
      );
      _navigateToQRDetails();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verified successfully')),
      );
    }
  }

  void _navigateToQRDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRDetailsScreen(
          qrData: widget.qrData,
          aadharNumber: widget.aadharNumber,
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      child: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFF5995F0), // Text color
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F9), // Light background color
      appBar: AppBar(
        title: Text('Enter Email'),
        backgroundColor: Color(0xFF5995F0), // AppBar color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Input Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black), // Text color
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.black54), // Placeholder text color
                filled: true,
                fillColor: Colors.white, // Input field color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildButton('Send OTP', _sendOTP),
            if (_otpSent) ...[
              SizedBox(height: 20),
              // OTP Input Field
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black), // Text color
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  hintStyle: TextStyle(color: Colors.black54), // Placeholder text color
                  filled: true,
                  fillColor: Colors.white, // Input field color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildButton('Verify OTP', _verifyOTP),
            ],
            SizedBox(height: 20),
            _buildButton('See Details', _navigateToQRDetails),
          ],
        ),
      ),
    );
  }
}
