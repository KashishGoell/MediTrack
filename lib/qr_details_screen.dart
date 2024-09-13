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
      backgroundColor: Colors.white10, // Dark background
      appBar: AppBar(
        title: Text('QR Code Details', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Decoded Information',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: decodedData.entries.map((entry) => _buildDetailSection(entry.key, entry.value)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String key, dynamic value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64B5F6), // Light blue color
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.87),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _decodeQRData(String data) {
    final decryptedData = _decryptQRData(data, aadharNumber);

    try {
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
      return result.isEmpty ? {'Raw Data': decryptedData} : result;
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