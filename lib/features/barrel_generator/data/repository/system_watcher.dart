import 'dart:io';

import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/events/events.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/fs_watcher.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: FsWatcher)
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
                  return Event.createdFolder(folder: Folder(path));
                } else {
                  return Event.createdFile(file: FsFile(path));
                }
              case FileSystemModifyEvent():
                return null;
              case FileSystemDeleteEvent(:final path):
                final entity = FsEntity.fromPath(path);
                if (entity is Folder) {
                  return Event.removedFolder(folder: entity);
                }
                return Event.removedFile(file: FsFile(path));
              case FileSystemMoveEvent(
                :final path,
                :final destination,
                :final isDirectory,
              ):
                if (destination == null || !isDirectory) return null;

                if (isDirectory) {
                  return Event.renamedFolder(
                    folder: Folder(destination),
                    oldFolder: Folder(path),
                  );
                }
            }
          }();
          return [?result];
        });
  }
}
