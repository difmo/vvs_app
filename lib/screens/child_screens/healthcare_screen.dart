import 'package:flutter/material.dart';

class HealthCareScreen extends StatelessWidget {
  const HealthCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Care')),
      body: const Center(child: Text('Health Care Page')),
    );
  }
}
