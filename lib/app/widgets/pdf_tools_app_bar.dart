import 'package:flutter/material.dart';

class PdfToolsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PdfToolsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF00685F);
    const bgGray = Color(0xFFF8F9FA);
    
    return AppBar(
      backgroundColor: bgGray,
      elevation: 0,
      titleSpacing: 0,
      leading: const Icon(Icons.description, color: primaryGreen),
      title: const Text(
        'PDF Tools',
        style: TextStyle(
          color: primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
