import 'dart:io';
import 'dart:typed_data';

import 'package:barrel_generator/domain/entity/path.dart';
import 'package:barrel_generator/domain/repository/generator_repository.dart';

class GeneratorRepositoryImpl implements GeneratorRepository {
  @override
  Future<bool> exists(Path path) async {
    if (path is FilePath) {
      return await File(path.path).exists();
    }
    return await Directory(path.path).exists();
  }

  @override
  Future<Uint8List> read(FilePath path) async {
    return await File(path.path).readAsBytes();
  }

  @override
  Future<void> appendToFile(FilePath path, Uint8List data) async {
    await File(path.path).writeAsBytes(data, mode: .writeOnlyAppend);
  }

  @override
  Future<List<String>> readAsLines(FilePath path) async {
    return await File(path.path).readAsLines();
  }

  @override
  Future<void> write(FilePath path, Uint8List data) async {
    await File(path.path).writeAsBytes(data);
  }

  @override
  Future<void> create(FilePath path) async {
    await File(path.path).create();
  }

  @override
  Future<Set<Path>> listFolderEntry(FolderPath path) async {
    final entry = await Directory(path.path).list().toSet();

    return entry
        .map((e) => e is Directory ? FolderPath(e.path) : FilePath(e.path))
        .toSet();
  }
}
