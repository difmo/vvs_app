import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vvs_app/screens/login_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/ui_components.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final _nameController = TextEditingController();
  final _occupationController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userData = {
      'name': _nameController.text.trim(),
      'occupation': _occupationController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'address': _addressController.text.trim(),
      'bloodGroup': _bloodGroupController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    setState(() => _loading = true);
    final error = await _auth.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      userData: userData,
    );
    setState(() => _loading = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('New User Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const AppTitle('Join the V.V. Samaj Network'),
              const SizedBox(height: 8),
              const AppSubTitle(
                'Connect with Your Samaj. Strengthen Our Roots.',
              ),
              const SizedBox(height: 24),
              AppInput(
                controller: _nameController,
                label: 'Full Name',
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
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Minimum 6 chars',
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : AppButton(text: 'SUBMIT', onPressed: _submit),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLabel('Already have an account?'),
                  AppTextButton(
                    text: 'SIGN IN',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
