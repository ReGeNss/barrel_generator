import 'dart:io';

import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';

class ProjectGenerateSource {
  Future<List<Folder>> listDirsInDir(Folder folder) async {
    return (await Directory(folder.path).list().toList())
        .whereType<Directory>()
        .map((dir) => Folder(dir.path))
        .toList();
  }
}
