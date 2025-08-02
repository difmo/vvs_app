import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/ui_components.dart';

class CustomDrawer extends StatelessWidget {
  final Map<String, Widget> screenMap;
  final void Function(Widget) onTap;

  const CustomDrawer({super.key, required this.screenMap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    AppLabel('John Varshney', color: Colors.white),
                    SizedBox(height: 4),
                    AppSubTitle('john.vvs@example.com', color: Colors.white70),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: screenMap.length,
              itemBuilder: (context, index) {
                final title = screenMap.keys.elementAt(index);
                final screen = screenMap.values.elementAt(index);
                return ListTile(
                  leading: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                  ),
                  title: AppLabel(title),
                  onTap: () => onTap(screen),
                );
              },
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 0.5,
                color: AppColors.border,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: AppSubTitle(
              'Powered by V.V. Samaj',
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
