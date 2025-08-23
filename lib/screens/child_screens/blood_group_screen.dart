// lib/screens/blood_group_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/app_dropdown.dart';

class BloodDonorsScreen extends StatefulWidget {
  const BloodDonorsScreen({super.key});

  @override
  State<BloodDonorsScreen> createState() => _BloodDonorsScreenState();
}

class _BloodDonorsScreenState extends State<BloodDonorsScreen> {
  String? _selectedGroup;
  final List<String> _bloodGroups = [
    'A+',
    'A−',
    'B+',
    'B−',
    'AB+',
    'AB−',
    'O+',
    'O−',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Blood Group & Donors')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppDropdown(
              label: 'Filter by Blood Group',
              items: _bloodGroups,
              value: _selectedGroup,
              onChanged: (val) => setState(() => _selectedGroup = val),
              validator: (_) => null,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('donors')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, snap) {
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs.where((doc) {
                  if (_selectedGroup == null) return true;
                  return doc['bloodGroup'] == _selectedGroup;
                }).toList();

                if (docs.isEmpty)
                  return const Center(child: Text('No donors found'));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final d = docs[i];
                    return ListTile(
                      title: Text(d['name']),
                      subtitle: Text(
                        'Blood: ${d['bloodGroup']} • Mobile: ${d['mobile']}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
