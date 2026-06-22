import 'dart:typed_data';

import 'package:barrel_generator/domain/entity/path.dart';
import "dart:io";
import 'dart:collection';

class BarrelGeneratorService {
  BarrelGeneratorService({this.stopFolder = 'lib'});

  final String stopFolder;

  static final newLine = Uint8List.fromList('\n'.codeUnits);

  Future<void> createForNewFile(FilePath path) async {
    final folder = path.fileFolder;
    final barrelFile = File(_createBarrelFilePath(folder));

    if (barrelFile.path == path.path) {
      return;
    }

    try {
      if (await barrelFile.exists()) {
        await _writeToBarrel(barrelFile, path);
      } else {
        await barrelFile.writeAsBytes(_exportFile(path));
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
      "${path.path}\\${path.nameWithType}",
    ).writeAsBytes(_exportFile(path));

    if (path.name == stopFolder) {
      return;
    }

    final rootBarrelFile = File(_createBarrelFilePath(path.rootFolder));

    if (!await rootBarrelFile.exists()) {
      await rootBarrelFile.writeAsBytes(_exportFolder(path));
    } else {
      await _writeToBarrel(rootBarrelFile, path);
    }
  }

  Future<void> fileDeleted(FilePath path) async =>
      await _removeFromBarrel(path, path.fileFolder);

  Future<void> folderDeleted(FolderPath path) async =>
      await _removeFromBarrel(path, path.rootFolder);

  Future<void> _removeFromBarrel(Path path, FolderPath fileFolder) async {
    final rootBarrel = File(_createBarrelFilePath(fileFolder));

    final lines = await rootBarrel.readAsLines();

    final formattedBarrel = lines.where(
      (line) => !line.contains(path.nameWithType),
    );

    await rootBarrel.writeAsString(formattedBarrel.join('\n'));
  }

  Uint8List _exportFile(Path filePath) {
    return Uint8List.fromList([
      ..."export '${filePath.nameWithType}';".codeUnits,
      ...newLine,
    ]);
  }

  Uint8List _exportFolder(Path filePath) {
    return Uint8List.fromList([
      ...'export \'${filePath.name}\\${filePath.nameWithType}\''.codeUnits,
      ...newLine,
    ]);
  }

  String _createBarrelFilePath(FolderPath folder) {
    return folder.path + r'\' + folder.nameWithType;
  }

  Future<void> _writeToBarrel(File barrelFile, Path path) async {
    var fileData = await barrelFile.readAsBytes();

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
      barrelFile.writeAsBytes(result, flush: true, mode: .writeOnlyAppend);
    } catch (e) {
      throw ArgumentError('write error');
    }
  }
}
