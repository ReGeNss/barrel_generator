import 'package:barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/domain/events/events.dart';
import 'package:barrel_generator/domain/repository/fs_watcher.dart';

class WatchBarrelGeneratorService {
  final FsWatcher _fsEvents;
  final BarrelGeneratorService _g;

  WatchBarrelGeneratorService({required this._fsEvents, required this._g});

  Future<void> watch() async {
    return _fsEvents.getEvents().listen((event) async {
      switch (event) {
        case CreateFileEvent(:final file):
          return await _g.createForFile(file);
        case CreateFolderEvent(:final folder):
          return await _g.createForFolder(folder);
        case RenamedFolderEvent(:final folder, :final oldFolder):
          return _g.folderRenamed(folder, oldFolder);
        case RemovedFileEvent(:final file):
          return await _g.fileDeleted(file);
        case RemovedFolderEvent(:final folder):
          return await _g.folderDeleted(folder);
      }
    }).asFuture();
  }
}
