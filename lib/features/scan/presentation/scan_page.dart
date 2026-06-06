import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdftools/features/scan/domain/scan_state.dart';
import 'package:pdftools/features/scan/domain/scan_notifier.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanProvider);

    return Scaffold(
      body: switch (state) {
        ScanInitial() => Center(
          child: ElevatedButton(
            onPressed: () => ref.read(scanProvider.notifier).scan(),
            child: Text('Scan Document'),
          ),
        ),
        ScanLoading() => Center(child: CircularProgressIndicator()),
        ScanReady() => Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: state.pages.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.memory(state.pages[i]),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  ref.read(scanProvider.notifier).exportPdf(state.pages),
              child: Text('Export PDF'),
            ),
          ],
        ),
        ScanError() => Center(child: Text(state.message)),
      },
    );
  }
}
