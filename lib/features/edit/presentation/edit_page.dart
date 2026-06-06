import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdftools/features/edit/domain/edit_state.dart';
import 'package:pdftools/features/edit/domain/edit_notifier.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key});
  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  List<Uint8List> _pages = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProvider);

    if (state is EditReady && _pages.isEmpty) {
      _pages = List.from(state.pages);
    }

    return Scaffold(
      body: switch (state) {
        EditInitial() => Center(
          child: ElevatedButton(
            onPressed: () => ref.read(editProvider.notifier).pickPdf(),
            child: Text('Pick PDF'),
          ),
        ),
        EditLoading() => Center(child: CircularProgressIndicator()),
        EditReady() => Column(
          children: [
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _pages.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final page = _pages.removeAt(oldIndex);
                    _pages.insert(newIndex, page);
                  });
                },
                itemBuilder: (_, i) => Container(
                  key: ValueKey(i),
                  margin: EdgeInsets.all(8),
                  child: Image.memory(_pages[i], height: 200),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  ref.read(editProvider.notifier).exportPdf(_pages),
              child: Text('Export PDF'),
            ),
          ],
        ),
        EditDone() => Center(
          child: ElevatedButton(
            onPressed: () => ref.read(editProvider.notifier).pickPdf(),
            child: Text('Pick Another'),
          ),
        ),
      },
    );
  }
}
