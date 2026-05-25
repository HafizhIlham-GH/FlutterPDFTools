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
      allowMultiple: false,
      withData: true,
    );
    if (res == null) return;
    final files = res.files.map((f) => f.bytes!).toList();
    state = ConvertReady(files);
  }

  Future<void> exportPDF(List<Uint8List> files) async {
    state = ConvertLoading();
    final pdf = pw.Document();
    for (final bytes in files) {
      final file = pw.MemoryImage(bytes);
      pdf.addPage(pw.Page(build: (_) => pw.Center(child: pw.Image(file))));
    }
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
    state = ConvertDone();
  }

  void reset() => state = ConvertInitial();
}
