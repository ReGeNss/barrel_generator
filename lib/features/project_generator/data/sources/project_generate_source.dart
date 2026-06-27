import 'dart:io';

import 'package:barrel_generator/features/features.dart';
import 'package:injectable/injectable.dart';

@singleton
class ProjectGenerateSource {
  Future<List<FsEntity>> listDirEntry(Folder folder) async {
    return (await Directory(folder.path).list().toList())
        .map((e) => e is Directory ?  Folder(e.path) : FsFile(e.path))
        .toList();
  }
}
