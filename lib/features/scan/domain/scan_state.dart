import 'dart:typed_data';

sealed class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanReady extends ScanState {
  final List<Uint8List> pages;
  ScanReady(this.pages);
}

class ScanError extends ScanState {
  final String message;
  ScanError(this.message);
}
