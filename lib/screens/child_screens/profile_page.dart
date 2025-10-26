import 'package:flutter/material.dart';
import 'package:vvs_app/screens/child_screens/EditProfileScreen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        ),

      backgroundColor: Color(0xFFFFF3E0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Picture with edit icon
              Stack(
                children: [
                  CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/300?img=47'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: size.width * 0.045,
                      backgroundColor: Color(0xFFFF8F00),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Name
              const Text(
                'Sabrina Aryan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Email
              const Text(
                'SabrinaAry208@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              // Edit Profile Button
              SizedBox(
                width: size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6F00),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(height: 30),
              // First Section
              _buildOption(Icons.favorite_border, 'Favourites', () {}),
              _buildOption(Icons.download_outlined, 'Downloads', () {}),
              const Divider(height: 30, thickness: 1),
              // Second Section
              _buildOption(Icons.language_outlined, 'Languages', () {}),
              _buildOption(Icons.location_on_outlined, 'Location', () {}),
              _buildOption(Icons.video_library_outlined, 'Subscription', () {}),
              _buildOption(Icons.desktop_mac_outlined, 'Display', () {}),
              const Divider(height: 30, thickness: 1),
              // Third Section
              _buildOption(Icons.delete_outline, 'Clear Cache', () {}),
              _buildOption(Icons.access_time_outlined, 'Clear History', () {}),
              _buildOption(Icons.logout, 'Log Out', () {}),
              const SizedBox(height: 30),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
