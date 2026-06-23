import 'package:barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/domain/entity/path.dart';
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
          return await _g.createForFile(path as FilePath);
        case CreateFolderEvent():
          return await _g.createForFolder(path as FolderPath);
        case RenamedFolderEvent():
        case RemovedFileEvent():
        case RemovedFolderEvent():
        case RenamedFileEvent():
      }
    }).asFuture();
  }
}
