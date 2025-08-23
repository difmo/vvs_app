import 'package:flutter/material.dart';
import 'package:vvs_app/screens/home_screen.dart';
import 'package:vvs_app/screens/profile_screen.dart';
import 'package:vvs_app/screens/child_screens/news_bulletin_screen.dart';
import 'package:vvs_app/screens/child_screens/matrimonial_screen.dart';
import 'package:vvs_app/screens/child_screens/marketplace_screen.dart';
import 'package:vvs_app/screens/child_screens/family_registration_screen.dart';
import 'package:vvs_app/screens/child_screens/directory_screen.dart';
import 'package:vvs_app/screens/child_screens/blood_group_screen.dart';
import 'package:vvs_app/screens/child_screens/healthcare_screen.dart';
import 'package:vvs_app/screens/child_screens/education_screen.dart';
import 'package:vvs_app/screens/child_screens/group_chat_screen.dart';
import 'package:vvs_app/screens/child_screens/events_screen.dart';
import 'package:vvs_app/screens/child_screens/offers_screen.dart';
import 'package:vvs_app/screens/child_screens/payment_screen.dart';
import 'package:vvs_app/screens/child_screens/contact_us_screen.dart';
import 'package:vvs_app/screens/child_screens/about_us_screen.dart';
import 'package:vvs_app/screens/child_screens/terms_screen.dart';
import 'package:vvs_app/utils/custom_app_bar.dart';
import 'package:vvs_app/utils/custom_bottom_nav.dart';
import 'package:vvs_app/utils/custom_drawer.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Widget> _bottomScreens = [
    const HomeScreen(),
    const NewsBulletinScreen(),
    const MatrimonialScreen(),
    const MarketPlaceScreen(),
    const ProfileScreen(),
  ];

  final List<String> _bottomTitles = [
    'Home',
    'News Bulletin',
    'Matrimonial',
    'Marketplace',
    'Profile',
  ];

  int _selectedIndex = 0;

  final Map<String, Widget> drawerScreenMap = {
    'About Us': const AboutUsScreen(),
    'Family Registration': const FamilyRegistrationScreen(),
    'Directory Who\'s & Who': const DirectoryScreen(),
    'Blood Group & Donors': const BloodDonorsScreen(),
    'Health Care': const HealthCareScreen(),
    'Education': const EducationScreen(),
    'Group Chat': const GroupChatScreen(),
    'Upcoming Events': const EventsScreen(),
    'Offers & Discounts': const OffersScreen(),
    'Payment Gateway': const PaymentScreen(),
    'Contact Us': const ContactUsScreen(),
    'Terms & Conditions': const TermsScreen(),
  };

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onDrawerTap(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:_selectedIndex==0?"VVS": _bottomTitles[_selectedIndex]),
      drawer: CustomDrawer(screenMap: drawerScreenMap, onTap: _onDrawerTap),
      body: _bottomScreens[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
