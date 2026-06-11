import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdftools/features/edit/domain/edit_state.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

final editProvider = StateNotifierProvider<EditNotifier, EditState>((ref) {
  return EditNotifier();
});

class EditNotifier extends StateNotifier<EditState> {
  EditNotifier() : super(EditInitial());

  Future<void> pickPdf({List<Uint8List>? existingPages}) async {
    state = EditLoading();
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null) {
      if (existingPages != null && existingPages.isNotEmpty) {
        state = EditReady(pages: existingPages, originalBytes: Uint8List(0));
      } else {
        state = EditInitial();
      }
      return;
    }

    final bytes = result.files.first.bytes!;
    final doc = await pdfx.PdfDocument.openData(bytes);
    final List<Uint8List> pages = existingPages != null ? List.from(existingPages) : [];

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);
      final pageImage = await page.render(
        width: page.width * 0.5,
        height: page.height * 0.5,
      );
      pages.add(pageImage!.bytes);
      page.close();
    }

    state = EditReady(pages: pages, originalBytes: bytes);
  }

  Future<void> exportPdf(List<Uint8List> pages) async {
    state = EditLoading();
    final pdf = pw.Document();
    for (final pageBytes in pages) {
      final image = pw.MemoryImage(pageBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Center(child: pw.Image(image)),
        ),
      );
    }
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
    state = EditDone();
  }
}
