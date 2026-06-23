import 'dart:io';

import 'package:barrel_generator/domain/entity/path.dart';
import 'package:barrel_generator/domain/events/events.dart';
import 'package:barrel_generator/domain/repository/fs_watcher.dart';
import 'package:barrel_generator/domain/repository/path_to_ignore_repository.dart';

class SystemWatcher implements FsWatcher {
  final PathToIgnoreRepository ignoredPaths;

  SystemWatcher({required this.ignoredPaths});

  @override
  Stream<Event> getEvents() {
    return Directory.current
        .watch(recursive: true)
        .where((event) => !ignoredPaths.isIgnored(event.path))
        .map((event) {
          print(event);
          switch (event) {
            case FileSystemCreateEvent(:final path, :final isDirectory):
              if (isDirectory) {
               return Event.createdFolder(path: FolderPath(path));
              } else {
                return Event.createdFile(path: FilePath(path));
              }
            case FileSystemModifyEvent(:final path, :final isDirectory):
              return .renamedFile(path: FilePath(path), oldLocation: FilePath(path));
              break;
            case FileSystemDeleteEvent(:final path):
              return Event.removedFile(path: FilePath(path));
            case FileSystemMoveEvent(:final path, :final isDirectory):
              return .renamedFile(path: FilePath(path), oldLocation: FilePath(path));
              break;
          }
        });
  }
}
