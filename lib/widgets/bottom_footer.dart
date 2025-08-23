import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

class BottomFooter extends StatelessWidget {
  const BottomFooter({super.key});

  void _launchUrl(String url) async {
    // final uri = Uri.parse(url);
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri, mode: LaunchMode.externalApplication);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
              onPressed: () => _launchUrl('https://facebook.com/yourpage'),
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.twitter,
                color: Colors.lightBlue,
              ),
              onPressed: () => _launchUrl('https://twitter.com/yourhandle'),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.youtube, color: Colors.red),
              onPressed: () => _launchUrl('https://youtube.com/yourchannel'),
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.instagram,
                color: Colors.purple,
              ),
              onPressed: () => _launchUrl('https://instagram.com/yourprofile'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Powered by Syniso IT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
