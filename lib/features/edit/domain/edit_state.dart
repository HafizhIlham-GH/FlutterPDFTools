import 'dart:typed_data';

sealed class EditState {}

class EditInitial extends EditState {}

class EditLoading extends EditState {}

class EditReady extends EditState {
  final List<Uint8List> pages; // rendered page thumbnails
  final Uint8List originalBytes; // original PDF bytes
  EditReady({required this.pages, required this.originalBytes});
}

class EditDone extends EditState {}
