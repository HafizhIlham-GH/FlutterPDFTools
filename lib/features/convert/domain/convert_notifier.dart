import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdftools/features/convert/domain/convert_state.dart';

final convertProvider = StateNotifierProvider<ConvertNotifier, ConvertState>((
  ref,
) {
  return ConvertNotifier();
});

class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier() : super(ConvertInitial());

  Future<void> pickFiles() async {
    final res = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (res == null) return;
    
    // Check if we are already in ConvertReady state to append files, 
    // or just replace them. If we just want to replace, we can do:
    final files = res.files.map((f) => f.bytes!).toList();
    if (state is ConvertReady) {
      final currentFiles = (state as ConvertReady).files;
      state = ConvertReady([...currentFiles, ...files]);
    } else {
      state = ConvertReady(files);
    }
  }

  Future<void> exportPDF(List<Uint8List> files) async {
    state = ConvertLoading();
    final pdf = pw.Document();
    for (final bytes in files) {
      final file = pw.MemoryImage(bytes);
      pdf.addPage(pw.Page(build: (_) => pw.Center(child: pw.Image(file))));
    }
    
    // Instead of printing the PDF, share it so user can save to files
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'converted-file.pdf');
    
    state = ConvertDone();
  }

  void reset() => state = ConvertInitial();
}
