import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdftools/features/scan/domain/scan_state.dart';

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  return ScanNotifier();
});

class ScanNotifier extends StateNotifier<ScanState> {
  ScanNotifier() : super(ScanInitial());

  Future<void> scan() async {
    state = ScanLoading();
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Fallback for desktop since flutter_doc_scanner is mobile-only
        final res = await FilePicker.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );
        if (res == null || res.files.isEmpty) {
          state = ScanInitial();
          return;
        }
        final pages = res.files.map((f) => File(f.path!).readAsBytesSync()).toList();
        state = ScanReady(pages);
        return;
      }

      final scanner = FlutterDocScanner();
      final result = await scanner.getScannedDocumentAsImages();
      if (result == null) {
        state = ScanInitial();
        return;
      }
      final pages = (result as List)
          .map((path) => File(path.toString()).readAsBytesSync())
          .toList();
      state = ScanReady(pages);
    } catch (e) {
      state = ScanError(e.toString());
    }
  }

  Future<void> exportPdf(List<Uint8List> pages) async {
    state = ScanLoading();
    try {
      final pdf = pw.Document();
      for (final bytes in pages) {
        final image = pw.MemoryImage(bytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (_) => pw.Center(child: pw.Image(image)),
          ),
        );
      }
      
      final pdfBytes = await pdf.save();
      
      // Select where to save the file
      final String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save PDF Document',
        fileName: 'scanned_document.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsBytes(pdfBytes);
        // Optionally show success, but for now we just return to ready state
      }
      
      state = ScanReady(pages);
    } catch (e) {
      state = ScanError(e.toString());
    }
  }
}
