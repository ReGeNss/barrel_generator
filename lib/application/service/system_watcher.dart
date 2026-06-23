import 'dart:io';

import 'package:barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/domain/entity/path.dart';
import 'package:barrel_generator/domain/repository/path_to_ignore_repository.dart';

class SystemWatcher {
  final BarrelGeneratorService generator;
  final PathToIgnoreRepository ignoredPaths; 

  SystemWatcher({required this.generator, required this.ignoredPaths});

  Future<void> watch() async {
    Directory.current.watch(recursive: true).listen((event) {
      event.path; 
      switch (event) {
        case FileSystemCreateEvent(:final path, :final isDirectory):
          if(isDirectory) {
            generator.createForNewFolder(FolderPath(path));
          } else {
            generator.createForNewFile(FilePath(path));
          }
          break;
        case FileSystemModifyEvent(:final path, :final isDirectory):
          print('modify');
          print(path);
          break;
        case FileSystemDeleteEvent(:final path):
          generator.fileDeleted(FilePath(path));
          break;
        case FileSystemMoveEvent(:final path, :final isDirectory):
          print('modify');
          print(path);
          break;
      }
    });
  }
}