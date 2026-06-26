import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/data/sources/project_generate_source.dart';
import 'package:injectable_generator/utils.dart';
import '../../domain/entity/fs_entity.dart';

class ProjectGenerateSourceMock implements ProjectGenerateSource {
  final MFolder? root;

  ProjectGenerateSourceMock(Map<String, dynamic>? tree):  root = tree != null ?  MFolder.generate(tree) : null;

  @override
  Future<List<FsEntity>> listDirEntry(Folder folder) async {
    if (root == null) return [];
    
    final a = _get(folder) as MFolder;

    return a.entries.map((e) => e is MFolder ? Folder(e.path): FsFile(e.path)).toList();
  }

  MFsEntity? _get(FsEntity path) {
    MFolder curFolder = MFolder('/', '/', entries: [root!]);

    for (final route in path.path.split('/')) {
      final res = curFolder.entries.firstWhereOrNull((e) => e.route == route);

      if (res == null) {
        return null;
      }

      if (res is MFile) {
        if (path.nameWithType == res.route) {
          return res;
        }
        return null;
      }

      curFolder = res as MFolder;
    }
    return curFolder;
  }
}
