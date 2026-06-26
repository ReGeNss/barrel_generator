import 'dart:typed_data';

import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/generator_repository.dart';
import 'package:injectable_generator/utils.dart';

import '../entity/fs_entity.dart';

class InMemoryGeneratorRepository extends GeneratorRepository {
  final MFolder root;
  final Map<String, Uint8List> _files = {};

  InMemoryGeneratorRepository({required Map<String, dynamic> tree})
    : root = MFolder.generate(tree);

  String contentsOf(String path) =>
      String.fromCharCodes(_files[path] ?? Uint8List(0));

  @override
  Future<bool> exists(FsEntity path) async {
    return _get(path) != null;
  }

  bool existsByString(String path) {
    return _files.containsKey(path);
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
    _files.putIfAbsent(path.path, () => Uint8List(0));
  }

  @override
  Future<Uint8List> read(FsFile path) async {
    return _files[path.path] ?? Uint8List(0);
  }

  @override
  Future<void> write(FsFile path, Uint8List data) async {
    _files[path.path] = data;
  }

  @override
  Future<void> appendToFile(FsFile path, Uint8List data) async {
    final existing = _files[path.path] ?? Uint8List(0);
    _files[path.path] = Uint8List.fromList([...existing, ...data]);
  }

  @override
  Future<List<String>> readAsLines(FsFile path) async {
    final content = _files[path.path];
    if (content == null) {
      return [];
    }
    return String.fromCharCodes(
      content,
    ).split('\n').where((line) => line.isNotEmpty).toList();
  }

  @override
  Future<Set<FsEntity>> listFolderEntry(Folder path) async {
    return (_get(path) as MFolder).entries
        .map((e) => FsEntity.fromPath(e.path))
        .toSet();
  }

  @override
  Future<void> renameFile(FsFile file, FsFile newFile) async {
    final content = _files.remove(file.path);
    if (content != null) {
      _files[newFile.path] = content;
    }
  }
}
