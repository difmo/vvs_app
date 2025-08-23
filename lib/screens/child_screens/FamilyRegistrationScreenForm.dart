import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/app_dropdown.dart';
import 'package:vvs_app/widgets/ui_components.dart';

class FamilyRegistrationScreenForm extends StatefulWidget {
  const FamilyRegistrationScreenForm({super.key});

  @override
  State<FamilyRegistrationScreenForm> createState() =>
      _FamilyRegistrationScreenFormState();
}

class _FamilyRegistrationScreenFormState
    extends State<FamilyRegistrationScreenForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _professionController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _aadhaarNumberController = TextEditingController();

  String? _selectedGender;
  String? _selectedMaritalStatus;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Widowed',
    'Divorced',
  ];

  bool _loading = false;
  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    await FirebaseFirestore.instance.collection('family_members').add({
      'name': _nameController.text.trim(),
      'relation': _relationController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'dob': _dobController.text.trim(),
      'gender': _selectedGender,
      'maritalStatus': _selectedMaritalStatus,
      'occupation': _occupationController.text.trim(),
      'qualification': _qualificationController.text.trim(),
      'profession': _professionController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'address': _addressController.text.trim(),
      'bloodGroup': _bloodGroupController.text.trim(),
      'aadhaarNumber': _aadhaarNumberController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': FirebaseAuth.instance.currentUser?.uid,
    });

    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Member saved')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _qualificationController.dispose();
    _professionController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _bloodGroupController.dispose();
    _aadhaarNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Family Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const AppTitle('Register a Family Member'),
              const SizedBox(height: 16),
              AppInput(
                controller: _nameController,
                label: 'Full Name',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _relationController,
                label: 'Relation',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _dobController,
                label: 'Date of Birth (dd/mm/yyyy)',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _ageController,
                label: 'Age',
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid age'
                    : null,
              ),
              const SizedBox(height: 12),
              AppDropdown(
                label: 'Gender',
                items: _genderOptions,
                value: _selectedGender,
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppDropdown(
                label: 'Marital Status',
                items: _maritalStatusOptions,
                value: _selectedMaritalStatus,
                onChanged: (val) =>
                    setState(() => _selectedMaritalStatus = val),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _occupationController,
                label: 'Occupation',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _qualificationController,
                label: 'Qualification',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _professionController,
                label: 'Profession',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Enter valid email',
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _mobileController,
                label: 'Mobile',
                keyboardType: TextInputType.phone,
                validator: (v) => v != null && v.length == 10
                    ? null
                    : 'Enter valid mobile number',
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _addressController,
                label: 'Address',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _bloodGroupController,
                label: 'Blood Group',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                controller: _aadhaarNumberController,
                label: 'Aadhaar Number',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : AppButton(text: 'SAVE', onPressed: _saveMember),
            ],
          ),
        ),
      ),
    );
  }
}
