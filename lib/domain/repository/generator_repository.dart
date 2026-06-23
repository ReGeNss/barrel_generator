import 'dart:typed_data';

import 'package:barrel_generator/domain/entity/path.dart';

abstract class GeneratorRepository {
  Future<bool> exists(Path path);

  Future<Uint8List> read(FilePath path);

  Future<void> appendToFile(FilePath path, Uint8List data);

  Future<List<String>> readAsLines(FilePath path);

  Future<void> write(FilePath path, Uint8List data);

  Future<void> create(FilePath path); 
}
