import 'package:flutter/material.dart';
import 'package:vvs_app/constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../widgets/ui_components.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  bool _acceptedTerms = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Terms & Conditions to proceed.'),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    final error = await _auth.login(
      email: _loginIdController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() => _loading = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot Password feature is not implemented yet.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', width: 164, height: 164),
                const SizedBox(height: 24),
                const AppTitle('VVS'),
                const AppTitle('VARSHNEY VIKAS SANGATHAN'),
                const SizedBox(height: 8),
                const AppSubTitle(appTitle),
                const SizedBox(height: 24),
                AppInput(
                  controller: _loginIdController,
                  label: 'EMAIL ID / MOBILE NUMBER',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter Login ID'
                      : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter Password'
                      : null,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() => _acceptedTerms = value ?? false);
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: 'I accept '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  launchUrlString(
                                    'https://www.vvs.com/terms-conditions',
                                  );
                                },
                                child: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  launchUrlString(
                                    'https://www.vvs.com/privacy-policy',
                                  );
                                },
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' of VVS app'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _loading
                    ? const CircularProgressIndicator()
                    : AppButton(
                        text: 'LOGIN',
                        onPressed: _acceptedTerms
                            ? _login
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please accept Terms & Conditions to proceed.',
                                    ),
                                  ),
                                );
                              },
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLabel('New User?'),
                    AppTextButton(
                      text: 'CREATE NEW ACCOUNT',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void launchUrlString(String s) {
    // launchUrl(Uri.parse(s));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('We are working on that feature!')),
    );
  }
}
