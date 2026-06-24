import 'dart:io';

import 'package:barrel_generator/domain/entity/fs_entity.dart';
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
        .expand((event) {
          print(event);
          final result = () {
            switch (event) {
              case FileSystemCreateEvent(:final path, :final isDirectory):
                if (isDirectory) {
                  return Event.createdFolder(path: Folder(path));
                } else {
                  return Event.createdFile(path: FsFile(path));
                }
              case FileSystemModifyEvent():
                return null;
              case FileSystemDeleteEvent(:final path):
                final entity = FsEntity.fromPath(path);
                if (entity is Folder) {
                  return Event.removedFolder(path: entity);
                }
                return Event.removedFile(path: FsFile(path));
              case FileSystemMoveEvent(
                :final path,
                :final destination,
                :final isDirectory,
              ):
                if (destination == null || !isDirectory) return null;

                if (isDirectory) {
                  return Event.renamedFolder(
                    path: Folder(destination),
                    oldLocation: Folder(path),
                  );
                }
            }
          }();
          return [?result];
        });
  }
}
