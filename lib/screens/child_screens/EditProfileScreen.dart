import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/ui_components.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController(),
      _mobileC = TextEditingController(),
      _addressC = TextEditingController(),
      _bgC = TextEditingController(),
      _samajC = TextEditingController();

  File? _imageFile;
  bool _loading = false;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final d = doc.data();
    if (d != null) {
      _nameC.text = d['name'] ?? '';
      _mobileC.text = d['mobile'] ?? '';
      _addressC.text = d['address'] ?? '';
      _bgC.text = d['bloodGroup'] ?? '';
      _samajC.text = d['samaj'] ?? '';
      setState(() {
        _photoUrl = d['photoUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (_imageFile == null) return _photoUrl;
    try {
      final ref = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      final snapshot = await ref.putFile(_imageFile!);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final imageUrl = await _uploadProfileImage(user.uid);
    final updates = {
      'name': _nameC.text.trim(),
      'mobile': _mobileC.text.trim(),
      'address': _addressC.text.trim(),
      'bloodGroup': _bgC.text.trim(),
      'samaj': _samajC.text.trim(),
      if (imageUrl != null) 'photoUrl': imageUrl,
    };

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updates);

    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _mobileC.dispose();
    _addressC.dispose();
    _bgC.dispose();
    _samajC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : null) as ImageProvider<Object>?,
                  child: (_imageFile == null && _photoUrl == null)
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _nameC,
                label: 'Name',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _mobileC,
                label: 'Mobile',
                keyboardType: TextInputType.phone,
                validator: (v) => v != null && v.length == 10 ? null : 'Invalid number',
              ),
              const SizedBox(height: 12),
              AppInput(controller: _addressC, label: 'Address'),
              const SizedBox(height: 12),
              AppInput(controller: _bgC, label: 'Blood Group'),
              const SizedBox(height: 12),
              AppInput(controller: _samajC, label: 'Samaj'),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : AppButton(text: 'SAVE', onPressed: _saveProfile),
            ],
          ),
        ),
      ),
    );
  }
}
