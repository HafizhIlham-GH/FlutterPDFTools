import 'dart:ui';
import 'package:flutter/material.dart';
import '../../convert/presentation/convert_page.dart';
import '../../edit/presentation/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D826B);
    const bgGray = Color(0xFFF8F9FA);
    const textDark = Color(0xFF1E293B);
    const textLight = Color(0xFF64748B);
    const borderGray = Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgGray,
      appBar: AppBar(
        backgroundColor: bgGray,
        elevation: 0,
        titleSpacing: 0,
        leading: const Icon(Icons.description, color: primaryGreen),
        title: const Text(
          'DocPro PDF',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Good morning,',
              style: TextStyle(
                color: textDark,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'What would you like to do with your PDFs\ntoday?',
              style: TextStyle(
                color: textLight,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Actions Cards
            SizedBox(
              height: 280,
              child: Row(
                children: [
                  // Left Big Card
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ConvertPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51), // 0.2 * 255 = ~51
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.image, color: Colors.white, size: 28),
                            ),
                            const Spacer(),
                            const Text(
                              'Image to PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Convert photos\ninto clean,\nprofessional\ndocuments\ninstantly.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right Small Cards
                  Expanded(
                    child: Column(
                      children: [
                        // Scan Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Action for Scan Document
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderGray),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.document_scanner_outlined, color: primaryGreen, size: 28),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Scan Document',
                                    style: TextStyle(
                                      color: textDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'High-res optical\nscanning',
                                    style: TextStyle(
                                      color: textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Edit Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EditPage()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderGray),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.edit_document, color: primaryGreen, size: 28),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Edit Pages',
                                    style: TextStyle(
                                      color: textDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Merge, split, or reorder',
                                    style: TextStyle(
                                      color: textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Recent Files Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Files',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: textDark),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of files
            _buildFileItem(
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              title: 'Quarterly_Report_Q3.pdf',
              subtitle: 'Oct 24, 2023 • 2.4 MB',
            ),
            const SizedBox(height: 12),
            _buildFileItem(
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              title: 'Signed_Contract_v2.pdf',
              subtitle: 'Yesterday • 850 KB',
            ),
            const SizedBox(height: 12),
            _buildFileItem(
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              title: 'ID_Card_Front_...',
              subtitle: '2 days ago • 1.2 MB',
              isLocked: true,
            ),
            const SizedBox(height: 24),

            // Upload More Files Button (Dashed)
            CustomPaint(
              painter: DashedRectPainter(
                color: borderGray,
                strokeWidth: 1.5,
                gap: 6.0,
                radius: 12.0,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF94A3B8), width: 2),
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF94A3B8), size: 24),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tap the '+' button to upload more files",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),

    );
  }

  Widget _buildFileItem({
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isLocked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.picture_as_pdf, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (isLocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'LOCKED',
                style: TextStyle(
                  color: Color(0xFF4338CA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }


}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    double dashWidth = gap;
    double dashSpace = gap;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashPath, dashedPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
