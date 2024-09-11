import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'qr_details_screen.dart';

class EnhancedQRCodeScannerScreen extends StatefulWidget {
  @override
  _EnhancedQRCodeScannerScreenState createState() => _EnhancedQRCodeScannerScreenState();
}

class _EnhancedQRCodeScannerScreenState extends State<EnhancedQRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  bool isFlashOn = false;
  String? aadharNumber;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Spacer(),
                if (qrText != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scanned Result:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          qrText!,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              label: 'Open URL',
                              onPressed: () => _launchURL(qrText!),
                              color: Colors.blue,
                            ),
                            _buildActionButton(
                              label: 'See Details',
                              onPressed: _promptForAadharNumber,  // Updated to prompt for Aadhar Number
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(
                      icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                      onPressed: _toggleFlash,
                    ),
                    _buildIconButton(
                      icon: Icons.flip_camera_ios,
                      onPressed: _flipCamera,
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      child: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        iconSize: 28,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  void _toggleFlash() {
    controller?.toggleFlash();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  void _flipCamera() {
    controller?.flipCamera();
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  void _promptForAadharNumber() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController aadharController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Aadhar Number'),
          content: TextField(
            controller: aadharController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Aadhar Number'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  aadharNumber = aadharController.text;
                });
                _navigateToDetailsScreen(qrText!, aadharNumber!);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetailsScreen(String qrData, String aadharNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRDetailsScreen(qrData: qrData, aadharNumber: aadharNumber),
      ),
    );
  }
}