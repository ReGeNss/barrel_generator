import 'dart:typed_data';

import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/generator_repository.dart';
import 'package:injectable_generator/utils.dart';

import '../entity/fs_entity.dart';

class InMemoryGeneratorRepository extends GeneratorRepository {
  final MFolder root;

  InMemoryGeneratorRepository({required Map<String, dynamic> tree})
    : root = MFolder.generate(tree);

  List<String> contentsOf(String path) {
    final file = (_get(FsEntity.fromPath(path)) as MFile?);
    
    return (file?.content ?? '').split('\n');
  } 

  @override
  Future<bool> exists(FsEntity path) async {
    return _get(path) != null;
  }

  bool existsByString(String path) {
    return _get(FsEntity.fromPath(path)) != null;
  }

  MFsEntity? _get(FsEntity path) {
    MFolder curFolder = MFolder('/', '/', entries: [root]);

    for (final route in path.path.split('/')) {
      final res = curFolder.entries.firstWhereOrNull((e) => e.route == route);

      if (res == null) {
        return null;
      }

      if (res is MFile) {
        if (path.nameWithType == res.route) {
          return res;
        }
        return null;
      }

      curFolder = res as MFolder;
    }
    return curFolder;
  }

  @override
  Future<void> create(FsFile path) async {
    final f = _get(path.parentFolder!) as MFolder;
  
    f.entries.add(MFile(path.nameWithType, path.path));
  }

  @override
  Future<Uint8List> read(FsFile path) async {
    return Uint8List.fromList((_get(path) as MFile).content.codeUnits);
  }

  @override
  Future<void> write(FsFile path, Uint8List data) async {
    final e = _get(path) as MFile;
    e.content = String.fromCharCodes(data);
  }

  @override
  Future<void> appendToFile(FsFile path, Uint8List data) async {
    final existing = _get(path) as MFile;
    existing.content += String.fromCharCodes(data);
  }

  @override
  Future<List<String>> readAsLines(FsFile path) async {
    final file = _get(path) as MFile?;
    if (file == null) {
      return [];
    }
    return file.content.split('\n').toList();
  }

  @override
  Future<Set<FsEntity>> listFolderEntry(Folder path) async {
    return (_get(path) as MFolder).entries
        .map((e) => FsEntity.fromPath(e.path))
        .toSet();
  }

  @override
  Future<void> renameFile(FsFile file, FsFile newFile) async {
    final folder = _get(file.parentFolder!) as MFolder;
    
    final e = folder.entries.firstWhere((test) => test.path == file.path) as MFile;

    folder.entries.remove(e);

    folder.entries.add(MFile(newFile.nameWithType, newFile.path, content: e.content));
  }
}
