import 'package:flutter/material.dart';
import 'package:pdftools/features/scan/presentation/scan_page.dart';
import 'package:pdftools/features/edit/presentation/edit_page.dart';
import '../features/home/presentation/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _onNavigate(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D826B);

    return Scaffold(
      body: IndexedStack(
        index: _index, 
        children: [
          HomePage(onNavigate: _onNavigate),
          const ScanPage(),
          const EditPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(
                icon: Icons.home_filled,
                label: 'Home',
                isSelected: _index == 0,
                primaryGreen: primaryGreen,
                onTap: () {
                  setState(() => _index = 0);
                },
              ),
              _buildBottomNavItem(
                icon: Icons.document_scanner_outlined,
                label: 'Scan',
                isSelected: _index == 1,
                primaryGreen: primaryGreen,
                onTap: () {
                  setState(() => _index = 1);
                },
              ),
              _buildBottomNavItem(
                icon: Icons.edit_document,
                label: 'Edit',
                isSelected: _index == 2,
                primaryGreen: primaryGreen,
                onTap: () {
                  setState(() => _index = 2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color primaryGreen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
