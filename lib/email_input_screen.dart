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
      Uri.parse('http://192.168.29.187:5000/send-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _otp = responseData['otp'];
        _otpSent = true;
      });
      _showSnackBar('OTP sent successfully');
    } else {
      _showSnackBar('Failed to send OTP');
    }
  }

  void _verifyOTP() {
    if (_otpController.text == _otp) {
      _showSnackBar('OTP verified successfully');
      _navigateToQRDetails();
    } else {
      _showSnackBar('OTP verified successfully.');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF5995F0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, TextInputType inputType) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: TextStyle(color: Color(0xFF5995F0)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF5995F0),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Email Verification', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF5995F0),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Enter Your Email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5995F0)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildInputField(_emailController, 'Enter your email', TextInputType.emailAddress),
              SizedBox(height: 20),
              _buildButton('Send OTP', _sendOTP),
              if (_otpSent) ...[
                SizedBox(height: 30),
                Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5995F0)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildInputField(_otpController, 'Enter OTP', TextInputType.number),
                SizedBox(height: 20),
                _buildButton('Verify OTP', _verifyOTP),
              ],
              SizedBox(height: 30),
              _buildButton('See Details', _navigateToQRDetails),
            ],
          ),
        ),
      ),
    );
  }
}