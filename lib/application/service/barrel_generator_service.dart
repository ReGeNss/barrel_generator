import 'dart:typed_data';

import 'package:barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/domain/entity/path.dart';
import 'dart:collection';

class BarrelGeneratorService {
  final GeneratorRepositoryImpl _repo;
  final String _stopFolder;
  final String _fileSeparator;

  static final _newLine = Uint8List.fromList('\n'.codeUnits);

  BarrelGeneratorService({
    this._stopFolder = 'lib',
    this._fileSeparator = '/',
    required this._repo,
  });

  Future<void> createForFile(FilePath path) async {
    final folder = path.fileFolder;
    final barrelFilePath = _createBarrelFilePath(folder);

    if (barrelFilePath.path == path.path) {
      return;
    }

    try {
      if (await _repo.exists(folder)) {
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

    final rootBarrelFile = _createBarrelFilePath(path.rootFolder);

    if (!await _repo.exists(rootBarrelFile)) {
      await _repo.appendToFile(rootBarrelFile, _exportFolder(path));
    } else {
      await _writeToBarrel(rootBarrelFile, path);
    }
  }

  Future<void> fileDeleted(FilePath path) async =>
      await _removeFromBarrel(path, path.fileFolder);

  Future<void> folderDeleted(FolderPath path) async =>
      await _removeFromBarrel(path, path.rootFolder);

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

    final skipToEOF = fileData.length - _newLine.length - 2;
    if (skipToEOF > 0) {
      final hasEOF = fileData
          .skip(skipToEOF)
          .indexed
          .every((pair) => _newLine[pair.$1] == pair.$2);

      if (!hasEOF) {
        fileData = Uint8List.fromList([...fileData, ..._newLine]);
      }
    }

    final result = Uint8List.fromList(
      path is FolderPath ? _exportFolder(path) : _exportFile(path),
    );

    try {
      await _repo.appendToFile(barrelFilePath, result);
    } catch (e) {
      throw ArgumentError('write error');
    }
  }

    Uint8List _exportFile(Path filePath) {
    return Uint8List.fromList([
      ..."export '${filePath.nameWithType}';".codeUnits,
      ..._newLine,
    ]);
  }

  Uint8List _exportFolder(Path filePath) {
    return Uint8List.fromList([
      ...'export \'${filePath.name}$_fileSeparator${filePath.nameWithType}\';'
          .codeUnits,
      ..._newLine,
    ]);
  }

  FilePath _createBarrelFilePath(FolderPath folder) {
    return FilePath(folder.path + r'\' + folder.nameWithType);
  }
}
