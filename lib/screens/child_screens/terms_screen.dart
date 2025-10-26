import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final double horizontalPadding = width * 0.06;
    final double fontScale = width / 390;
    final double sectionSpacing = height * 0.025;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
        ),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: height * 0.02,
          ),
          child: Container(
            padding: EdgeInsets.all(18 * fontScale),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12 * fontScale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Welcome to Varshney Vikas Sangathan', fontScale),
                _buildSectionText(
                  'These Terms and Conditions outline the rules and regulations for the use of the Varshney Vikas Sangathan mobile application. '
                      'By accessing or using this app, you agree to comply with and be bound by these terms.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('1. Acceptance of Terms', fontScale),
                _buildSectionText(
                  'By using the Varshney Vikas Sangathan app, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions. '
                      'If you do not agree, please refrain from using the application.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('2. Purpose of the App', fontScale),
                _buildSectionText(
                  'The app is designed to connect members of the Varshney community, provide access to organizational updates, events, and initiatives, '
                      'and promote welfare, unity, and social support.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('3. User Responsibilities', fontScale),
                _buildSectionText(
                  'Users are responsible for maintaining the confidentiality of their login credentials. Any activity performed under your account '
                      'will be considered as your responsibility. Do not share sensitive or misleading information within the app.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('4. Privacy Policy', fontScale),
                _buildSectionText(
                  'We value your privacy. The information you share is used only for improving the community experience and will not be shared with third parties '
                      'without your consent. Refer to our Privacy Policy for more details.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('5. Limitation of Liability', fontScale),
                _buildSectionText(
                  'Varshney Vikas Sangathan shall not be held responsible for any direct or indirect damages arising from the use or inability to use the app, '
                      'including but not limited to data loss or unauthorized access.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('6. Modifications to Terms', fontScale),
                _buildSectionText(
                  'We reserve the right to modify or replace these Terms & Conditions at any time. Changes will be communicated through the app or official communication channels.',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing),

                _buildSectionTitle('7. Contact Us', fontScale),
                _buildSectionText(
                  'If you have any questions or concerns about these Terms & Conditions, please contact us at:\n\n'
                      '📧 support@vvs.org\n🌐 www.varshneyvikassangathan.org',
                  fontScale,
                ),

                SizedBox(height: sectionSpacing * 1.5),
                Center(
                  child: Text(
                    '© 2025 Varshney Vikas Sangathan. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13 * fontScale,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double fontScale) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18 * fontScale,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFF6F00),
      ),
    );
  }

  Widget _buildSectionText(String text, double fontScale) {
    return Padding(
      padding: EdgeInsets.only(top: 6 * fontScale),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.5 * fontScale,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}

