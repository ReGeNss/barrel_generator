import 'dart:ffi';
import 'dart:typed_data';

import 'package:barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/domain/entity/path.dart';
import 'dart:collection';

class BarrelGeneratorService {
  final GeneratorRepositoryImpl _repo;
  final String _stopFolder;
  final String _fileSeparator;

  static final _newLine = Uint8List.fromList('\n'.codeUnits).first;

  BarrelGeneratorService({
    this._stopFolder = 'lib',
    this._fileSeparator = '/',
    required this._repo,
  });

  Future<void> createForFile(FilePath path) async {
    final folder = _requireParentFolder(path);
    final barrelFilePath = _createBarrelFilePath(folder);

    if (barrelFilePath.path == path.path) {
      return;
    }

    try {
      if (await _repo.exists(barrelFilePath)) {
        await _writeToBarrel(barrelFilePath, path);
      } else {
        await _repo.appendToFile(barrelFilePath, _exportFile(path));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createForFolder(FolderPath path) async {
    if (!(await _repo.exists(path))) {
      throw ArgumentError('Folder did not exists');
    }

    await _repo.create(
      FilePath("${path.path}$_fileSeparator${path.nameWithType}"),
    );

    if (path.name == _stopFolder) {
      return;
    }

    final rootBarrelFile = _createBarrelFilePath(_requireParentFolder(path));

    if (!await _repo.exists(rootBarrelFile)) {
      await _repo.appendToFile(rootBarrelFile, _exportFolder(path));
    } else {
      await _writeToBarrel(rootBarrelFile, path);
    }
  }

  Future<void> fileDeleted(FilePath path) async =>
      await _removeFromBarrel(path, _requireParentFolder(path));

  Future<void> folderDeleted(FolderPath path) async =>
      await _removeFromBarrel(path, _requireParentFolder(path));

  Future<void> _removeFromBarrel(Path path, FolderPath fileFolder) async {
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

  Future<void> _writeToBarrel(FilePath barrelFilePath, Path path) async {
    var fileData = await _repo.read(barrelFilePath);

    late final bool hasEOF;
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

    final dirFiles = (await _repo.listFolderEntry(
      barrelFilePath.parentFolder!,
    )).where((path) => path.path != barrelFilePath.path);

    if (dirFiles.length > countOfFilesInBarrel) {
      final builder = BytesBuilder();
      for (final path in dirFiles) {
        builder.add(exportPath(path));
      }

      return _repo.write(barrelFilePath, builder.toBytes());
    }

    final newExport = Uint8List.fromList(exportPath(path));

    try {
      await _repo.appendToFile(barrelFilePath, newExport);
    } catch (e) {
      throw ArgumentError('write error');
    }
  }

  Uint8List exportPath(Path path) {
    if (path is FilePath) {
      return _exportFile(path);
    }
    return _exportFolder(path as FolderPath);
  }

  Uint8List _exportFile(FilePath filePath) {
    return Uint8List.fromList([
      ..."export '${filePath.nameWithType}';".codeUnits,
      _newLine,
    ]);
  }

  Uint8List _exportFolder(FolderPath filePath) {
    return Uint8List.fromList([
      ...'export \'${filePath.name}$_fileSeparator${filePath.nameWithType}\';'
          .codeUnits,
      _newLine,
    ]);
  }

  FilePath _createBarrelFilePath(FolderPath folder) {
    return FilePath(folder.path + r'\' + folder.nameWithType);
  }

  FolderPath _requireParentFolder(Path path) {
    final folder = path.parentFolder;
    if (folder == null) {
      throw ArgumentError('Path "${path.path}" has no parent folder');
    }
    return folder;
  }
}
