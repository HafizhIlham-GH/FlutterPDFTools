import 'package:flutter/material.dart';
import 'package:pdftools/features/scan/presentation/scan_page.dart';

// Routes import
import '../features/home/presentation/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AppShell());
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _screens = [
    const HomePage(),
    SizedBox(),
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScanPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Test'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Test'),
        ],
      ),
    );
  }
}
