import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class QRDetailsScreen extends StatelessWidget {
  final String qrData;
  final String aadharNumber;

  const QRDetailsScreen({Key? key, required this.qrData, required this.aadharNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> decodedData = _decodeQRData(qrData);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('QR Code Details'),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Decoded QR Data:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            ...decodedData.entries.map((entry) => _buildDetailSection(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String key, dynamic value) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[300],
              ),
            ),
            SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _decodeQRData(String data) {
    // Decrypt QR data
    final decryptedData = _decryptQRData(data, aadharNumber);

    // Debug: Print decrypted data to ensure it's correct
    print("Decrypted Data: $decryptedData");

    // Parse the decrypted data
    try {
      // Attempt to parse as JSON
      return jsonDecode(decryptedData);
    } catch (e) {
      // If JSON parsing fails, split the string by '|' and create a map
      final pairs = decryptedData.split('|');
      Map<String, dynamic> result = {};
      for (var pair in pairs) {
        final keyValue = pair.split('=');
        if (keyValue.length == 2) {
          result[keyValue[0].trim()] = keyValue[1].trim();
        }
      }
      if (result.isEmpty) {
        // If splitting also fails, return the raw decrypted data
        return {'Raw Data': decryptedData};
      }
      return result;
    }
  }

  String _decryptQRData(String encryptedData, String aadharNumber) {
    try {
      // Decode base64-encoded data
      final encryptedBytes = base64.decode(encryptedData);

      // Extract the IV from the first 16 bytes
      final iv = encrypt.IV(Uint8List.fromList(encryptedBytes.sublist(0, 16)));

      // Extract the actual encrypted content
      final cipherText = encrypt.Encrypted(Uint8List.fromList(encryptedBytes.sublist(16)));

      // Generate key using Aadhaar number
      final key = encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(aadharNumber)).bytes));

      // Set up AES decryption using CBC mode
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: null), // No padding
      );

      // Decrypt the data
      final decryptedData = encrypter.decrypt(cipherText, iv: iv);

      // Unpad the decrypted data (PKCS7 Padding)
      return _pkcs7Unpad(decryptedData);
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String _pkcs7Unpad(String data) {
    // Convert decrypted string back to bytes for unpadding
    final decryptedBytes = Uint8List.fromList(data.codeUnits);
    final padValue = decryptedBytes.last;

    if (padValue < 1 || padValue > 16) {
      throw FormatException('Invalid padding');
    }

    // Remove the padding bytes
    return utf8.decode(decryptedBytes.sublist(0, decryptedBytes.length - padValue));
  }
}