import 'package:barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/domain/events/events.dart';
import 'package:barrel_generator/domain/repository/fs_watcher.dart';

class WatchBarrelGeneratorService {
  final FsWatcher _fsEvents;
  final BarrelGeneratorService _g;

  WatchBarrelGeneratorService({required this._fsEvents, required this._g});

  Future<void> watch() async {
    return _fsEvents.getEvents().listen((event) async {
      final path = event.path;
      switch (event) {
        case CreateFileEvent():
          return await _g.createForFile(path as FsFile);
        case CreateFolderEvent():
          return await _g.createForFolder(path as Folder);
        case RenamedFolderEvent():
          break;
        case RemovedFileEvent():
          return await _g.fileDeleted(path as FsFile);
        case RemovedFolderEvent():
          return await _g.folderDeleted(path as Folder);
        case RenamedFileEvent():
          break;
      }
    }).asFuture();
  }
}
