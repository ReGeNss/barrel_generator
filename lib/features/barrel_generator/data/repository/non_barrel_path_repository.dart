import 'package:barrel_generator/core/constants.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:injectable/injectable.dart';

@singleton
class NonBarrelPathRepository implements PathToIgnoreRepository {
  final ignoreFolder = <String>{};

  NonBarrelPathRepository(@Named(worDirName) String workDir) {
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
