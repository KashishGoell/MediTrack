import 'package:flutter/material.dart';

class MedicineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background
      appBar: AppBar(
        title: Text('Medicine & Orders'),
        backgroundColor: Colors.blueGrey, // Consistent AppBar color
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Available Medicines',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Title color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // List of Medicines
            Expanded(
              child: ListView(
                children: [
                  _buildMedicineItem('Paracetamol', '500 mg', 20.0),
                  _buildMedicineItem('Aspirin', '100 mg', 15.0),
                  _buildMedicineItem('Amoxicillin', '250 mg', 30.0),
                  _buildMedicineItem('Cough Syrup', '100 ml', 25.0),
                  // Add more items here
                ],
              ),
            ),
            SizedBox(height: 20),
            // Place Order Button
            ElevatedButton(
              onPressed: () {
                // Handle order placement here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: Text('Place Order'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey, // Button background color
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineItem(String name, String dosage, double price) {
    return Card(
      color: Colors.grey[900], // Card background color
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Title text color
          ),
        ),
        subtitle: Text(
          '$dosage\nPrice: \$${price.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.white70, // Subtitle text color
          ),
        ),
        tileColor: Colors.grey[800], // Tile background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
