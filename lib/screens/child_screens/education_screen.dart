// lib/screens/education_mobile_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_education_page.dart';
import 'education_details_screen.dart';
import 'package:vvs_app/theme/app_colors.dart'; // for AppColors if needed
import 'package:vvs_app/widgets/ui_components.dart'; // for AppTitle

class EducationMobileScreen extends StatefulWidget {
  const EducationMobileScreen({super.key});

  @override
  State<EducationMobileScreen> createState() => _EducationMobileScreenState();
}

class _EducationMobileScreenState extends State<EducationMobileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> orgList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isLoading = true;
  final Color _vvsGold = const Color(0xFFFF6F00);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEducationData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredList = orgList
          .where((org) => (org['orgName'] ?? '')
          .toString()
          .toLowerCase()
          .contains(query))
          .toList();
    });
  }

  Future<void> fetchEducationData() async {
    try {
      final snapshot =
      await _firestore.collection('educational_organisations').get();
      setState(() {
        orgList = snapshot.docs
            .map((d) => (d.data()..['id'] = d.id) as Map<String, dynamic>)
            .toList();
        filteredList = List.from(orgList);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching education orgs: $e');
      setState(() => isLoading = false);
    }
  }

  Widget buildNetworkImage(String? imageUrl) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return Container(
        height: 140,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(Icons.school, size: 48, color: Colors.grey),
      );
    }

    return Image.network(
      url,
      height: 140,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 140,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, st) {
        return Container(
          height: 140,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        );
      },
    );
  }

  Widget _eduCard(Map<String, dynamic> org) {
    final String name = org['orgName'] ?? 'No Name';
    final String type = org['orgType'] ?? 'Unknown';
    final String address = org['address'] ?? 'No Address';
    final String? imageUrl = org['imageUrl'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EducationDetailsScreen(
                title: name,
                imageUrl: imageUrl ?? '',
                type: type,
                address: address,
                contact: org['contact'] ?? '',
                website: org['website'] ?? '',
                description: org['description'] ?? '',
              ),
            ));
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNetworkImage(imageUrl),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.school, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.category, size: 16, color: Colors.green),
                    const SizedBox(width: 6),
                    Text("Type: $type", style: const TextStyle(fontSize: 13)),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(address,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eduInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 24),
        AppTitle('Empowering Through Education'),
        SizedBox(height: 16),
        Text(
          'Education is the foundation of a progressive society. The Varshney Vaishy Samaj (VVS) is committed '
              'to nurturing young minds and supporting lifelong learners across our community.',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 16),
        AppTitle('Our Initiatives'),
        SizedBox(height: 8),
        Text(
          '• Scholarships and financial aid for deserving students\n'
              '• Career guidance and mentorship by professionals\n'
              '• Educational seminars and workshops\n'
              '• Coaching and exam preparation resources\n'
              '• Promoting digital literacy and skill development',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 16),
        AppTitle('Mentor & Support'),
        SizedBox(height: 8),
        Text(
          'Are you an educator, professional, or academician? Join our mentor network and inspire the next generation.',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _body() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('No educational organisations found.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: fetchEducationData,
            style: ElevatedButton.styleFrom(backgroundColor: _vvsGold),
            child: const Text('Reload'),
          )
        ]),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length + 2, // +2 for header & info section
      itemBuilder: (context, i) {
        if (i == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search organizations...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Education Organizations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Explore all registered education organizations. Click on a card for full details.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
            ],
          );
        } else if (i <= filteredList.length) {
          return _eduCard(filteredList[i - 1]);
        } else {
          // Paragraph section after cards
          return _eduInfoSection();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: _vvsGold,
        title: const Text('Educational Organisations',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _body(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterEducationPage()));
          },
          icon: const Icon(Icons.add_business, color: Colors.white),
          label: const Text('Add Organisation',
              style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _vvsGold,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
