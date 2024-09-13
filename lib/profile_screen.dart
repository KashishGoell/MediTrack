import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String dob;
  final String aadhaarNumber;
  final String phoneNumber;
  final String state;
  final String city;

  const ProfileScreen({
    Key? key,
    required this.name,
    required this.dob,
    required this.aadhaarNumber,
    required this.phoneNumber,
    required this.state,
    required this.city,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildDetailsCard(),
            _buildActionButtons(),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$city, $state',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      margin: EdgeInsets.all(16),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.cake, 'Date of Birth', dob),
            Divider(color: Colors.grey),
            _buildDetailRow(Icons.credit_card, 'Aadhaar Number', _maskAadhaar(aadhaarNumber)),
            Divider(color: Colors.grey),
            _buildDetailRow(Icons.phone, 'Phone Number', phoneNumber),
            Divider(color: Colors.grey),
            _buildDetailRow(Icons.location_city, 'City', city),
            Divider(color: Colors.grey),
            _buildDetailRow(Icons.map, 'State', state),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.edit, 'Edit Profile', () {
            // TODO: Implement edit profile functionality
          }),
          _buildActionButton(Icons.settings, 'Settings', () {
            // TODO: Implement settings functionality
          }),
          _buildActionButton(Icons.logout, 'Logout', () {
            // TODO: Implement logout functionality
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _maskAadhaar(String aadhaar) {
    if (aadhaar.length != 12) return aadhaar;
    return 'XXXX XXXX ' + aadhaar.substring(8);
  }
}