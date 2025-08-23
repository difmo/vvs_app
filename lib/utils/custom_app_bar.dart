import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/ui_components.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onProfileTap,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AppTitle(title,color: Colors.white,size: 18,),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Image.asset('assets/logo.png', width: 32, height: 32),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
