import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdftools/features/convert/domain/convert_notifier.dart';
import 'package:pdftools/features/convert/domain/convert_state.dart';

class ConvertPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(convertProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Convert to PDF'),
      ),
      body: switch (state) {
        ConvertInitial() => Center(
          child: ElevatedButton(
            onPressed: () => ref.read(convertProvider.notifier).pickFiles(),
            child: Text('Pick files'),
          ),
        ),
        ConvertReady() => Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: state.files.length,
                itemBuilder: (_, i) => Image.memory(state.files[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(convertProvider.notifier).pickFiles(),
                  child: Text('Pick More Images'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(convertProvider.notifier).exportPDF(state.files),
                  child: Text('Export PDF'),
                ),
              ],
            ),
          ],
        ),
        ConvertLoading() => Center(child: CircularProgressIndicator()),
        ConvertDone() => Center(
          child: ElevatedButton(
            onPressed: () => ref.read(convertProvider.notifier).pickFiles(),
            child: Text('Pick Image'),
          ),
        ),
      },
    );
  }
}
