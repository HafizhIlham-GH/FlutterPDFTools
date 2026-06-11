import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdftools/features/edit/domain/edit_state.dart';
import 'package:pdftools/features/edit/domain/edit_notifier.dart';
import 'package:pdftools/app/app.dart';
import 'package:pdftools/app/widgets/pdf_tools_app_bar.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key});
  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  List<Uint8List> _pages = [];

  @override
  Widget build(BuildContext context) {
    ref.listen<EditState>(editProvider, (previous, next) {
      if (next is EditReady && (previous is EditLoading || previous is EditInitial)) {
        setState(() {
          _pages = List.from(next.pages);
        });
      } else if (next is EditInitial) {
        setState(() {
          _pages.clear();
        });
      }
    });

    final state = ref.watch(editProvider);
    const primaryGreen = Color(0xFF00685F);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PdfToolsAppBar(),
      body: switch (state) {
        EditInitial() => _buildInitialView(ref, primaryGreen),
        EditLoading() => const Center(child: CircularProgressIndicator(color: primaryGreen)),
        EditReady() => _buildReadyView(ref, primaryGreen),
        EditDone() => _buildDoneView(ref, primaryGreen),
      },
    );
  }

  Widget _buildInitialView(WidgetRef ref, Color primaryGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomPaint(
          painter: _DashedRectPainter(
            color: Colors.grey.shade500,
            strokeWidth: 1.0,
            gap: 5.0,
            radius: 8.0,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_outlined,
                    color: primaryGreen,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select PDF',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih file PDF yang ingin Anda edit halamannya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => ref.read(editProvider.notifier).pickPdf(),
                  icon: const Icon(Icons.upload_file, color: Colors.white, size: 20),
                  label: const Text(
                    'Choose File',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadyView(WidgetRef ref, Color primaryGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Edit Pages',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            'Reorder or remove page from file',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return DragTarget<int>(
                onWillAcceptWithDetails: (details) => details.data != index,
                onAcceptWithDetails: (details) {
                  setState(() {
                    final fromIndex = details.data;
                    final item = _pages.removeAt(fromIndex);
                    _pages.insert(index, item);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  final width = MediaQuery.of(context).size.width / 2 - 24;
                  final height = width / 0.75;
                  
                  return Draggable<int>(
                    data: index,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.8,
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: _buildCard(_pages[index], index + 1),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildCard(_pages[index], index + 1),
                    ),
                    child: _buildCard(_pages[index], index + 1),
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  ref.read(editProvider.notifier).pickPdf(existingPages: _pages);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryGreen,
                  side: BorderSide(color: primaryGreen),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Pick Another'),
              ),
              ElevatedButton(
                onPressed: () => ref.read(editProvider.notifier).exportPdf(_pages),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Export PDF', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Uint8List imageBytes, int pageNumber) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.memory(imageBytes, fit: BoxFit.cover),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Text(
              'Page $pageNumber',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneView(WidgetRef ref, Color primaryGreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text(
            'PDF Exported Successfully!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _pages.clear());
              ref.read(editProvider.notifier).pickPdf();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Edit Another', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  _DashedRectPainter({
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
