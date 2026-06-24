import 'dart:typed_data';

import 'package:barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/domain/entity/fs_entity.dart';
import 'dart:collection';

import 'package:barrel_generator/domain/repository/path_to_ignore_repository.dart';

class BarrelGeneratorService {
  final GeneratorRepositoryImpl _repo;
  final PathToIgnoreRepository _ignoreRepo;
  final String _stopFolder;
  final String _fileSeparator;

  static final _newLine = Uint8List.fromList('\n'.codeUnits).first;

  BarrelGeneratorService({
    this._stopFolder = 'lib',
    this._fileSeparator = '/',
    required this._repo,
    required this._ignoreRepo,
  });

  Future<void> createForFile(FsFile path) async {
    final folder = _requireParentFolder(path);
    final barrelFilePath = _createBarrelFilePath(folder);

    if (barrelFilePath.path == path.path) {
      return;
    }

    await _generateBarrelFor(barrelFilePath, path);
  }

  Future<void> createForFolder(Folder path) async {
    if (!(await _repo.exists(path))) {
      throw ArgumentError('Folder did not exists');
    }

    await _repo.create(
      FsFile("${path.path}$_fileSeparator${path.nameWithType}"),
    );

    if (path.name == _stopFolder) {
      return;
    }

    final rootBarrelFile = _createBarrelFilePath(_requireParentFolder(path));

    await _generateBarrelFor(rootBarrelFile, path);
  }

  Future<void> _generateBarrelFor(FsFile barrelFile, FsEntity file) async {
    try {
      if (await _repo.exists(barrelFile)) {
        await _writeToBarrel(barrelFile, file);
      } else {
        final bytes = _getExportsFrom(
          await _getDirPaths(barrelFile.parentFolder!, barrelFile),
        );

        await _repo.write(barrelFile, bytes);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fileDeleted(FsFile path) async =>
      await _removeFromBarrel(path, _requireParentFolder(path));

  Future<void> folderDeleted(Folder path) async =>
      await _removeFromBarrel(path, _requireParentFolder(path));

  Future<void> folderRenamed(Folder from, Folder to) async {
    final isRename = from.name != to.name;
    final barrel = _createBarrelFilePath(to);

    await folderDeleted(from);

    if(isRename) await _repo.renameFile(barrel.rename(from.name) as FsFile, barrel);
    await _generateBarrelFor(_createBarrelFilePath(_requireParentFolder(to)), to);
  }

  Future<void> _removeFromBarrel(FsEntity path, Folder fileFolder) async {
    final rootBarrel = _createBarrelFilePath(fileFolder);

    final lines = await _repo.readAsLines(rootBarrel);

    final formattedBarrel = lines.where(
      (line) => !line.contains(path.nameWithType),
    );

    await _repo.write(
      rootBarrel,
      Uint8List.fromList(formattedBarrel.join('\n').codeUnits),
    );
  }

  Future<void> _writeToBarrel(FsFile barrelFilePath, FsEntity path) async {
    var fileData = await _repo.read(barrelFilePath);

    bool hasEOF = false;
    final skipToEOF = fileData.length - 2;
    if (skipToEOF > 0) {
      hasEOF = fileData
          .skip(skipToEOF)
          .indexed
          .every((pair) => _newLine == pair.$2);

      if (!hasEOF) {
        fileData = Uint8List.fromList([...fileData, _newLine]);
      }
    }

    int countOfFilesInBarrel = fileData
        .where((byte) => byte == _newLine)
        .length;

    if (hasEOF) {
      countOfFilesInBarrel--;
    }

    final dirFiles = await _getDirPaths(
      barrelFilePath.parentFolder!,
      barrelFilePath,
    );

    if (dirFiles.length > countOfFilesInBarrel) {
      return _repo.write(barrelFilePath, _getExportsFrom(dirFiles));
    }

    final newExport = Uint8List.fromList(_exportPath(path));

    try {
      await _repo.appendToFile(barrelFilePath, newExport);
    } catch (e) {
      throw ArgumentError('write error');
    }
  }

  Uint8List _getExportsFrom(Set<FsEntity> dirFiles) {
    final builder = BytesBuilder();
    for (final path in dirFiles) {
      builder.add(_exportPath(path));
    }
    return builder.toBytes();
  }

  Future<Set<FsEntity>> _getDirPaths(Folder folder, FsFile barrelPath) async {
    return (await _repo.listFolderEntry(
      folder,
    )).where((path) => !_ignoreRepo.isIgnored(path.path) && path.path != barrelPath.path).toSet();
  }

  Uint8List _exportPath(FsEntity path) {
    if (path is FsFile) {
      return _exportFile(path);
    }
    return _exportFolder(path as Folder);
  }

  Uint8List _exportFile(FsFile filePath) {
    return Uint8List.fromList([
      ..."export '${filePath.nameWithType}';".codeUnits,
      _newLine,
    ]);
  }

  Uint8List _exportFolder(Folder filePath) {
    return Uint8List.fromList([
      ...'export \'${filePath.name}$_fileSeparator${filePath.nameWithType}\';'
          .codeUnits,
      _newLine,
    ]);
  }

  FsFile _createBarrelFilePath(Folder folder) {
    return FsFile(folder.path + _fileSeparator + folder.nameWithType);
  }

  Folder _requireParentFolder(FsEntity path) {
    final folder = path.parentFolder;
    if (folder == null) {
      throw ArgumentError('Path "${path.path}" has no parent folder');
    }
    return folder;
  }
}
