// lib/screens/education_details_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationDetailsScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String type;
  final String address;
  final String contact;
  final String website;
  final String description;

  const EducationDetailsScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.address,
    required this.contact,
    required this.website,
    required this.description,
  });

  Widget _buildRow(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Future<void> _launchUrl(String rawUrl) async {
    final url = rawUrl.trim();
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color _vvsGold = const Color(0xFFFF6F00);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education details'),
        backgroundColor: _vvsGold,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            imageUrl.isEmpty
                ? Container(
              height: 200,
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.school, size: 72)),
            )
                : Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()));
                },
                errorBuilder: (c, e, s) {
                  return Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.broken_image, size: 72)));
                }),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildRow(Icons.category, 'Type: $type'),
                  const SizedBox(height: 10),
                  _buildRow(Icons.location_on, address),
                  const SizedBox(height: 10),
                  if (contact.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        final uri = Uri(scheme: 'tel', path: contact);
                        launchUrl(uri);
                      },
                      child: _buildRow(Icons.phone, contact),
                    ),
                  const SizedBox(height: 10),
                  if (website.isNotEmpty)
                    GestureDetector(
                      onTap: () => _launchUrl(website),
                      child: _buildRow(Icons.public, website),
                    ),
                  const SizedBox(height: 16),
                  const Text('Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description.isNotEmpty ? description : 'No description provided.',
                      style: const TextStyle(fontSize: 14, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
