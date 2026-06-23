import 'dart:typed_data';

import 'package:barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/domain/entity/path.dart';
import "dart:io";
import 'dart:collection';

class BarrelGeneratorService {
  BarrelGeneratorService({this.stopFolder = 'lib', required this.repo, required this.fileSeparator});

  final GeneratorRepositoryImpl repo;

  final String stopFolder;
  final String fileSeparator;

  static final newLine = Uint8List.fromList('\n'.codeUnits);

  Future<void> createForNewFile(FilePath path) async {
    final folder = path.fileFolder;
    final barrelFilePath = _createBarrelFilePath(folder);

    if (barrelFilePath.path == path.path) {
      return;
    }

    try {
      if (await repo.exists(folder)) {
        await _writeToBarrel(barrelFilePath, path);
      } else {
        await repo.appendToFile(barrelFilePath, _exportFile(path));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createForNewFolder(FolderPath path) async {
    if (!(await Directory(path.path).exists())) {
      throw ArgumentError('Folder did not exists');
    }

    await File(
      "${path.path}$fileSeparator${path.nameWithType}",
    ).writeAsBytes(_exportFile(path));

    if (path.name == stopFolder) {
      return;
    }

    final rootBarrelFile = _createBarrelFilePath(path.rootFolder);

    if (!await repo.exists(rootBarrelFile)) {
      await repo.appendToFile(rootBarrelFile, _exportFolder(path));
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

    final lines = await repo.readAsLines(rootBarrel);

    final formattedBarrel = lines.where(
      (line) => !line.contains(path.nameWithType),
    );

    await repo.write(rootBarrel, Uint8List.fromList( formattedBarrel.join('\n').codeUnits));
  }

  Uint8List _exportFile(Path filePath) {
    return Uint8List.fromList([
      ..."export '${filePath.nameWithType}';".codeUnits,
      ...newLine,
    ]);
  }

  Uint8List _exportFolder(Path filePath) {
    return Uint8List.fromList([
      ...'export \'${filePath.name}$fileSeparator${filePath.nameWithType}\''.codeUnits,
      ...newLine,
    ]);
  }

  FilePath _createBarrelFilePath(FolderPath folder) {
    return FilePath(folder.path + r'\' + folder.nameWithType);
  }

  Future<void> _writeToBarrel(FilePath barrelFilePath, Path path) async {
    var fileData = await repo.read(barrelFilePath);

    final skipToEOF = fileData.length - newLine.length - 2;
    if (skipToEOF > 0) {
      final hasEOF = fileData
          .skip(skipToEOF)
          .indexed
          .every((pair) => newLine[pair.$1] == pair.$2);

      if (!hasEOF) {
        fileData = Uint8List.fromList([...fileData, ...newLine]);
      }
    }

    final result = Uint8List.fromList(
      path is FolderPath ? _exportFolder(path) : _exportFile(path),
    );

    try {
      await repo.appendToFile(barrelFilePath, result);
    } catch (e) {
      throw ArgumentError('write error');
    }
  }
}
