import 'package:barrel_generator/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:barrel_generator/features/features.dart';

@singleton
class NonBarrelPathRepository implements PathToIgnoreRepository {
  final ignoreFolder = <String>{};

  NonBarrelPathRepository(@Named(wokDirName) String workDir) {
    ignoreFolder.add(workDir);
  }

  @override
  bool isIgnored(String path) {
    final entity = FsEntity.fromPath(path);

    final folder = entity.parentFolder;

    for (final folderPath in ignoreFolder) {
      if (folder?.path.endsWith(folderPath) == true) {
        return true;
      }
    }
    return false;
  }
}
