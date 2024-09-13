import 'package:flutter/material.dart';
import 'package:apphaiapp/qr_code_scanner_screen.dart';
import 'medicine_screen.dart';
import 'inventory_screen.dart';
import 'orders_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light background color (#F6F6F9)
      backgroundColor: Color(0xFFF6F6F9),
      appBar: AppBar(
        title: Text('Welcome, $name'),
        backgroundColor: Color(0xFF5995F0), // Primary color (#5995F0)
        elevation: 0,
        actions: [
          // Notifications Icon
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          // Profile Icon
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    name: 'Kashish',
                    dob: '1990-01-01',
                    aadhaarNumber: '123456',
                    phoneNumber: '9876',
                    state: '',
                    city: 'Mumbai',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Welcome Text
            Text(
              'Hi, $name!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Header text color
                fontFamily: 'Rany', // Ensure font consistency
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Grid of Feature Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Number of columns
                mainAxisSpacing: 20, // Vertical spacing
                crossAxisSpacing: 20, // Horizontal spacing
                children: [
                  _buildFeatureCard(
                    icon: Icons.qr_code_scanner,
                    label: 'Scan QR Code',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnhancedQRCodeScannerScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.medication,
                    label: 'Check Medicine & Order',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.inventory,
                    label: 'View Inventory',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.shopping_cart,
                    label: 'View Orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.notifications_active,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature cards
  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFF5995F0), backgroundColor: Colors.white, // Text and icon color
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5, // Shadow effect
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Color(0xFF5995F0), // Icon color
          ),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
            ),
          ),
        ],
      ),
    );
  }
}
