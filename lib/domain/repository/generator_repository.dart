import 'dart:typed_data';

import 'package:barrel_generator/domain/entity/fs_entity.dart';

abstract class GeneratorRepository {
  Future<bool> exists(FsEntity path);

  Future<Uint8List> read(FsFile path);

  Future<void> appendToFile(FsFile path, Uint8List data);

  Future<List<String>> readAsLines(FsFile path);

  Future<void> write(FsFile path, Uint8List data);

  Future<void> create(FsFile path);

  Future<Set<FsEntity>> listFolderEntry(Folder path);

  Future<void> renameFile(FsFile file, FsFile newFile);
}
