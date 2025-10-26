import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'organisational_screen.dart';
import 'register_clinic.dart';
import 'register_hospital_page.dart';
import 'register_medical_store.dart';

class HealthcareMobileScreen extends StatefulWidget {
  const HealthcareMobileScreen({super.key});

  @override
  State<HealthcareMobileScreen> createState() => _HealthcareMobileScreenState();
}

class _HealthcareMobileScreenState extends State<HealthcareMobileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> hospitalList = [];
  List<Map<String, dynamic>> clinicList = [];
  List<Map<String, dynamic>> medicalStoreList = [];

  // For search
  List<Map<String, dynamic>> filteredHospitals = [];
  List<Map<String, dynamic>> filteredClinics = [];
  List<Map<String, dynamic>> filteredMedicalStores = [];

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHealthcareData();
  }

  Future<void> fetchHealthcareData() async {
    try {
      final hospitalsSnapshot = await _firestore.collection('hospitals').get();
      final clinicsSnapshot = await _firestore.collection('clinics').get();
      final medicalStoresSnapshot =
      await _firestore.collection('medicalstores').get();

      setState(() {
        hospitalList = hospitalsSnapshot.docs
            .map((doc) => doc.data()..['id'] = doc.id)
            .toList();
        clinicList = clinicsSnapshot.docs
            .map((doc) => doc.data()..['id'] = doc.id)
            .toList();
        medicalStoreList = medicalStoresSnapshot.docs
            .map((doc) => doc.data()..['id'] = doc.id)
            .toList();

        filteredHospitals = List.from(hospitalList);
        filteredClinics = List.from(clinicList);
        filteredMedicalStores = List.from(medicalStoreList);

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredHospitals = List.from(hospitalList);
        filteredClinics = List.from(clinicList);
        filteredMedicalStores = List.from(medicalStoreList);
      } else {
        filteredHospitals = hospitalList
            .where((org) =>
            (org['orgName'] ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredClinics = clinicList
            .where((org) =>
            (org['orgName'] ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredMedicalStores = medicalStoreList
            .where((org) =>
            (org['orgName'] ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Add New Organization",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose the type of healthcare facility you want to register.",
                style: TextStyle(color: Colors.black54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _optionTile(
                icon: Icons.local_hospital,
                color: Colors.redAccent,
                title: "Add Hospital",
                subtitle: "Register a new hospital in the community",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterHospitalPage()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _optionTile(
                icon: Icons.medical_services,
                color: Colors.green,
                title: "Add Clinic",
                subtitle: "Add a local or private clinic",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterClinicPage()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _optionTile(
                icon: Icons.store,
                color: Colors.orange,
                title: "Add Medical Store",
                subtitle: "Register a nearby pharmacy or drug store",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const RegisterMedicalStorePage()),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _optionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Colors.grey[100],
    );
  }

  Widget _buildHorizontalCardList(List<Map<String, dynamic>> organizations) {
    if (organizations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Text(
          'No organizations listed in this category.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          final org = organizations[index];

          final String name = org['orgName'] ?? 'No Name';
          final String type = org['orgType'] ?? 'Unknown';
          final String address = org['address'] ?? 'No Address';
          final String district = org['district'] ?? '';
          final String governmentType = org['governmentType'] ?? 'Private';
          final String? imageUrl = org['imageUrl'];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 250,
              child: _healthCard(
                name,
                type,
                address,
                imageUrl,
                district,
                governmentType,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _healthCard(String name, String type, String address, String? imageUrl,
      String district, String governmentType) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationDetailsScreen(
              name: name,
              type: type,
              address: address,
              imagePath: imageUrl?.trim() ?? "",
              district: district,
              governmentType: governmentType,
            ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNetworkImage(imageUrl),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.local_hospital, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.category, size: 14, color: Colors.green),
                    const SizedBox(width: 6),
                    Text("Type: $type", style: const TextStyle(fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.redAccent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNetworkImage(String? imageUrl) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return Container(
        height: 120,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
    }

    return Image.network(
      url,
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 120,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 120,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6F00),
        title: const Text(
          'Health Care',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            TextField(
              controller: _searchController,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: 'Search organizations...',
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Choose an organization to explore",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Hospitals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildHorizontalCardList(filteredHospitals),
            const SizedBox(height: 25),
            const Text(
              "Clinics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildHorizontalCardList(filteredClinics),
            const SizedBox(height: 25),
            const Text(
              "Medical Stores",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildHorizontalCardList(filteredMedicalStores),
            const SizedBox(height: 25),
            const Text(
              'Health & Medical Support',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Varshney Vaishy Samaj (VVS) Health Care initiative is dedicated to ensuring the well-being of our community members. '
                  'We believe that a healthy community is a strong community.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 24),
            const Text(
              'Services We Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Blood donation assistance and urgent requirements\n'
                  '• Connecting with verified doctors and hospitals\n'
                  '• Health awareness programs and webinars\n'
                  '• Emergency contact coordination\n'
                  '• Support for medical aid and treatment information',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: _showAddOptions,
          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          label: const Text(
            "Add Organization",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6F00),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
