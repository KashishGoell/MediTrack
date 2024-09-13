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
      backgroundColor: Colors.black87, // Dark background
      appBar: AppBar(
        title: Text('QR Code Details'),
        backgroundColor: Colors.blueGrey, // Consistent AppBar color
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Decoded QR Data:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Title color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Display the decoded data
            Expanded(
              child: ListView(
                children: decodedData.entries.map((entry) => _buildDetailSection(entry.key, entry.value)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String key, dynamic value) {
    return Card(
      color: Colors.grey[900], // Card background color
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[300], // Key color
              ),
            ),
            SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Value color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _decodeQRData(String data) {
    final decryptedData = _decryptQRData(data, aadharNumber);

    // Debug: Print decrypted data to ensure it's correct
    print("Decrypted Data: $decryptedData");

    try {
      // Attempt to parse as JSON
      return jsonDecode(decryptedData);
    } catch (e) {
      final pairs = decryptedData.split('|');
      Map<String, dynamic> result = {};
      for (var pair in pairs) {
        final keyValue = pair.split('=');
        if (keyValue.length == 2) {
          result[keyValue[0].trim()] = keyValue[1].trim();
        }
      }
      if (result.isEmpty) {
        return {'Raw Data': decryptedData};
      }
      return result;
    }
  }

  String _decryptQRData(String encryptedData, String aadharNumber) {
    try {
      final encryptedBytes = base64.decode(encryptedData);
      final iv = encrypt.IV(Uint8List.fromList(encryptedBytes.sublist(0, 16)));
      final cipherText = encrypt.Encrypted(Uint8List.fromList(encryptedBytes.sublist(16)));
      final key = encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(aadharNumber)).bytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: null));

      final decryptedData = encrypter.decrypt(cipherText, iv: iv);

      return _pkcs7Unpad(decryptedData);
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String _pkcs7Unpad(String data) {
    final decryptedBytes = Uint8List.fromList(data.codeUnits);
    final padValue = decryptedBytes.last;

    if (padValue < 1 || padValue > 16) {
      throw FormatException('Invalid padding');
    }

    return utf8.decode(decryptedBytes.sublist(0, decryptedBytes.length - padValue));
  }
}
