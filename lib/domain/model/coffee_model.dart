import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class CoffeeModel extends Equatable {
  final String file;
  final String? localPath;
  final Uint8List? bytes;

  const CoffeeModel({required this.file, this.localPath, this.bytes});

  factory CoffeeModel.fromJson(Map<String, dynamic> json) =>
      CoffeeModel(file: json["file"], localPath: null, bytes: json["bytes"]);

  Map<String, dynamic> toJson() => {
    "file": file,
    "localPath": localPath,
    "bytes": bytes,
  };

  CoffeeModel copyWith({String? file, String? localPath, Uint8List? bytes}) {
    return CoffeeModel(
      file: file ?? this.file,
      localPath: localPath ?? this.localPath,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  List<Object?> get props => [file, localPath, bytes];
}
