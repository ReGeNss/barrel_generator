import 'dart:io';
import 'dart:typed_data';

import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/generator_repository.dart';

class GeneratorRepositoryImpl implements GeneratorRepository {
  @override
  Future<bool> exists(FsEntity path) async {
    if (path is FsFile) {
      return await File(path.path).exists();
    }
    return await Directory(path.path).exists();
  }

  @override
  Future<Uint8List> read(FsFile path) async {
    return await File(path.path).readAsBytes();
  }

  @override
  Future<void> appendToFile(FsFile path, Uint8List data) async {
    await File(path.path).writeAsBytes(data, mode: .writeOnlyAppend);
  }

  @override
  Future<List<String>> readAsLines(FsFile path) async {
    return await File(path.path).readAsLines();
  }

  @override
  Future<void> write(FsFile path, Uint8List data) async {
    await File(path.path).writeAsBytes(data);
  }

  @override
  Future<void> create(FsFile path) async {
    await File(path.path).create();
  }

  @override
  Future<Set<FsEntity>> listFolderEntry(Folder path) async {
    final entry = await Directory(path.path).list().toSet();

    return entry
        .map((e) => e is Directory ? Folder(e.path) : FsFile(e.path))
        .toSet();
  }
  
  @override
  Future<void> renameFile(FsFile file, FsFile newFile) async {
    await File(file.path).rename(newFile.path);
  }
}
