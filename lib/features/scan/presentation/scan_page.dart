import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdftools/features/scan/domain/scan_state.dart';
import 'package:pdftools/features/scan/domain/scan_notifier.dart';
import 'package:pdftools/app/app.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: switch (state) {
        ScanInitial() => _buildInitialView(context, ref),
        ScanLoading() => const Center(child: CircularProgressIndicator(color: Color(0xFF64FFDA))),
        ScanReady() => _buildReadyView(ref, state),
        ScanError() => Center(child: Text(state.message, style: const TextStyle(color: Colors.white))),
      },
    );
  }

  Widget _buildInitialView(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Simulated Camera Feed & Paper
        Positioned.fill(
          child: Container(
            color: const Color(0xFF1E1E1E), // Dark background simulating camera feed
            child: Center(
              child: Transform.rotate(
                angle: -0.15,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // App Bar Overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AppShell()),
                        );
                      }
                    },
                  ),
                  Column(
                    children: [
                      const Text(
                        'Auto Scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF64FFDA),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),

        // Scanner Frame Overlay
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // The frame
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: CustomPaint(
                            painter: ScannerFramePainter(),
                          ),
                        ),
                        // Toast message
                        Positioned(
                          bottom: 60,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Text(
                              'Hold steady, detecting document...',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Controls
                Container(
                  padding: const EdgeInsets.only(bottom: 24, top: 16),
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Capture Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconButton(Icons.flash_off, 'Flash'),
                          // Capture Button
                          GestureDetector(
                            onTap: () => ref.read(scanProvider.notifier).scan(),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: Center(
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildIconButton(Icons.photo_library, 'Gallery'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTab('DOCUMENT', isSelected: true),
                          _buildTab('ID CARD', isSelected: false),
                          _buildTab('QR CODE', isSelected: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTab(String label, {required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF64FFDA) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        if (isSelected)
          Container(
            height: 2,
            width: 60,
            color: const Color(0xFF64FFDA),
          ),
      ],
    );
  }

  Widget _buildReadyView(WidgetRef ref, ScanReady state) {
    return Column(
      children: [
        AppBar(
          title: const Text('Scanned Pages', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF00685F),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.pages.length,
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(state.pages[i], fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () => ref.read(scanProvider.notifier).scan(),
                child: const Text('Scan More'),
              ),
              ElevatedButton(
                onPressed: () => ref.read(scanProvider.notifier).exportPdf(state.pages),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00685F)),
                child: const Text('Export PDF', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64FFDA)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const double cornerLength = 40.0;
    const double radius = 16.0;

    // Top left
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, radius)
        ..quadraticBezierTo(0, 0, radius, 0)
        ..lineTo(cornerLength, 0),
      paint,
    );

    // Top right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - radius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, radius)
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Bottom left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - radius)
        ..quadraticBezierTo(0, size.height, radius, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Bottom right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width - radius, size.height)
        ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
