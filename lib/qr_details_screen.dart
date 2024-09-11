import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt; // Use alias to avoid conflict
import 'package:url_launcher/url_launcher.dart';

class QRDetailsScreen extends StatelessWidget {
  final String qrData;
  final String aadharNumber;

  const QRDetailsScreen({Key? key, required this.qrData, required this.aadharNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> decodedData = _decodeQRData(qrData);

    return Scaffold(
      backgroundColor: Colors.black87, // Dark background
      appBar: AppBar(
        title: Text('QR Code Details'),
        backgroundColor: Colors.white, // Elegant AppBar color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Decoded QR Data:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Elegant title color
              ),
            ),
            SizedBox(height: 16),
            // Details
            ...decodedData.entries.map((entry) => _buildDetailRow(entry.key, entry.value)),
            SizedBox(height: 24),
            // Open URL Button
            if (_isURL(qrData))
              _buildOptionButton(
                label: 'Open URL',
                textColor: Colors.white,
                onPressed: () => _launchURL(qrData, context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String key, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Elegant key color
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white), // Text color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blueGrey], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor, backgroundColor: Colors.transparent, // Text color
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5, // Set elevation directly
        ).copyWith(
          shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.5)),
        ),
      ),
    );
  }

  Map<String, dynamic> _decodeQRData(String data) {
    // Assuming `data` contains encrypted data
    final decryptedData = _decryptQRData(data, aadharNumber);

    if (decryptedData['Type'] == 'Error') {
      return {
        'Type': 'Error',
        'Message': decryptedData['Message'],
      };
    }

    // Handle decrypted data
    if (_isURL(decryptedData['Content'])) {
      return {
        'Type': 'URL',
        'Content': decryptedData['Content'],
      };
    } else {
      // Assuming decrypted data is in JSON format
      return _parseDecryptedData(decryptedData['Content']);
    }
  }

  Map<String, dynamic> _decryptQRData(String encryptedData, String aadharNumber) {
    try {
      // Decode base64-encoded data
      final encryptedBytes = base64.decode(encryptedData);

      // Extract the IV from the first 16 bytes
      final iv = encrypt.IV(Uint8List.fromList(encryptedBytes.sublist(0, 16)));

      // Extract the actual encrypted content
      final cipherText = encrypt.Encrypted(Uint8List.fromList(encryptedBytes.sublist(16)));

      // Generate key using Aadhaar number
      final key = encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(aadharNumber)).bytes));

      // Set up AES decryption using CBC mode (use an appropriate mode)
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );

      // Decrypt the data
      final decryptedData = encrypter.decrypt(cipherText, iv: iv);

      return {
        'Type': 'Decrypted Data',
        'Content': decryptedData,
      };
    } catch (e) {
      return {
        'Type': 'Error',
        'Message': 'Failed to decrypt data: ${e.toString()}',
      };
    }
  }

  Map<String, dynamic> _parseDecryptedData(String data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return {
        'Type': 'Error',
        'Message': 'Failed to parse decrypted data: ${e.toString()}',
      };
    }
  }

  bool _isURL(String str) {
    return str.toLowerCase().startsWith('http://') || str.toLowerCase().startsWith('https://');
  }

  void _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
