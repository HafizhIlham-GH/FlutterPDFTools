import 'dart:typed_data';

sealed class ConvertState {}

class ConvertInitial extends ConvertState {}

class ConvertReady extends ConvertState {
  final List<Uint8List> files;
  ConvertReady(this.files);
}

class ConvertLoading extends ConvertState {}

class ConvertDone extends ConvertState {}
