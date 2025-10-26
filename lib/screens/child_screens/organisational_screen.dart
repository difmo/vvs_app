import 'package:flutter/material.dart';

class OrganizationDetailsScreen extends StatelessWidget {
  final String name;
  final String type;
  final String address;
  final String imagePath;
  final String district;
  final String governmentType;

  const OrganizationDetailsScreen({
    super.key,
    required this.name,
    required this.type,
    required this.address,
    required this.imagePath,
    required this.district,
    required this.governmentType,
  });

  // Helper widget to display a single detail row
  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFF6F00)),
          const SizedBox(width: 10),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6F00),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover, // Use BoxFit.cover or contain based on image aspect
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Title
            Text(
              name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const Divider(height: 25),

            // Details Section
            _detailRow(Icons.local_hospital, 'Type', type),
            _detailRow(Icons.apartment, 'Government Status', governmentType),
            _detailRow(Icons.location_city, 'District', district),
            _detailRow(Icons.location_on, 'Address', address),

            const Divider(height: 25),
            const Text(
              'About the Organization',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is the designated space for a detailed description of the health organization, including operating hours, specialized services, and contact information.',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}