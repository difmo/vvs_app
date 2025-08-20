import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui_components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> _slides = [
    {'title': 'Welcome to V.V.S', 'subtitle': 'संस्कार • एकता • सेवा'},
    {'title': 'Connect. Share. Grow.', 'subtitle': ''},
    {'title': 'Empowering Our Community', 'subtitle': 'Together, we thrive.'},
  ];

  int _currentPage = 0;

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == i ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == i ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Slider
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (ctx, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTitle(_slides[i]['title'] ?? ''),
                    const SizedBox(height: 6),
                    if (_slides[i]['subtitle']!.isNotEmpty)
                      AppSubTitle(_slides[i]['subtitle']!),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildPageIndicator(),
          const SizedBox(height: 24),

          // Stats
          _buildCard(
            title: 'Quick Stats',
            children: const [
              Text('• Total Members: 1,234'),
              Text('• Registered Families: 321'),
              Text('• Blood Donors: 89'),
              Text('• Events Scheduled: 4'),
            ],
          ),

          const SizedBox(height: 24),

          // CTA Highlight
          _buildHighlightCTA(
            title: 'Did You Register Your Family?',
            subtitle: 'Keep your family connected and searchable.',
            buttonText: 'Register Now',
            onPressed: () {},
          ),

          const SizedBox(height: 24),

          // News
          _buildCard(
            title: 'Recent Announcements',
            children: const [
              Text('• Blood Donation Camp – Aug 15, 2025'),
              Text('• Samaj Youth Meet Highlights Uploaded'),
              Text('• Scholarship Applications Open Until Sep 10'),
            ],
          ),

          const SizedBox(height: 24),

          // Highlights
          _buildCard(
            title: 'Community Highlights',
            children: const [
              Text('• Dr. Asha Varshney awarded Padma Shri'),
              Text('• Launch of VVS Matrimonial App'),
              Text('• New Health Insurance Tie-up Announced'),
            ],
          ),

          const SizedBox(height: 24),

          // Explore
          _buildCard(
            title: 'Explore More',
            children: [
              AppOutlinedButton(text: 'Matrimonial', onPressed: () {}),
              const SizedBox(height: 8),
              AppOutlinedButton(text: 'MarketPlace', onPressed: () {}),
              const SizedBox(height: 8),
              AppOutlinedButton(text: 'Offers & Discounts', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [AppLabel(title), const SizedBox(height: 12), ...children],
      ),
    );
  }

  Widget _buildHighlightCTA({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.12),
        border: Border.all(color: AppColors.gold),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(title),
          const SizedBox(height: 6),
          AppSubTitle(subtitle),
          const SizedBox(height: 12),
          AppButton(text: buttonText, onPressed: onPressed),
        ],
      ),
    );
  }
}
