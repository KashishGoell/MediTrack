import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _idNumber;
  String? _phoneNumber;
  bool _isPharmacyOwner = false;

  String? get name => _name;
  String? get idNumber => _idNumber;
  String? get phoneNumber => _phoneNumber;
  bool get isPharmacyOwner => _isPharmacyOwner;

  void setUserDetails({
    required String name,
    required String idNumber,
    required String phoneNumber,
    required bool isPharmacyOwner,
  }) {
    _name = name;
    _idNumber = idNumber;
    _phoneNumber = phoneNumber;
    _isPharmacyOwner = isPharmacyOwner;
    notifyListeners();
  }

  void clearUserDetails() {
    _name = null;
    _idNumber = null;
    _phoneNumber = null;
    _isPharmacyOwner = false;
    notifyListeners();
  }
}