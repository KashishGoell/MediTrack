import 'package:apphaiapp/qr_code_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:apphaiapp/src/features/authentication/screens/qr_scanner_screen/qr_scanner.dart';
import 'qr_details_screen.dart';
import 'login_screen.dart';
import 'user_type_selection_screen.dart' ;
void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserTypeSelectionScreen(),
    );
  }
}
