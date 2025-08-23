import 'package:flutter/material.dart';
import 'package:vvs_app/theme/app_colors.dart';
import 'package:vvs_app/widgets/ui_components.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Directory: Who's & Who")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppTitle("Who's & Who Directory"),
            SizedBox(height: 16),
            Text(
              'The Who’s & Who Directory of the Varshney Vaishy Samaj is a carefully maintained record '
              'of community leaders, professionals, educators, entrepreneurs, and distinguished members '
              'who have made impactful contributions across various fields.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 16),
            AppTitle('Purpose'),
            SizedBox(height: 8),
            Text(
              '• Recognize achievements within the community\n'
              '• Enable professional networking and mentorship\n'
              '• Inspire the next generation of leaders\n'
              '• Connect with influential individuals for community upliftment',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 16),
            AppTitle('Get Featured'),
            SizedBox(height: 8),
            Text(
              'If you or someone you know should be listed, please reach out to the VVS admin team '
              'with details and achievements. Together, we celebrate our people and their contributions.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
